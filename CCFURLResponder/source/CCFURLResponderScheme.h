/**
 *   @file CCFURLResponderScheme.h
 *   @author Alan Duncan (www.cocoafactory.com)
 *
 *   @date 2013-09-29 06:18:51
 *
 *   @note Copyright 2013 Cocoa Factory, LLC.  All rights reserved
 */

@interface CCFURLResponderScheme : NSObject

@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, copy) NSArray *types;
@property (nonatomic, copy) NSArray *literals;

- (BOOL)setPattern:(NSString *)pattern error:(NSError *__autoreleasing *)error;
- (NSNotification *)notificationWithURL:(NSURL *)url;

@end
