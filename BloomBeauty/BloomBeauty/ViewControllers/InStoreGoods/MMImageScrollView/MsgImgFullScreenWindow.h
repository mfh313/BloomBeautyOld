//
//  MsgImgFullScreenWindow.h
//  Spring
//
//  Created by EEKA on 16/3/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgImgFullScreenViewController.h"

@class MFCommodityDetailModel;

@protocol MsgImgFullScreenWindowDelegate <NSObject>

@optional
//- (BOOL)needShowFastBrowseBtn;
//- (void)onMsgImgPreviewDataRequired:(MsgImgPreviewData *)arg1;
//- (void)onMsgImgWindowDidHideToMsg:(CMessageWrap *)arg1;
//- (void)onMsgImgWindowWillHideToMsg:(CMessageWrap *)arg1;
//- (void)onMsgImgWindowDidShowFromMsg:(CMessageWrap *)arg1;
//- (void)onMsgImgWindowWillShowFromMsg:(CMessageWrap *)arg1;

@end

@interface MsgImgFullScreenWindow : UIWindow <MsgImgFullScreenViewControllerDelegate>
{
    MsgImgFullScreenViewController *_viewController;
}

-(void)initWithCommodityDetailModel:(MFCommodityDetailModel *)commodityDetailModel;

@end
