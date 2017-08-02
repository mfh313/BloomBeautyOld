//
//  MFViewControllerManager.h
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFLoginCenter.h"

@class MFVersionWindow;
@interface MFAppViewControllerManager : MFObject
{
    UIWindow *_window;
    MFVersionWindow *_versionWindow;
}

@property (nonatomic,strong) UIWindow *window;

+ (instancetype)sharedManager;
- (void)initWithWindow:(UIWindow *)window;
- (void)lanuchMainViewController;
- (void)showWithLoginViewController;

- (void)setVersionWindowVisible:(BOOL)visible;

- (void)setRootSplitDidSelectIndex:(NSInteger)index;
- (void)setRootSplitDidSelectIndex:(NSInteger)index needPopToRoot:(BOOL)popToRoot;
- (void)setRootSplitDidSelectIndex:(NSInteger)index needPopToRoot:(BOOL)popToRoot animation:(BOOL)animated;

- (void)reInitDiagnosisData:(BOOL)reInit;

- (void)jumpToCustomerAnalysis;
- (UINavigationController *)currentRootNav;

- (void)setVersionWindowRotate:(UIInterfaceOrientation)toInterfaceOrientation;

@end
