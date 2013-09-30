CCFURLResponder
===============

Create `NSNotification` objects from received URL's.  iOS applications can receive and handle URL requests.  The method `application:openURL:sourceApplication:annotation:` is used to ask the iOS application delegate to open a resource identifed by a URL.  This mechanism is often used to allow applications to communicate with one another through a custom protocol.

But how does a URL message get translated into an action in the application?  `CCFURLResponder` allows the developer to register one or more URL patterns that it can handle; and translates those patterns into `NSNotification` objects that can be posted to the `NSNotificationCenter`.

### URL pattern syntax ###

Right now, `CCFURLResponder` knows how to respond deal with 4 types of path components, __string__, __literal__, __integer__, and __float__.  These are designated in patterns as __s__, __l__, __i__, and __f__ respectively.  For literal path components, we try to match the exact text.  For the other pattern component types, we try to match generically.  Each pattern component must have a key (like `s:YourKeyName`) because the values that the pattern matches will be entered in the `NSNotification` userInfo dictionary under that key name.  Makes sense?

#### Some pattern examples ####

The pattern `/l:(animal)MyAnimalDomainKey/s:MyAnimalNameKey/f:MyAverageWeightKey` would match a URL of the form `ccfurlresponder://animal/platypus/8.0`

The pattern `/s:MyColorNameKey/f:MyRedKey/f:MyGreenKey/f:MyBlueKey` would match a URL like: `ccfurlresponder://Pure%20red/1.0/0.0/0.0`

### How to register patterns ###

Register patterns early in the application life cycle, like so:

``` objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSError *error = nil;
    NSString *pattern = @"l:(animal)CCFAnimalDomain/s:CCFAnimal/f:CCFAverageWeight/i:CCFAverageLifeExpectancy";
    if( ![CCFURLResponder registerSchemeWithPattern:pattern forNotificationName:@"CCFAnimalNotification" error:&error] )
        NSLog(@"%s - error registering pattern %@,%@",__FUNCTION__,error, error.userInfo);
    //  register another pattern
    pattern = @"l:(color)CCFColorDomain/s:CCFEnglishWord/s:CCFFrenchWord";
    if( ![CCFURLResponder registerSchemeWithPattern:pattern forNotificationName:@"CCFColorNotification" error:&error] )
        NSLog(@"%s - error registering pattern %@,%@",__FUNCTION__,error, error.userInfo);
    return YES;
}
```

### How to respond to incoming URL requests ###

``` objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if( !url ) { return NO; }
    //  bail quickly if this is just ccfurlresponder://open
    if( [[url host] isEqualToString:@"open"] )
        return YES;
    if( [[url scheme] isEqualToString:@"ccfurlresponder"] ) {
        [CCFURLResponder processURL:url];
    }
    return YES;
}
```

Note that these examples assume that your application has registered the URL scheme "ccfurlresponder".  You set this on the target in Xcode.  

### Getting started ###

The best way is to download the repository and build the sample application, which presents a web view with some links you can tap.  You can examine the html file `test_doc.html` to look at the URLs to give you an idea about how they're formatted.

Next, take look at the application delegate to see how we register URL patterns and route incoming requests.

Finally, the main view controller `CCFViewController` shows how to respond to the generated `NSNotification` messages.

### Caveats ###

When you register a pattern, we do __not__ check for conflicts.  The first pattern wins.  We'll get around to fixing that someday.  Or you can help.  Also, this probably works on Mac OS; it just hasn't been tested yet.
