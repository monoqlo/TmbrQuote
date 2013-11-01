//
//  TQTmbrManager.m
//  TmbrQuote
//
//  Created by monoqlo on 2013/08/30.
//  Copyright (c) 2013年 米山 隆貴. All rights reserved.
//

#import "TQTmbrManager.h"

#import <SSKeychain/SSKeychain.h>


@implementation TQTmbrManager

static TQTmbrManager *instance = nil;

#pragma mark - For Singleton

+ (TQTmbrManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        [TMAPIClient sharedInstance].OAuthConsumerKey = TQ_CONSUMERKEY;
        [TMAPIClient sharedInstance].OAuthConsumerSecret = TQ_CONSUMERKEY_SECRET;
        
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(reAuthentificate:) name:TQ_RE_AUTHENTIFICATION object:nil];
    });
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark -

- (BOOL)isAuthentificated
{
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:TQ_USERNAME];
    
    NSString *token = [SSKeychain passwordForService:@"TmbrQuoteToken" account:username];
    NSString *tokenSecret = [SSKeychain passwordForService:@"TmbrQuoteTokenSecret" account:username];
    
    if (token && tokenSecret) {
        [TMAPIClient sharedInstance].OAuthToken = token;
        [TMAPIClient sharedInstance].OAuthTokenSecret = tokenSecret;
        
        return YES;
    } else {
        return NO;
    }
}

- (void)authentifiacte
{
    [[TMAPIClient sharedInstance] authenticate:@"tmbrquote" callback:^(NSError *error) {
        if (error) {
            NSLog(@"Authentication failed: %@ %@", error, [error description]);
        } else {
            NSLog(@"Authentication successful!");

            [[TMAPIClient sharedInstance] userInfo:^(id response, NSError *error) {
                if (error) {
                    NSLog(@"failed: %@ %@", error, [error description]);
                } else {
                    NSLog(@"successful!");
                    
                    NSString *username = response[@"user"][@"name"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:username forKey:TQ_USERNAME];
                    
                    NSString *token = [[TMAPIClient sharedInstance] OAuthToken];
                    NSString *secretToken = [[TMAPIClient sharedInstance] OAuthTokenSecret];
                    
                    NSError *error = nil;
                    [SSKeychain setPassword:token forService:@"TmbrQuoteToken" account:username error:&error];
                    if (!error){
                        NSLog(@"SSKeychain setPassword Succeeded.");
                    }else{
                        NSString *message = [error localizedDescription];
                        NSLog(@"SSKeychain setPassword Faild. message:%@",message);
                    }
                    
                    [SSKeychain setPassword:secretToken forService:@"TmbrQuoteTokenSecret" account:username error:&error];
                    if (!error){
                        NSLog(@"SSKeychain setPassword Succeeded.");
                    }else{
                        NSString *message = [error localizedDescription];
                        NSLog(@"SSKeychain setPassword Faild. message:%@",message);
                    }

                }
            }];
        }
    }];
}

#pragma mark - NSNotification Observer
// 認証が切れてたらここに飛ばす
- (void)reAuthentificate:(NSNotification *)notification
{
    [self authentifiacte];
}

#pragma mark - URL Scheme
- (BOOL)handleOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:@"open_url"])
        return NO;
    
    NSDictionary *urlParameters = [self queryStringToDictionary:url.query];

    if (!urlParameters) {
        return NO;
    }
    
    NSDictionary *urlDic = @{@"url":urlParameters[@"url"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:TQ_LOAD_URL object:self userInfo:urlDic];
    
    return YES;
}

- (NSDictionary *)queryStringToDictionary:(NSString *)query {
    NSMutableDictionary *mutableParameterDictionary = [[NSMutableDictionary alloc] init];
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    
    if(!parameters){
        // error
        NSLog(@"Bad Request");
        return nil;
    }
    
    for (NSString *parameter in parameters) {
        NSArray *keyValuePair = [parameter componentsSeparatedByString:@"="];
        NSString *key = [self urlDecode:keyValuePair[0]];
        NSString *value = [self urlDecode:keyValuePair[1]];
        [mutableParameterDictionary setObject: value forKey: key];
    }
    
    return mutableParameterDictionary;
}

- (NSString *)urlDecode:(NSString *)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string,
                                                                                    CFSTR("")));
}

- (NSString *)urlEncode:(id)value {
    NSString *string;
    
    if ([value isKindOfClass:[NSString class]])
        string = (NSString *)value;
    else
        string = [value stringValue];
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8));
}


#pragma mark -
- (NSString *)username
{
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:TQ_USERNAME];
    return username;
}

@end
