/**
 *   @file CCFURLResponder.h
 *   @author Alan Duncan (www.cocoafactory.com)
 *
 *   @date 2013-09-28 21:05:36
 *
 *   @note Copyright 2013 Cocoa Factory, LLC.  All rights reserved
 */

@interface CCFURLResponder : NSObject

+ (BOOL)registerSchemeWithPattern:(NSString *)pattern forNotificationName:(NSString *)notification error:(NSError *__autoreleasing *)error;
+ (BOOL)processURL:(NSURL *)url;
+ (NSNotification *)notificationWithURL:(NSURL *)url;
+ (void)resetSchemes;

@end
