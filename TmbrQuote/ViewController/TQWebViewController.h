//
//  TQWebViewController.h
//  TmbrQuote
//
//  Created by monoqlo on 2013/08/29.
//  Copyright (c) 2013年 米山 隆貴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void)loadURL:(NSNotification *)notification;

@end
