/**
 *   @file CCFColorView.h
 *   @author Alan Duncan (www.cocoafactory.com)
 *
 *   @date 2013-09-29 21:30:51
 *
 *   @note Copyright 2013 Cocoa Factory, LLC.  All rights reserved
 */

@interface CCFColorView : UIView

@property (nonatomic, weak) IBOutlet UIView *swatchView;
@property (nonatomic, weak) IBOutlet UILabel *frenchLabel;
@property (nonatomic, weak) IBOutlet UILabel *englishLabel;
@property (nonatomic, strong) CCFURLResponderBlock completionBlock;

@end
