//
//  TQEditorViewController.m
//  TmbrQuote
//
//  Created by monoqlo on 2013/08/28.
//  Copyright (c) 2013年 米山 隆貴. All rights reserved.
//

#import "TQEditorViewController.h"

@interface TQEditorViewController ()

@property (weak, nonatomic) IBOutlet UITextView *quoteTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
- (IBAction)postToTumblr:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation TQEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.quoteTextView becomeFirstResponder];
    
    self.quoteTextView.text = self.source[@"text"];
    self.titleTextField.text = self.source[@"title"];
    self.urlTextField.text = self.source[@"url"];
    
    [[TMAPIClient sharedInstance] userInfo:^(id response, NSError *error) {
        if (error) {
            NSLog(@"Error");
            if (error.code == 401) {
                [[NSNotificationCenter defaultCenter] postNotificationName:TQ_RE_AUTHENTIFICATION object:self userInfo:nil];
            }
        } else {
            NSLog(@"%@", response);
        }}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)postToTumblr:(id)sender {
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:TQ_USERNAME];
    
    NSString *source = nil;
    if (self.urlTextField.text.length && self.titleTextField.text.length) {
        source = [NSString stringWithFormat:@"<a href=%@>%@</a>", self.urlTextField.text, self.titleTextField.text];
    }
    
    [[TMAPIClient sharedInstance] quote:username
                             parameters:@{@"quote":self.quoteTextView.text, @"source":source}
                               callback:^(id response, NSError *error) {
                                   if (error) {
                                       NSLog(@"Error posting to Tumblr");
                                       
                                   } else {
                                       NSLog(@"Posted to Tumblr");
                                   }
                                   
                                   [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
