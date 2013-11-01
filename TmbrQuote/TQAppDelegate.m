//
//  TQAppDelegate.m
//  TmbrQuote
//
//  Created by monoqlo on 2013/08/28.
//  Copyright (c) 2013年 米山 隆貴. All rights reserved.
//

#import "TQAppDelegate.h"
#import "TQWebViewController.h"

@implementation TQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    BOOL isAuthentificated = [[TQTmbrManager sharedInstance] isAuthentificated];
    if (!isAuthentificated) {
        [[TQTmbrManager sharedInstance] authentifiacte];
    }
    
//    // URLスキームで起動した場合にURLを読み込む
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    TQWebViewController *webVC = [storyBoard instantiateViewControllerWithIdentifier:@"TQWebViewController"];
//    [[NSNotificationCenter defaultCenter] addObserver:webVC selector:@selector(loadURL:) name:TQ_LOAD_URL object:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"tumblr-authorize"])
        return [[TMAPIClient sharedInstance] handleOpenURL:url];
    
    if ([url.host isEqualToString:@"open_url"]) {
        // tmbrquote://open_url?url=http://hogehoge.com
        NSLog(@"%@", url);
        return [[TQTmbrManager sharedInstance] handleOpenURL:url];
    }
    
    NSLog(@"no host");
    
    return NO;
}

//#pragma mark - NSNotification Observer
//-(void)loadURL:(NSNotification *)notification
//{
//    NSDictionary *urlDic = [notification userInfo];
//    
//    NSString *urlStr = urlDic[@"url"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    TQWebViewController *webVC = [storyBoard instantiateViewControllerWithIdentifier:@"TQWebViewController"];
////    [self presentViewController:webVC animated:YES completion:^{}];
//    [webVC.webView loadRequest:[NSURLRequest requestWithURL:url]];
//}


@end
