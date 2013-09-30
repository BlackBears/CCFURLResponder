/**
 *   @file CCFAnimalView.h
 *   @author Alan Duncan (www.cocoafactory.com)
 *
 *   @date 2013-09-30 04:45:06
 *
 *   @note Copyright 2013 Cocoa Factory, LLC.  All rights reserved
 */

@interface CCFAnimalView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) CCFURLResponderBlock completionBlock;

@end
