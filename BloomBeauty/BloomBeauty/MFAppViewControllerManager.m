//
//  MFViewControllerManager.m
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFAppViewControllerManager.h"
#import "MFVersionWindow.h"
#import "MFLoginViewController.h"
#import "MFSelectShopingGuideViewController.h"
#import "MFSearchCustomerViewController.h"
#import "MFCustomerDiagnosticViewController.h"
#import "MFSalingProdouctViewController.h"
#import "BBRootSplitViewController.h"
#import "UpgradeInfoUtil.h"
#import "MFSuitableWearLibraryViewController.h"
#import "MFDiagnosisHistoryViewController.h"
#import "PresentAnimation.h"
#import "DismissAnimation.h"
#import "MFCustomerDiagnosticLogic.h"
#import "MFCustomerCreateViewController.h"
#import "MMUINavigationBar.h"

@interface MFAppViewControllerManager () <UIViewControllerTransitioningDelegate,MFLoginViewControllerDelegate,BBRootSplitViewControllerDelegate,MFMainTabViewDataSource,MFMainTabViewDelegate>
{
    BBRootSplitViewController *_rootViewController;
    NSMutableArray *_rightViewControllers;
    
    MFSelectShopingGuideViewController *_selectGuideVC;
    MFCustomerDiagnosticViewController *_analysisVC;

    MFLoginViewController *_loginViewController;
}

@property (nonatomic, strong) PresentAnimation *presentAnimation;
@property (nonatomic, strong) DismissAnimation *dismissAnimation;

@end

@implementation MFAppViewControllerManager
@synthesize window = _window;

+ (instancetype)sharedManager
{
    static MFAppViewControllerManager *_sharedAppViewControllerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAppViewControllerManager = [[self alloc] init];
    });
    
    return _sharedAppViewControllerManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _rightViewControllers = [NSMutableArray array];
        
        _presentAnimation = [PresentAnimation new];
        _dismissAnimation = [DismissAnimation new];
        
        [MFCustomerDiagnosticLogic sharedLogic];
    }
    
    return self;
}

-(void)initWithWindow:(UIWindow *)window
{
    self.window = window;
    [self setVersionWindow];
}

-(void)reInitDiagnosisData:(BOOL)reInit
{
    if (reInit) {
        [_analysisVC reInitDiagnosisModelArray];
    }
}

-(void)setVersionWindow
{
    if (!_versionWindow) {
        _versionWindow = [[MFVersionWindow alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.window.frame), 20)];
    }
    
    NSString *strVersion = [UpgradeInfoUtil getNowShowVersion];
    [_versionWindow setVersion:strVersion];
    _versionWindow.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)deviceRotated:(NSNotification *)note{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    [self setVersionWindowRotate:(UIInterfaceOrientation)orientation];
}

-(void)setVersionWindowRotate:(UIInterfaceOrientation)toInterfaceOrientation
{
    _versionWindow.frame = CGRectMake(0, 0,  CGRectGetWidth(_versionWindow.frame), 20);
}

-(void)setVersionWindowVisible:(BOOL)visible
{
    _versionWindow.hidden = !visible;
}

-(void)lanuchMainViewController
{
    _rootViewController = [BBCreateStoryBoard instantiateViewControllerWithIdentifier:@"BBRootSplitViewController"];
    _rootViewController.delegate = self;
    _rootViewController.selectedIndex = 1;
    
    NSUInteger rightViewControllersCount = 5;
    [_rightViewControllers removeAllObjects];
    for (int i = 0; i < rightViewControllersCount; i++) {
        [_rightViewControllers addObject:[NSNull null]];
    }
    UIViewController *firstInsertVC = [self BBRootSplitRightViewControllerAtSelectedIndex:0];
    [_rightViewControllers replaceObjectAtIndex:0 withObject:firstInsertVC];
    
    _rootViewController.viewControllers = _rightViewControllers;
    
    [self setRootSplitDidSelectIndex:1];
}

