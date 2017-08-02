//
//  UIViewController+FullScreen.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "UIViewController+FullScreen.h"

@implementation UIViewController (FullScreen)

-(void)MF_wantsFullScreenLayout:(BOOL)fullScreen
{
    if (!fullScreen)
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

@end
