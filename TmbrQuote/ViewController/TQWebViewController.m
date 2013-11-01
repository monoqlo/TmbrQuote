//
//  TQWebViewController.m
//  TmbrQuote
//
//  Created by monoqlo on 2013/08/29.
//  Copyright (c) 2013年 米山 隆貴. All rights reserved.
//

#import "TQWebViewController.h"
#import "TQEditorViewController.h"

@interface TQWebViewController ()

@property (nonatomic) NSDictionary *source;

- (IBAction)showEditor:(id)sender;
- (IBAction)auth:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;

@end

@implementation TQWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadURL:) name:TQ_LOAD_URL object:nil];
    
    NSString *urlStr = @"http://google.co.jp";
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showEditor:(id)sender {
    NSString *url = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *selectedText = [self.webView stringByEvaluatingJavaScriptFromString:@"\
                              var e = document.createElement('div');\
                              e.appendChild(window.getSelection().getRangeAt(0).cloneContents());\
                              e.innerHTML"];
    
    self.source = @{@"url": url, @"title":title, @"text": selectedText};
    
    [self performSegueWithIdentifier:@"ToPostQuote" sender:self];
}

- (IBAction)auth:(id)sender {
    [[TMAPIClient sharedInstance] authenticate:@"tmbrquote" callback:^(NSError *error) {
        if (error)
            NSLog(@"Authentication failed: %@ %@", error, [error description]);
        else
            NSLog(@"Authentication successful!");
    }];
}

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    
    if ( [segue.identifier isEqualToString:@"ToPostQuote"] ) {
        UINavigationController *navVC = (UINavigationController *)[segue destinationViewController];
        TQEditorViewController *editorVC = (TQEditorViewController *)navVC.childViewControllers[0];
        editorVC.source = self.source;
    }
}

#pragma mark - NSNotification Observer
-(void)loadURL:(NSNotification *)notification
{
    NSDictionary *urlDic = [notification userInfo];
    
    NSString *urlStr = urlDic[@"url"];
    BOOL hasHTTPstr = [urlStr hasPrefix:@"http://"];
    if (!hasHTTPstr) {
        urlStr = [NSString stringWithFormat:@"http://%@", urlStr];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
