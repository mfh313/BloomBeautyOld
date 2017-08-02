//
//  MFJpushServiceManager.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/17.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "JPUSHService.h"

//cn.eeka.bloombeauty
#define JPUSH_APP_KEY @"ce4543e96d961016e9cdc90d"

//cn.eeka.testPush
//#define JPUSH_APP_KEY @"33d89996d774f7bcfc287c04"

@interface MFJpushServiceManager : MFObject

+ (instancetype)sharedManager;

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions;
- (NSString *)logDic:(NSDictionary *)dic;

@end
