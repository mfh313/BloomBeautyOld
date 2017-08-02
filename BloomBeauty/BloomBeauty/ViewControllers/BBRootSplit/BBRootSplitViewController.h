//
//  BBRootSplitViewController.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"
#import "MFMainTabView.h"

@protocol BBRootSplitViewControllerDelegate <NSObject,MFMainTabViewDataSource,MFMainTabViewDelegate>

@required

-(UIViewController *)BBRootSplitSelectedViewControllerIndex:(NSUInteger)index;

@optional

-(void)BBRootSplit:(NSArray *)viewControllers didSelectedIndex:(NSUInteger)index;

@end

@interface BBRootSplitViewController : MFViewController

@property (nonatomic,strong) NSArray *viewControllers;
@property (nonatomic,strong) UIViewController *leftViewController;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic,weak) id<BBRootSplitViewControllerDelegate> delegate;

-(void)setGuideName:(NSString *)guideName;

@end
