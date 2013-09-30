#import "CCFURLResponder.h"
#import "CCFURLResponderScheme.h"

static NSMutableArray *Schemes;
__attribute__((constructor))
void InitSchemes(void)
{
    Schemes = [NSMutableArray array];
}

@implementation CCFURLResponder

+ (BOOL)registerSchemeWithPattern:(NSString *)pattern forNotificationName:(NSString *)notification error:(NSError *__autoreleasing *)error {
    NSParameterAssert(pattern);
    NSParameterAssert(notification);
    
    CCFURLResponderScheme *scheme = [[CCFURLResponderScheme alloc] init];
    scheme.notificationName = notification;
    if( ![scheme setPattern:pattern error:error] ) {
        return NO;
    }
    [Schemes addObject:scheme];
    return YES;
}

+ (NSNotification *)notificationWithURL:(NSURL *)url {
    for( CCFURLResponderScheme *scheme in Schemes) {
        NSNotification *note = [scheme notificationWithURL:url];
        if( note ) {
            return note;
        }
    }
    return nil;
}

+ (BOOL)processURL:(NSURL *)url {
    NSNotification *note = [self notificationWithURL:url];
    if( note ) {
        [[NSNotificationCenter defaultCenter] postNotification:note];
        return YES;
    }
    return NO;
}

+ (void)resetSchemes {
    Schemes = [NSMutableArray array];
}

@end
