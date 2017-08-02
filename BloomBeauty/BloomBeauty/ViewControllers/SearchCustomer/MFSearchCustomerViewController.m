//
//  MFSearchCustomerViewController.m
//  装扮灵
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSearchCustomerViewController.h"
#import "MFLoginCenter.h"
#import "MFCustomerSearchBar.h"
#import "MFCustomerSearchResultsCell.h"
#import "MFCustomerSearchHistoryCell.h"
#import "MFCustomerInfoMainNewViewController.h"
#import "MFQueryCustomerApi.h"

@interface MFSearchCustomerViewController ()<MFCustomerSearchBarDelegate,MFCustomerSearchResultsCellDelegate,MFCustomerSearchHistoryCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
     MFCustomerSearchBar *_searchBar;
    __weak IBOutlet MFUITableView *_searchResultsList;
    __weak IBOutlet MFUITableView *_searchHistoryList;
    NSMutableArray *_searchResultsData;
    NSMutableArray *_searchHistoryData;
    
    CALayer *_animationLayer;
    UIBezierPath *_animationPath;
    CGRect _animationEndRect;
    
    MFQueryCustomerApi *_queryCustomerApi;
}

@end

@implementation MFSearchCustomerViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[CKRadialMenuManager sharedManager] hiddenMenu];
    [self getHistoryData:@(10)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MF_wantsFullScreenLayout:NO];
    
    _searchBar = [MFCustomerSearchBar viewWithNib];
    [_searchBar setPlaceHolder:@"搜索"];
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0, 300, 50);
    self.navigationItem.titleView = _searchBar;
    
    _searchResultsData = [NSMutableArray array];
    _searchHistoryData = [NSMutableArray array];
    [_searchResultsList registerNib:[MFCustomerSearchResultsCell nib] forCellReuseIdentifier:[MFCustomerSearchResultsCell nibid]];
    [_searchHistoryList registerNib:[MFCustomerSearchHistoryCell nib] forCellReuseIdentifier:[MFCustomerSearchHistoryCell nibid]];
    
    [self getHistoryData:@(10)];
    [_searchHistoryList reloadData];
    [self initHeader];
    
    _queryCustomerApi = [MFQueryCustomerApi new];
}

#pragma mark - SearchResultsList
-(NSInteger)ResultsListNumberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)ResultsListTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultsData.count;
}

-(UITableViewCell *)ResultsListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFCustomerSearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:[MFCustomerSearchResultsCell nibid] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    CustomerInfo  *info  = _searchResultsData[indexPath.row];
    [cell setCustomerInfo:info];
    
    __block MFSearchCustomerViewController *blockSelf = self;
    cell.clickPathBlock = ^(UIView *animationView)
    {
        [blockSelf addClickAnimation:animationView];
    };
    
    return cell;
}

#pragma mark - MFCustomerSearchResultsCellDelegate
-(void)onClickAnalysis:(NSIndexPath *)indexPath
{
    CustomerInfo *customerInfo  = _searchResultsData[indexPath.row];
    [MFLoginCenter sharedCenter].currentCustomerInfo = customerInfo;
    [[MFAppViewControllerManager sharedManager] jumpToCustomerAnalysis];
}

-(void)onClickHeadImage:(NSIndexPath *)indexPath
{
    CustomerInfo *customer = _searchResultsData[indexPath.row];
    [self showCustomerInfo:customer.individualNo];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [MFAppWindow endEditing:YES];
}

#pragma mark - SearchHistoryList
-(NSInteger)HistoryListNumberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)HistoryListTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchHistoryData.count;
}

-(UITableViewCell *)HistoryListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFCustomerSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[MFCustomerSearchHistoryCell nibid] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    CustomerInfo  *info  = _searchHistoryData[indexPath.row];
    cell.customerInfo = info;
    [cell setName:info.individualName];
    return cell;
}

-(void)onClickHistory:(NSIndexPath *)indexPath
{
    CustomerInfo *customer = _searchHistoryData[indexPath.row];
    [self showCustomerInfo:customer.individualNo];
}

