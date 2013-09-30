#import "CCFViewController.h"

@interface CCFViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation CCFViewController

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

@end