-(NSMutableArray *)MFMainTabItems
{
    NSArray *normalImages = @[MFImage(@"nav7a"),MFImage(@"nav6a"),MFImage(@"nav4a"),MFImage(@"nav5a")];
    NSArray *highligntImages = @[MFImage(@"nav7"),MFImage(@"nav6"),MFImage(@"nav4"),MFImage(@"nav5")];
    NSArray *normalTitles = @[@"新建顾客",@"顾客查询",@"在店单品",@"诊断历史"];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        MFTabItemDataItem *dataItem = [MFTabItemDataItem new];
        dataItem.normalImage = normalImages[i];
        dataItem.highlightImage = highligntImages[i];
        dataItem.normalTitle = normalTitles[i];
        dataItem.highlightTitle = normalTitles[i];
        [itemArray addObject:dataItem];
    }
    
    return itemArray;
}

-(NSInteger)selectedTabItemIndex
{
    return [_rootViewController selectedIndex];
}

-(UIViewController *)BBRootSplitSelectedViewControllerIndex:(NSUInteger)index
{
    UIViewController *selectedVC = _rightViewControllers[index];
    if ([selectedVC isKindOfClass:[NSNull class]]) {
        selectedVC = [self BBRootSplitRightViewControllerAtSelectedIndex:index];
        [_rightViewControllers replaceObjectAtIndex:index withObject:selectedVC];
    }
    
    return selectedVC;
}

-(UIViewController *)BBRootSplitRightViewControllerAtSelectedIndex:(NSUInteger)index
{
    UIViewController *viewController = nil;
    switch (index) {
        case 0:
        {
            viewController= [self customerCreateVC];
        }
            break;
            
        case 1:
        {
            viewController = [self customerSearchVC];
        }
            break;
        case 2:
        {
            viewController = [self salingProdouctVC];
        }
            break;
        case 3:
        {
            viewController = [self diagnosisHistoryVC];
        }
            break;
        default:
            break;
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationBar *navBar = ((UINavigationController *)viewController).navigationBar;
        if ([navBar isKindOfClass:[MMUINavigationBar class]]) {
            [(MMUINavigationBar *)navBar setRoundCornerShow:YES];
        }
    }
    
    return viewController;
}

#pragma mark - 主页面
-(UIViewController *)customerCreateVC
{
    UIStoryboard *storyBoardCreate = BBCreateStoryBoard;
    MFCustomerCreateViewController *createVC = [storyBoardCreate instantiateViewControllerWithIdentifier:@"MFCustomerCreateViewController"];
    
    MFNavigationController *createVCNav = [[MFNavigationController alloc] initWithRootViewController:createVC];
    return createVCNav;
}

-(UIViewController *)customerSearchVC
{
    UIStoryboard *storyBoardCreate = BBCreateStoryBoard;
    MFSearchCustomerViewController *searchVC = [storyBoardCreate instantiateViewControllerWithIdentifier:@"MFSearchCustomerViewController"];
    
    MFNavigationController *searchVCNav = [[MFNavigationController alloc] initWithRootViewController:searchVC];
    return searchVCNav;
}

-(UIViewController *)salingProdouctVC
{
    UIStoryboard *storyBoardInStoreGoods =  BBInStoreGoodstoryBoard;
    
    MFSalingProdouctViewController *salingVC = [storyBoardInStoreGoods instantiateViewControllerWithIdentifier:@"MFSalingProdouctViewController"];
    MFNavigationController *salingVCNav = [[MFNavigationController alloc] initWithRootViewController:salingVC];
    
    return salingVCNav;
}

-(UIViewController *)diagnosisHistoryVC
{
    MFDiagnosisHistoryViewController *diagnosisHistoryVC = [BBDiagnosisHistoryStoryBoard instantiateViewControllerWithIdentifier:@"MFDiagnosisHistoryViewController"];
    MFNavigationController *diagnosisHistoryVCNav = [[MFNavigationController alloc] initWithRootViewController:diagnosisHistoryVC];
    
    return diagnosisHistoryVCNav;
}

-(void)BBRootSplitLeftViewController:(UIViewController *)leftViewController didSelectedIndex:(NSUInteger)index
{
    
}