-(void)showCustomerInfo:(NSString *)individualNo
{
    UIStoryboard *storyboard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
    MFCustomerInfoMainNewViewController *customerInfoController = (MFCustomerInfoMainNewViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MFCustomerInfoMainNewViewController"];
    customerInfoController.individualNo = individualNo;
    [self.navigationController pushViewController:customerInfoController animated:YES];

}

#pragma mark - MFCustomerSearchBarDelegate
-(void)searchBar:(MFCustomerSearchBar *)searchBar searchText:(NSString *)text
{
    [self showMBStatusInViewController:@"正在查询..."];
    [self getSearchData:text];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _searchResultsList)
    {
        return [self ResultsListNumberOfSectionsInTableView:tableView];
    }
    else if (tableView == _searchHistoryList)
    {
        return [self HistoryListNumberOfSectionsInTableView:tableView];
    }
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchResultsList)
    {
        return [self ResultsListTableView:tableView numberOfRowsInSection:section];
    }
    else if (tableView == _searchHistoryList)
    {
        return [self HistoryListTableView:tableView numberOfRowsInSection:section];
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchResultsList)
    {
        return [self ResultsListTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if (tableView == _searchHistoryList)
    {
        return [self HistoryListTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return nil;
}

-(void)getSearchData:(NSString *)string
{
    _queryCustomerApi.searchKey = string;
    _queryCustomerApi.brandId = [MFLoginCenter sharedCenter].loginInfo.entityBrandId;
    
    [_queryCustomerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        
        NSMutableArray *array = responseObject[@"customerVO"];
        [_searchResultsData removeAllObjects];
        dispatch_main_async_safe(^{
            [self hiddenMBStatus];
        });
        if(array != nil && array.count>0)
        {
            for (id jsonObj in array) {
                CustomerInfo *obj = [CustomerInfo objectWithKeyValues:jsonObj];
                [_searchResultsData addObject:obj];
            }
        }else
        {
            [CommonUtil showAlert:@"提示" message:@"暂无用户数据"];
        }
        
        dispatch_main_async_safe(^{
            [_searchResultsList reloadData];
        });
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSError *error = request.error;
        
        [self hiddenMBStatus];
        [self showTips:[error localizedDescription]];
    }];
}

-(void)getHistoryData:(NSNumber*)num
{
    NSNumber *entityId = [MFLoginCenter sharedCenter].loginInfo.entityId;
    NSString *maintainEmployeeId = [MFLoginCenter sharedCenter].currentShopingGuideInfo.employeeId;
    NSDictionary *parameters = @{
                                 @"token": BloomBeautyToken,
                                 @"entityId": entityId,
                                 @"maintainEmployeeId": maintainEmployeeId,
                                 @"maxNum": num
                                 };
    [MFHTTPUtil POST_ToDict:MFApiQueryDiagnosisResultsByEntityURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = responseObject[@"results"];
        [_searchHistoryData removeAllObjects];
        if(array != nil && array.count>0)
        {
            for (id jsonObj in array) {
                CustomerInfo *obj = [CustomerInfo objectWithKeyValues:jsonObj];
                [_searchHistoryData addObject:obj];
            }
        }
        
        dispatch_main_async_safe(^{
            [_searchHistoryList reloadData];
        });
        
    } failureTips:^(NSString *tips) {
        
    }];
}

-(void)initHeader
{
    __weak typeof(self)weakSelf = self;
    _searchHistoryList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getHistoryData:@(10)];
        [_searchHistoryList.mj_header endRefreshing];
    }];
    
    _searchResultsList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *searchText = [_searchBar getSearchText];
        
        [_searchResultsList.mj_header endRefreshing];
        
        if (searchText == nil || [searchText isEqualToString:@""]) {
            return;
        }
        
        [strongSelf getSearchData:searchText];
        
    }];
}

-(void)addClickAnimation:(UIView *)animationView
{
    if (!_animationLayer) {
        _animationLayer = [CALayer layer];
    }
    
    CGRect orignRect = [animationView convertRect:animationView.frame toView:MFAppWindow];
    CGFloat endScale = CGRectGetWidth(_animationEndRect) / CGRectGetWidth(orignRect);
    
    _animationLayer.contents = animationView.layer.contents;
    _animationLayer.bounds = animationView.bounds;
    _animationLayer.masksToBounds = YES;
    _animationLayer.cornerRadius = CGRectGetWidth(_animationLayer.bounds)/2;
    _animationLayer.position = CGPointMake(orignRect.origin.x+CGRectGetWidth(orignRect)/2, orignRect.origin.y);
    [MFAppWindow.layer addSublayer:_animationLayer];
    
    _animationPath = [UIBezierPath bezierPath];
    [_animationPath moveToPoint:_animationLayer.position];
    [_animationPath addQuadCurveToPoint:_animationEndRect.origin controlPoint:CGPointMake(_animationEndRect.origin.x,_animationEndRect.origin.y + 300)];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _animationPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = @(1.0);
    expandAnimation.toValue = @(1.5);
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.fromValue = @(1.5);
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = @(endScale);
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 2.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_animationLayer addAnimation:groups forKey:@"group"];
    
    
    self.view.userInteractionEnabled = NO;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_animationLayer animationForKey:@"group"]) {
        if (flag) {
            [_animationLayer removeFromSuperlayer];
            self.view.userInteractionEnabled = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
 

@end
