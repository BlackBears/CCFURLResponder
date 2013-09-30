/**
 *   @file CCFURLResponder.h
 *   @author Alan Duncan (www.cocoafactory.com)
 *
 *   @date 2013-09-28 21:05:36
 *
 *   @note Copyright 2013 Cocoa Factory, LLC.  All rights reserved
 */

/**
 *	CCFURLResponder encapsulates the methods that allow applications to declare patterns of URLs to which they respond
    and generate \c NSNotification objects that can be posted in a notification center, allowing classes in the 
    application to respond to received URL events.
 */
@interface CCFURLResponder : NSObject

/**
 *	Register a scheme
 *
 *	@param	pattern	The pattern string for the scheme.  Patterns adhere to a simple but strict format langage.  Path components are designated by single '/' characters.  Within 
 *                  each component, there must be a single type character from the set \b s, \b l, \b i, \b f for string, literal, integer, and float, respectively.  For string, integer,
                    and float components, the component patterns will look like: \c /s:YourStringKeyName/i:YourIntegerKeyName/f:YourFloatKeyName.  The keys become dictionary keys in the \c NSNotification
 *                  userInfo dictionary.  In the case of literals, the pattern syntax is slightly different:  \c /l:(animal)AnimalPathKey
 *	@param	notification	The notification name for this pattern.
 *	@param	error	An optional error object.
 *
 *	@return	Returns \c YES if the registration succeeds, otherwise \c NO.
 */
+ (BOOL)registerSchemeWithPattern:(NSString *)pattern forNotificationName:(NSString *)notification error:(NSError *__autoreleasing *)error;

/**
 *	Process an incoming URL
 *
 *  Looks for a scheme pattern that matches the URL.  If a pattern is found then create a notification for the pattern and 
 *  post the notification to the default notification center.
 *
 *	@param	url	The NSURL object to process
 *
 *	@return	Returns \c YES if the URL could be processed, otherwise \c NO.
 */
+ (BOOL)processURL:(NSURL *)url;

/**
 *	Searches for a pattern matching the provided URL.  If a match is found, creates an \c NSNotification object according
 *  to the pattern specifications.
 *
 *	@param	url	The URL to match.
 *
 *	@return	Returns an \c NSNotification object if the pattern matches a known scheme.  Otherwise, returns \c nil.
 */
+ (NSNotification *)notificationWithURL:(NSURL *)url;

/**
 *	Removes all registered schemes.
 */
+ (void)resetSchemes;

@end