-(void)BBRootSplit:(NSArray *)viewControllers didSelectedIndex:(NSUInteger)index
{
    if (index == 1)
    {
        if (_rightViewControllers.count > index && [_rightViewControllers[index] isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navSearch = (UINavigationController *)_rightViewControllers[index];
            [navSearch popToRootViewControllerAnimated:NO];
        }
    }
}

-(void)jumpToCustomerAnalysis
{
    [self reInitDiagnosisData:YES];
    
    MFNavigationController *analysisVCNav = [[MFNavigationController alloc] initWithRootViewController:[self customerDiagnosticVC]];
    analysisVCNav.transitioningDelegate = self;
    
    [_rootViewController presentViewController:analysisVCNav
                                      animated:YES
                                    completion:^{
        [_analysisVC checkDiagnosisData];
    }];
}


-(UIViewController *)customerDiagnosticVC
{
    if (_analysisVC) {
        return _analysisVC;
    }
    
    UIStoryboard *storyBoardCreate = BBCreateStoryBoard;
    _analysisVC = [storyBoardCreate instantiateViewControllerWithIdentifier:@"MFCustomerDiagnosticViewController"];
    
    return _analysisVC;
   
}

-(void)setRootSplitDidSelectIndex:(NSInteger)index
{
    [_rootViewController setSelectedIndex:index];
}

-(void)setRootSplitDidSelectIndex:(NSInteger)index needPopToRoot:(BOOL)popToRoot
{
    [self setRootSplitDidSelectIndex:index needPopToRoot:popToRoot animation:NO];
}

-(void)setRootSplitDidSelectIndex:(NSInteger)index needPopToRoot:(BOOL)popToRoot animation:(BOOL)animated
{
    if (popToRoot)
    {
        if (_rightViewControllers.count > index && [_rightViewControllers[index] isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *selectNav = (UINavigationController *)_rightViewControllers[index];
            [selectNav popToRootViewControllerAnimated:animated];
        }
    }
    [self setRootSplitDidSelectIndex:index];
    
}

-(void)showWithLoginViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BloomBeauty" bundle:nil];
    _loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"MFLoginViewController"];
    _loginViewController.delegate = self;
    _window.rootViewController  = _loginViewController;
}

#pragma mark - MFLoginViewControllerDelegate

-(void)didLoginSuccess
{
    [self lanuchMainViewController];
    
    if (!_selectGuideVC) {

        __weak __typeof(self) weakSelf = self;
        _selectGuideVC = [BBMainStoryBoard instantiateViewControllerWithIdentifier:@"MFSelectShopingGuideViewController"];
        _selectGuideVC.backBlock = ^()
        {
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf onTapQuitLogin];
        };

        _selectGuideVC.nextBlock = ^(BBEmployeeInfo *employeeInfo)
        {
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf setBBRootViewController];
        };
    }
    
    _window.rootViewController = _selectGuideVC;
}

-(void)setCurrentGuideInfo:(BBEmployeeInfo *)employeeInfo
{
    [_rootViewController setGuideName:employeeInfo.employeeName];
}

-(void)setBBRootViewController
{
    _window.rootViewController = _rootViewController;
    [self setRootSplitDidSelectIndex:1];
    
    BBEmployeeInfo *currentShopingGuideInfo = [MFLoginCenter sharedCenter].currentShopingGuideInfo;
    [self setCurrentGuideInfo:currentShopingGuideInfo];
}

-(UINavigationController *)currentRootNav
{
    if (![_window.rootViewController isKindOfClass:[BBRootSplitViewController class]]) {
        return nil;
    }
    
    NSInteger selectedIndex = _rootViewController.selectedIndex;
    if (selectedIndex > _rightViewControllers.count) {
        return nil;
    }
    
    UINavigationController *selectNav = (UINavigationController *)_rightViewControllers[selectedIndex];
    
    return selectNav;
    
}


#pragma mark - MFMainTabViewDelegate

-(void)onTapQuitLogin
{
    [self showWithLoginViewController];
    [[MFLoginCenter sharedCenter] logout];
    
    _rootViewController = nil;
    _selectGuideVC = nil;
}

-(void)onTapSwitchUser
{
    _window.rootViewController = _selectGuideVC;
    
    [[MFLoginCenter sharedCenter] switchUser];
}

-(void)onTapTabIndex:(NSInteger)index
{
    [_rootViewController setSelectedIndex:index];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}


@end
