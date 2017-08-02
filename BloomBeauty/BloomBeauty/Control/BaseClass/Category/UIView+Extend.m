//
//  UIView+Extend.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

- (void)removeAllSubViews
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

@end
