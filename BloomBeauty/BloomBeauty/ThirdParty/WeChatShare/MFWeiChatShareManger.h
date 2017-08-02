//
//  MFWeiChatShareManger.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

//微信分享账号 eeka_it@icloud.com

typedef NS_ENUM(NSInteger, MFWeiChatShareScene) {
    WeiChatShareSession  = 0,        /**< 聊天界面    */
    WeiChatShareTimeline = 1,        /**< 朋友圈      */
    WeiChatShareFavorite = 2,        /**< 收藏       */
};

@interface MFWeiChatShareManger : MFObject

+ (instancetype)sharedManager;
+ (BOOL)isWXAppInstalled;
- (void)registerWeChat;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;


- (void)sendTextToWeiChatFriend:(NSString *)text;
- (void)sendImageToWeiChatTimeLine:(UIImage *)image;

- (void)sendLinkContentToWeiChatFriend:(NSString *)linkURL Title:(NSString *)title Description:(NSString *)description;
- (void)sendLinkContentToWeiChatTimeLine:(NSString *)linkURL Title:(NSString *)title Description:(NSString *)description;
- (void)sendLinkContentToWeiChat:(NSString *)linkURL Title:(NSString *)title Description:(NSString *)description WithShareScene:(enum MFWeiChatShareScene)shareScene;

@end
