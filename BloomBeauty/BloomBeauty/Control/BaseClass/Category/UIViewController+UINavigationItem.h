//
//  UIViewController+UINavigationItem.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UINavigationItem)

-(void)setLeftNaviButtonWithAction:(SEL)anAction;
-(void)setLeftNaviButtonWithTitle:(NSString *)title action:(SEL)anAction;
-(void)setRightNaviButtonWithTitle:(NSString *)title action:(SEL)anAction;

- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem;
- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem;

@end
