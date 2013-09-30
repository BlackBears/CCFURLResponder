#import "CCFURLResponderScheme.h"

typedef NS_ENUM(NSInteger, CCFURLResponderSchemeComponentsType) {
    CCFURLResponderSchemeComponentsTypeUndefined = NSIntegerMin,
    CCFURLResponderSchemeComponentsTypeString = 0,
    CCFURLResponderSchemeComponentsTypeInteger,
    CCFURLResponderSchemeComponentsTypeFloat,
    CCFURLResponderSchemeComponentsTypeLiteral
};

static NSRegularExpression *IntegerRegex;
static NSRegularExpression *FloatRegex;
__attribute__((constructor))
void InitRegexen(void)
{
    IntegerRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:NULL];
    FloatRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d+\\.\\d+" options:0 error:NULL];
}

@interface CCFURLResponderScheme ()
@property (nonatomic, strong) NSMutableDictionary *mutableLiterals;
@end

@implementation CCFURLResponderScheme

- (instancetype)init {
    self = [super init];
    if( !self ) return nil;
    
    self.mutableLiterals = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (BOOL)setPattern:(NSString *)pattern error:(NSError *__autoreleasing *)error {
    //  error handler
    __block BOOL parseError = NO;
    void (^errorHandler)(NSInteger code, NSString *errorDetailString) = ^(NSInteger code, NSString *errorDetailString){
        if( error )
            *error = [[NSError alloc] initWithDomain:@"CCFAppDomain" code:code userInfo:@{@"CCFErrorDetail": errorDetailString}];
        parseError = YES;
    };
    
    //  split the pattern into components
    NSArray *patternComponents = [pattern componentsSeparatedByString:@"/"];
    if( patternComponents.count == 0 ) {
        errorHandler(101, @"Pattern has no components");
        return NO;
    }
    NSMutableArray *mutableKeys = [NSMutableArray arrayWithCapacity:patternComponents.count];
    NSMutableArray *mutableTypes = [NSMutableArray arrayWithCapacity:patternComponents.count];
    for( NSString *component in patternComponents ) {
        NSString *typeString = nil;
        NSString *keyString, *literalString;
        CCFURLResponderSchemeComponentsType type = CCFURLResponderSchemeComponentsTypeUndefined;
        NSScanner *scanner = [NSScanner scannerWithString:component];
        if( [scanner scanUpToString:@":" intoString:&typeString] ) {
            type = [self componentTypeWithString:typeString];
            if( type == CCFURLResponderSchemeComponentsTypeLiteral ) {
                [scanner scanUpToCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:NULL];
                if( [scanner scanUpToString:@")" intoString:&literalString] ) {
                    [scanner scanUpToCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:NULL];
                    if( ![scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&keyString] ) {
                        errorHandler(103,@"Pattern parse error");
                        return NO;
                    }
                    else {
                        [[self mutableLiterals] setObject:literalString forKey:keyString];
                        //self.mutableLiterals[keyString] = literalString;
                    }
                }
                else {
                    errorHandler(103,@"Pattern parse error");
                    return NO;
                }
            }
            else {
                [scanner scanString:@":" intoString:NULL];
                [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&keyString];
            }
        }
        
//        CCFURLResponderSchemeComponentsType type;
//        if( [typeString isEqualToString:@"s"] )
//            type = CCFURLResponderSchemeComponentsTypeString;
//        else if( [typeString isEqualToString:@"i"] )
//            type = CCFURLResponderSchemeComponentsTypeInteger;
//        else if( [typeString isEqualToString:@"f"] )
//            type = CCFURLResponderSchemeComponentsTypeFloat;
//        else if( [typeString isEqualToString:@"l"] ) {
//            type = CCFURLResponderSchemeComponentsTypeLiteral;
//        }
//        else {
//            *error = [[NSError alloc] initWithDomain:@"CCFAppDomain" code:102 userInfo:@{@"CCFErrorDetail": @"Incorrect path component type"}];
//            return NO;
//        }
        [mutableKeys addObject:keyString];
        [mutableTypes addObject:[NSNumber numberWithInteger:type]];
    }
    self.keys = [NSArray arrayWithArray:mutableKeys];
    self.types = [NSArray arrayWithArray:mutableTypes];
    
    return YES;
}

- (NSNotification *)notificationWithURL:(NSURL *)url {
    NSParameterAssert(url);
    //  quick check on the url to see if it has the right number of components
    NSMutableArray *tempComponents = [NSMutableArray arrayWithObject:url.host];
    [tempComponents addObjectsFromArray:url.pathComponents];
    [tempComponents filterUsingPredicate:[NSPredicate predicateWithFormat:@"self != %@",@"/"]];
    NSArray *components = [NSArray arrayWithArray:tempComponents];
    if( components.count != self.keys.count )
        return nil;
    
    NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionary];
    __block BOOL success = YES;
    [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
        //  see if we can make this into the type specified
        CCFURLResponderSchemeComponentsType type = [self.types[idx] integerValue];
        switch( type) {
            case CCFURLResponderSchemeComponentsTypeString:
                mutableUserInfo[self.keys[idx]] = component;
                break;
            case CCFURLResponderSchemeComponentsTypeInteger: {
                NSTextCheckingResult *result = [IntegerRegex firstMatchInString:component options:0 range:NSMakeRange(0, component.length)];
                if( result )
                    mutableUserInfo[self.keys[idx]] = [NSNumber numberWithInteger:component.integerValue];
                else {
                    success = NO;
                    *stop = YES;
                }
                break;
            }
            case CCFURLResponderSchemeComponentsTypeFloat: {
                NSTextCheckingResult *result = [FloatRegex firstMatchInString:component options:0 range:NSMakeRange(0, component.length)];
                if( result )
                    mutableUserInfo[self.keys[idx]] = [NSNumber numberWithFloat:component.floatValue];
                else {
                    success = NO;
                    *stop = YES;
                }
                break;
            }
            case CCFURLResponderSchemeComponentsTypeLiteral: {
                mutableUserInfo[self.keys[idx]] = component;
                break;
            }
            default: {
                break;
            }
        }
    }];
    if( !success ) { return nil; }
    NSNotification *note = [[NSNotification alloc] initWithName:self.notificationName object:nil userInfo:mutableUserInfo];
    return note;
}

#pragma mark - Private

- (CCFURLResponderSchemeComponentsType)componentTypeWithString:(NSString *)typeString {
    static NSDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{@"s": [NSNumber numberWithInteger:CCFURLResponderSchemeComponentsTypeString],
                @"i": [NSNumber numberWithInteger:CCFURLResponderSchemeComponentsTypeInteger],
                @"f": [NSNumber numberWithInteger:CCFURLResponderSchemeComponentsTypeFloat],
                @"l": [NSNumber numberWithInteger:CCFURLResponderSchemeComponentsTypeLiteral]};
    });
    return [map[typeString] integerValue];
}
        
        

@end
