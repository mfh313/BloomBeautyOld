//
//  MFJpushServiceManager.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/17.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFJpushServiceManager.h"
#import "JPUSHService.h"
#import "MFJpushServiceJsonModel.h"

@interface MFJpushServiceManager () <JPUSHRegisterDelegate>
{
    
}

@end

@implementation MFJpushServiceManager

+ (instancetype)sharedManager
{
    static MFJpushServiceManager *_sharedAppViewControllerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAppViewControllerManager = [[self alloc] init];
    });
    
    return _sharedAppViewControllerManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver];
    }
    
    return self;
}

-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
   NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
    
    
    NSString *allContent = [NSString
                            stringWithFormat:@"%@收到消息:\nextra:%@",
                            [NSDateFormatter
                             localizedStringFromDate:[NSDate date]
                             dateStyle:NSDateFormatterNoStyle
                             timeStyle:NSDateFormatterMediumStyle],
                            [self logDic:extra]];
    
    NSLog(@"%@", allContent);
    
    
    id jsonObject = [self stringToJson:content];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *pushContent = (NSDictionary *)jsonObject;
        NSString *type = pushContent[@"type"];
        
        if ([type isEqualToString:@"normalMsg"])
        {
            NSDictionary *msgContent = pushContent[type];
            
            MFJpushServiceJsonMsgModel *msgModel = [MFJpushServiceJsonMsgModel MM_modelWithDictionary:msgContent];
            if ([msgModel.valid isEqualToString:@"Y"]) {
                
                NSString *title = msgModel.title;
                NSString *content = msgModel.content;
                NSArray *actionList = msgModel.actionList;
                NSString *cancelString = actionList[0];
                
                NSString *doneString = nil;
                if (actionList.count > 1) {
                    doneString = actionList[1];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:title
                                      message:content
                                      delegate:nil
                                      cancelButtonTitle:cancelString
                                      otherButtonTitles:doneString, nil];
                [alert show];
            }
        }
        else if ([type isEqualToString:@"clearSDImageCache"])
        {
            NSDictionary *dic = pushContent[type];
            NSString *valid = dic[@"valid"];
            if ([valid isEqualToString:@"Y"]) {
                [self clearSDImageCache];
            }
        }
        else if ([type isEqualToString:@"directUpgrade"])
        {
            NSDictionary *dic = pushContent[type];
            NSString *valid = dic[@"valid"];
            if ([valid isEqualToString:@"Y"]) {
                NSString *upgradeUrl = dic[@"upgradeUrl"];
                NSURL *url = [NSURL URLWithString:upgradeUrl];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else if ([type isEqualToString:@"specifyUpgrade"])
        {
            NSDictionary *dic = pushContent[type];
            NSString *valid = dic[@"valid"];
            NSArray *upgradeKeys = dic[@"keys"];
            NSString *loginKey = [NSString stringWithFormat:@"%@",[MFLoginCenter sharedCenter].loginInfo.entityId];
            
            if (![upgradeKeys containsObject:loginKey]) {
                return;
            }
            
            if ([valid isEqualToString:@"Y"]) {
                NSString *upgradeUrl = dic[@"upgradeUrl"];
                NSURL *url = [NSURL URLWithString:upgradeUrl];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
}

-(id)stringToJson:(NSString*)stringData
{
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return json;
}

-(void)clearSDImageCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


-(void)registerJPushWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPUSH_APP_KEY
                          channel:@"Publish channel"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

@end
