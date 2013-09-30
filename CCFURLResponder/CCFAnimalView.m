#import "CCFAnimalView.h"

@implementation CCFAnimalView

static CCFAnimalView *commonInit(CCFAnimalView *self)
{
    self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = (CGSize){ .width = 0, .height = 1 };
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:tapRecognizer];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( !self ) return nil;
    
    return commonInit(self);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( !self ) return nil;
    
    return commonInit(self);
}

#pragma mark - Private

- (void)removeView:(UIGestureRecognizer *)recognizer {
    if( self.completionBlock )
        self.completionBlock();
}

@end
