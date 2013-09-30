/**
 *   @file CCFURLResponderScheme.h
 *   @author Alan Duncan (www.cocoafactory.com)
 *
 *   @date 2013-09-29 06:18:51
 *
 *   @note Copyright 2013 Cocoa Factory, LLC.  All rights reserved
 */

/**
 *	CCFURLResponderScheme instances encapsulate the properties and methods of a class of objects that represent an incoming URL
 *  to which the application can respond.
 */
@interface CCFURLResponderScheme : NSObject

/**
 *	The name of the notification generated when the pattern matches a URL
 */
@property (nonatomic, copy) NSString *notificationName;

/**
 *	An array of userInfo keys that are attached to the \c NSNotification object
 */
@property (nonatomic, copy) NSArray *keys;

/**
 *	An array of pattern component types
 */
@property (nonatomic, copy) NSArray *types;

/**
 *	An array of pattern component literals, if applicable.
 */
@property (nonatomic, copy) NSArray *literals;

/**
 *	Sets the pattern.
 *
 *
 *	@param	pattern	The string pattern from which to create the scheme
 *	@param	error	An option \c NSError object
 *
 *	@return	Returns \c YES if the pattern could be parsed, otherwise \c NO
 */
- (BOOL)setPattern:(NSString *)pattern error:(NSError *__autoreleasing *)error;

/**
 *	Creates a notification from the URL provided
 *
 *	@param	url	The URL to parse for a match
 *
 *	@return	Returns the notification if the pattern matches, otherwise \c nil.
 */
- (NSNotification *)notificationWithURL:(NSURL *)url;

@end
