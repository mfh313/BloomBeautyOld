//
//  UIViewController+MFNavigationRightView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/3.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "UIViewController+MFNavigationRightView.h"
#import "objc/runtime.h"

@implementation UIViewController (MFNavigationRightView)

-(MFNavigationRightView *)rightNaviItemView
{
    return (MFNavigationRightView *)objc_getAssociatedObject(self, [self getKeyFromString:@"rightNaviItemView"]);
}

-(void)setRightNaviItemView:(MFNavigationRightView *)rightNaviItemView
{
    objc_setAssociatedObject(self, [self getKeyFromString:@"rightNaviItemView"], rightNaviItemView, OBJC_ASSOCIATION_RETAIN);
}

-(void)addRightNaviItemView
{
    if (!self.rightNaviItemView) {
        self.rightNaviItemView = [MFNavigationRightView viewWithNibName:@"MFNavigationRightView"];
        self.rightNaviItemView.backgroundColor = [UIColor clearColor];
        self.rightNaviItemView.frame = CGRectMake(0, 0, 180, 44);
        if ([self respondsToSelector:@selector(clickRightBtn)]) {
            [self.rightNaviItemView addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNaviItemView];
    }
}

- (void)clickRightBtn
{
    
}

-(void)rightNaviItemViewAddClickSelector:(SEL)sel
{
    [self.rightNaviItemView addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (const char*)getKeyFromString:(NSString *)string
{
    return sel_getName(NSSelectorFromString(string));
}
@end
