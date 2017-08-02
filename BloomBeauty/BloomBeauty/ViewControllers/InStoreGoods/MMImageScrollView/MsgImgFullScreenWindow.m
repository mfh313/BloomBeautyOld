//
//  MsgImgFullScreenWindow.m
//  Spring
//
//  Created by EEKA on 16/3/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MsgImgFullScreenWindow.h"
#import "MFCommodityDetailModel.h"

@implementation MsgImgFullScreenWindow

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

-(void)initWithCommodityDetailModel:(MFCommodityDetailModel *)commodityDetailModel
{
    if (!_viewController)
    {
        _viewController = [[MsgImgFullScreenViewController alloc] init];
        _viewController.m_delegate = self;
        self.rootViewController = _viewController;
        self.backgroundColor = [UIColor blackColor];
    }
    
    [_viewController initWithCommodityDetailModel:commodityDetailModel];
}

-(void)onSingleTap
{
    [self setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

@end
