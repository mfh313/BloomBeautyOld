//
//  AppDelegate.m
//  装扮灵
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFAppDelegate.h"
#import "MFAppViewControllerManager.h"
#import "MFWeiChatShareManger.h"
#import "MFSysInit.h"
#import <Bugly/Bugly.h>
#import <JSPatchPlatform/JSPatch.h>
#import "MFJpushServiceManager.h"

#define JSPatch_APP_KEY @"ec0d9efa2436833d"
#define BUGLY_APP_ID @"900023802"

@interface MFAppDelegate ()
{
    
}

@end

@implementation MFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerJSPatchHotFix];
    [self registerBugly];
    [self registerJPushWithOptions:launchOptions];
    [self registerWeiChatShare];
    
    [[MFApiUtil sharedUtil] token];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [[MFAppViewControllerManager sharedManager] initWithWindow:self.window];
    
    [MFSysInit initUIAppearance];
    
    [[MFAppViewControllerManager sharedManager] showWithLoginViewController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[MFWeiChatShareManger sharedManager] application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[MFWeiChatShareManger sharedManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JSPatch sync];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)application:(UIApplication *)application
        didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
        didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
        handleActionWithIdentifier:(NSString *)identifier
              forLocalNotification:(UILocalNotification *)notification
                 completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
        handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)userInfo
                 completionHandler:(void (^)())completionHandler {
    
}
#endif

- (void)application:(UIApplication *)application
        didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [[MFJpushServiceManager sharedManager] logDic:userInfo]);
}

- (void)application:(UIApplication *)application
        didReceiveRemoteNotification:(NSDictionary *)userInfo
              fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [[MFJpushServiceManager sharedManager] logDic:userInfo]);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

-(void)registerBugly
{
    BuglyConfig *config = [BuglyConfig new];
    config.blockMonitorEnable = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.reportLogLevel = BuglyLogLevelWarn;
    [Bugly startWithAppId:BUGLY_APP_ID config:config];
    [BuglyLog initLogger:BuglyLogLevelWarn consolePrint:YES];
}

-(void)registerJSPatchHotFix
{
    [JSPatch startWithAppKey:JSPatch_APP_KEY];
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC+4rHXIqz8OhmCNgOuq5KX980o\npN0dT9RSwcTNZ+mPg2N4zRcjOlZevLU01iLDVJ02z8quDvxIh2KPKNYDa5MyE/FR\nXBsAm9BOfyjP9BLGuZ++4hnEhruT0ibteEVwjSuW+RKHufvckCR9TGCsL2JjMVw8\nqmC+GpwkgpX6agDvCQIDAQAB\n-----END PUBLIC KEY-----"];
    [JSPatch sync];
}

-(void)registerWeiChatShare
{
    [[MFWeiChatShareManger sharedManager] registerWeChat];
}

-(void)registerJPushWithOptions:(NSDictionary *)launchOptions
{
    [[MFJpushServiceManager sharedManager] registerJPushWithOptions:launchOptions];
}

@end
