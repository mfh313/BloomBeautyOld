//
//  BBRootSplitViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "BBRootSplitViewController.h"


@interface BBRootSplitViewController ()<MFMainTabViewDataSource,MFMainTabViewDelegate>
{
    
    __weak IBOutlet UIView *_leftIndexView;
    __weak IBOutlet UIView *_rightContentView;
    
    MFMainTabView *_leftMainTabView;
    
}

@end

@implementation BBRootSplitViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUInteger selectedIndex = [self selectedIndex];
    
    if (_leftViewController) {
        [self addChildViewController:_leftViewController];
        _leftViewController.view.frame = _leftIndexView.bounds;
        [_leftViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                                       UIViewAutoresizingFlexibleHeight)];
        [_leftIndexView addSubview:_leftViewController.view];
        [_leftViewController didMoveToParentViewController:self];
    }
    
    [self setSelectedIndex:selectedIndex];
    
    _leftMainTabView = [MFMainTabView viewWithNibName:@"MFMainTabView"];
    _leftMainTabView.frame = _leftIndexView.bounds;
    [_leftMainTabView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                                   UIViewAutoresizingFlexibleHeight)];
    _leftMainTabView.dataSource = self.delegate;
    _leftMainTabView.delegate = self.delegate;
    [_leftIndexView addSubview:_leftMainTabView];
    
    [_leftMainTabView setNeedsLayout];
}

-(void)setGuideName:(NSString *)guideName
{
    [_leftMainTabView setGuideName:guideName];
}


-(void)setLeftViewController:(UIViewController *)leftViewController
{
    _leftViewController = leftViewController;
}

-(UIViewController *)selectedViewController
{
    UIViewController *selectedViewController = nil;
    id selectedObject = [[self viewControllers] objectAtIndex:[self selectedIndex]];
    if ([selectedObject isKindOfClass:[NSNull class]]) {
        selectedViewController = [self.delegate BBRootSplitSelectedViewControllerIndex:[self selectedIndex]];
    }
    else
    {
        selectedViewController = (UIViewController *)selectedObject;
    }
    
    return selectedViewController;
}


-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    
    UIViewController *selectedViewController = [self selectedViewController];
    [self addChildViewController:selectedViewController];
    [[selectedViewController view] setFrame:_rightContentView.bounds];
    [[selectedViewController view] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                                   UIViewAutoresizingFlexibleHeight)];
    [_rightContentView addSubview:[selectedViewController view]];
    [selectedViewController didMoveToParentViewController:self];
    
    if ([self.delegate respondsToSelector:@selector(BBRootSplit:didSelectedIndex:)]) {
        [self.delegate BBRootSplit:self.viewControllers didSelectedIndex:_selectedIndex];
    }
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers && _viewControllers.count > 0) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
    }
    else
    {
        _viewControllers = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
