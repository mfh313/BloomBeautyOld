//
//  MsgImgFullScreenViewController.h
//  Spring
//
//  Created by EEKA on 16/3/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgImgFullScreenContainer.h"

@protocol MsgImgFullScreenViewControllerDelegate <NSObject>

@optional
- (void)onHideStatusBar;
- (void)onShowStatusBar;
- (void)onSingleTap;
@end

@class MFCommodityDetailModel;

@interface MsgImgFullScreenViewController : UIViewController
{
    MsgImgFullScreenContainer *pagingScrollView;
}

@property (nonatomic,weak) id<MsgImgFullScreenViewControllerDelegate> m_delegate;

-(void)initWithCommodityDetailModel:(MFCommodityDetailModel *)commodityDetailModel;

@end
