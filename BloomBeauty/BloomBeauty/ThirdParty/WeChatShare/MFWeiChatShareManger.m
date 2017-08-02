//
//  MFWeiChatShareManger.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFWeiChatShareManger.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

@implementation MFWeiChatShareManger

+ (instancetype)sharedManager
{
    static MFWeiChatShareManger *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

+ (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

-(void)registerWeChat
{
    [WXApi registerApp:@"wxf4c0c785c3bb68d9"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

-(void)sendTextToWeiChatFriend:(NSString *)text
{
    [WXApiRequestHandler sendText:text InScene:WXSceneSession];
}

-(void)sendImageToWeiChatTimeLine:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    [WXApiRequestHandler sendImageData:data
                               TagName:@"WECHAT_TAG_JUMP_APP"
                            MessageExt:@"这是第三方带的测试字段"
                                Action:@"<action>dotalist</action>"
                            ThumbImage:image
                               InScene:WXSceneTimeline];
}

-(void)sendLinkContentToWeiChatFriend:(NSString *)linkURL Title:(NSString *)title Description:(NSString *)description
{
    [WXApiRequestHandler sendLinkURL:linkURL
                             TagName:@"不知道是啥"
                               Title:title
                         Description:description
                          ThumbImage:nil
                             InScene:WXSceneSession];
}

-(void)sendLinkContentToWeiChatTimeLine:(NSString *)linkURL Title:(NSString *)title Description:(NSString *)description
{
    [WXApiRequestHandler sendLinkURL:linkURL
                             TagName:@"不知道是啥"
                               Title:title
                         Description:description
                          ThumbImage:nil
                             InScene:WXSceneTimeline];
}

- (void)sendLinkContentToWeiChat:(NSString *)linkURL Title:(NSString *)title Description:(NSString *)description WithShareScene:(MFWeiChatShareScene)shareScene
{
    enum WXScene scene = WXSceneSession;
    switch (shareScene) {
        case WeiChatShareSession:
        {
            scene = WXSceneSession;
        }
            break;
        case WeiChatShareTimeline:
        {
            scene = WXSceneTimeline;
        }
            break;
        case WeiChatShareFavorite:
        {
            scene = WXSceneFavorite;
        }
            break;
            
        default:
            break;
    }
    
    [WXApiRequestHandler sendLinkURL:linkURL
                             TagName:@"不知道是啥"
                               Title:title
                         Description:description
                          ThumbImage:MFImage(@"logo")
                             InScene:scene];
}

@end
