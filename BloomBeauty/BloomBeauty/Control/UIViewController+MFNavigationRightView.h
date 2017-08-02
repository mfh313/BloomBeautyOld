//
//  UIViewController+MFNavigationRightView.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/3.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFNavigationRightView.h"

@interface UIViewController (MFNavigationRightView)

- (void)addRightNaviItemView;
- (MFNavigationRightView *)rightNaviItemView;
- (void)rightNaviItemViewAddClickSelector:(SEL)sel;


@end
