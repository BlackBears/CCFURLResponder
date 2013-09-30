#import "CCFViewController.h"

#import "CCFColorView.h"
#import "CCFAnimalView.h"

@interface CCFViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation CCFViewController

- (void)awakeFromNib {
    __block id colorReceived = nil;
    colorReceived = [[NSNotificationCenter defaultCenter] addObserverForName:@"CCFColorNotification"
                                                                      object:nil
                                                                       queue:nil
                                                                  usingBlock:^(NSNotification *note) {
                                                                      NSLog(@"%s - color notification",__FUNCTION__);
                                                                      UINib *colorViewNib = [UINib nibWithNibName:@"CCFColorView" bundle:nil];
                                                                      CCFColorView *colorView = [colorViewNib instantiateWithOwner:self options:nil][0];
                                                                      [[self view] addSubview:colorView];
                                                                      colorView.center = self.view.center;
                                                                      colorView.englishLabel.text = note.userInfo[@"CCFEnglishWord"];
                                                                      colorView.frenchLabel.text = note.userInfo[@"CCFFrenchWord"];
                                                                      colorView.swatchView.backgroundColor = [self colorWithNotification:note];
                                                                      __weak typeof(colorView)weakColorView = colorView;
                                                                      colorView.completionBlock = ^{
                                                                          [UIView animateWithDuration:0.3
                                                                                           animations:^{
                                                                                               weakColorView.alpha = 0.0f;
                                                                                           }
                                                                                           completion:^(BOOL finished) {
                                                                                               [weakColorView removeFromSuperview];
                                                                                           }];
                                                                      };
                                                                  }];
    
    __block id animalReceived = nil;
    animalReceived = [[NSNotificationCenter defaultCenter] addObserverForName:@"CCFAnimalNotification"
                                                                       object:nil
                                                                        queue:nil
                                                                   usingBlock:^(NSNotification *note) {
                                                                       NSLog(@"%s - animal notification",__FUNCTION__);
                                                                       UINib *animalViewNib = [UINib nibWithNibName:@"CCFAnimalView" bundle:nil];
                                                                       CCFAnimalView *animalView = [animalViewNib instantiateWithOwner:self options:nil][0];
                                                                       [[self view] addSubview:animalView];
                                                                       animalView.center = self.view.center;
                                                                       animalView.imageView.image = [self animalImageWithNotification:note];
                                                                       animalView.nameLabel.text = note.userInfo[@"CCFAnimal"];
                                                                       animalView.detailLabel.text = [self animalDescriptionWithNotification:note];
                                                                       __weak typeof(animalView)weakAnimalView = animalView;
                                                                       animalView.completionBlock = ^{
                                                                           [UIView animateWithDuration:0.3
                                                                                            animations:^{
                                                                                                weakAnimalView.alpha = 0.0f;
                                                                                            }
                                                                                            completion:^(BOOL finished) {
                                                                                                [weakAnimalView removeFromSuperview];
                                                                                            }];
                                                                       };
                                                                   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] addSubview:[self webView]];
    
    //  load our sample html
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test_doc" withExtension:@"html"];
    [[self webView] loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - Private

- (UIWebView *)webView {
    if( !_webView ) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = ~UIViewAutoresizingNone;
    }
    return _webView;
}

- (UIColor *)colorWithNotification:(NSNotification *)note {
    NSString *colorName = note.userInfo[@"CCFEnglishWord"];
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{@"red"      : [UIColor redColor],
                @"green"    : [UIColor greenColor],
                @"blue"     : [UIColor blueColor],
                @"yellow"   : [UIColor yellowColor]};
    });
    return map[colorName];
}

- (UIImage *)animalImageWithNotification:(NSNotification *)note {
    NSString *animalName = note.userInfo[@"CCFAnimal"];
    static NSDictionary *animalMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animalMap = @{@"spiny anteater"   : @"anteater",
                      @"platypus"         : @"platypus"};
    });
    return [UIImage imageNamed:animalMap[animalName]];
}

- (NSString *)animalDescriptionWithNotification:(NSNotification *)note {
    NSInteger weight = [note.userInfo[@"CCFAverageWeight"] integerValue];
    float lifeExpectancy = [note.userInfo[@"CCFAverageLifeExpectancy"] floatValue];
    return [NSString stringWithFormat:@"(%d kg, %0.1f yrs)",weight, lifeExpectancy];
}

@end
