//
//  TQTmbrManager.h
//  TmbrQuote
//
//  Created by monoqlo on 2013/08/30.
//  Copyright (c) 2013年 米山 隆貴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQTmbrManager : NSObject

+ (TQTmbrManager *)sharedInstance;

- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)isAuthentificated;
- (void)authentifiacte;
- (NSString *)username;

@end
