CCFURLResponder
===============

Create NSNotification objects from received URL's.  iOS applications can receive and handle URL requests.  The method `application:openURL:sourceApplication:annotation:` is used to ask the iOS application delegate to open a resource identifed by a URL.  This mechanism is often used to allow applications to communicate with one another through a custom protocol.

But how does a URL message get translated into an action in the application?  `CCFURLResponder` allows the developer to register one or more URL patterns that it can handle; and translates those patterns into `NSNotification` objects that can be posted to the `NSNotificationCenter`.

### URL pattern syntax ###

Right now, `CCFURLResponder` knows how to respond deal with 4 types of path components, __string__, __literal__, __integer__, and __float__.
