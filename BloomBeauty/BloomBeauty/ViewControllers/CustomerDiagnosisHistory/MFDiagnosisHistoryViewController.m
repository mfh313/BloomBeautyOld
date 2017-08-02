//
//  MFDiagnosisHistoryViewController.m
//  BloomBeauty
//
//  Created by EEKA on 16/4/12.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFDiagnosisHistoryViewController.h"
#import "MFCustomerSearchBar.h"
#import "MFDiagnosisHistoryCellView.h"
#import "EntityDiagnosisRecordsDataItem.h"
#import "MFCustomerDiagnosticReportViewController.h"

@interface MFDiagnosisHistoryViewController ()<MFCustomerSearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MFCustomerSearchBar *_searchBar;
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_diagnosisRecordsArray;
    
}

@end

@implementation MFDiagnosisHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MF_wantsFullScreenLayout:NO];
    
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    
    _searchBar = [MFCustomerSearchBar viewWithNib];
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0, 300, 50);
    _searchBar.cancelBtnAlwaysShow = YES;
    [_searchBar setPlaceHolder:@"输入姓名或者手机号"];
    self.navigationItem.titleView = _searchBar;
    
    [self initHeader];
    
    _diagnosisRecordsArray = [NSMutableArray array];
    
    [self queryEntityDiagnosisRecords];
}

#pragma mark - MFCustomerSearchBarDelegate
-(void)searchBar:(MFCustomerSearchBar *)searchBar searchText:(NSString *)text
{
    [self queryEntityAndIndividualDiagnosisRecords:text];
}

-(void)searchBarOnClickCancelSearch:(MFCustomerSearchBar *)searchBar
{
    [_searchBar setText:nil];
    if (_tableView.mj_header == nil) {
        [self initHeader];
    }
    
    [self queryEntityDiagnosisRecords];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _diagnosisRecordsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MFDiagnosisHistoryCellView";
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MFDiagnosisHistoryCellView *cellView = [MFDiagnosisHistoryCellView viewWithNibName:@"MFDiagnosisHistoryCellView"];
        cell.m_subContentView = cellView;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    MFDiagnosisHistoryCellView *cellView = (MFDiagnosisHistoryCellView *)cell.m_subContentView;
    
    EntityDiagnosisRecordsDataItem *dataItem = _diagnosisRecordsArray[indexPath.row];
    
    NSNumber *diagnosisResultId = dataItem.diagnosisResultId;
    __weak typeof(self)weakSelf = self;
    [cellView setCustomerName:dataItem.individualName
                  phoneNumber:dataItem.phoneNum
                diagnosisTime:dataItem.diagnosisTime
               diagnosisGuide:dataItem.diagnosisEmployeeName
                  actionLabel:@"查看报告"
                       action:^{
                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                           [strongSelf showDiagnosticReport:diagnosisResultId IndividualNo:dataItem.individualNo];
                       }];
    
    [cellView setActionLabelColor:[UIColor hx_colorWithHexString:@"EE5C37"]];
    [cellView setWhiteGrayColor:indexPath.row+1];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    MFDiagnosisHistoryCellView *header = [MFDiagnosisHistoryCellView viewWithNibName:@"MFDiagnosisHistoryCellView"];
    [header setUnderLineHidden:NO];
    header.frame = headView.bounds;
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [headView addSubview:header];
    return headView;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [MFAppWindow endEditing:YES];
}

-(void)queryEntityDiagnosisRecords
{
    NSString *token = BloomBeautyToken;
    NSDictionary *parameters = @{
                                 @"entityId":[MFLoginCenter sharedCenter].currentShopingGuideInfo.entityId,
                                 @"pageNo": @(1),
                                 @"pageSize": @(100),
                                 @"token": token
                                 };
    
    [self showMBCircleInViewController];
    
    [MFHTTPUtil POST_ToDict:MFApiQueryEntityDiagnosisRecordsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hiddenMBStatus];
        
        NSMutableArray *diagnosisRecordsList = responseObject[@"diagnosisRecords"];
        [_diagnosisRecordsArray removeAllObjects];
        for (id object in diagnosisRecordsList) {
            EntityDiagnosisRecordsDataItem *dataItem = [EntityDiagnosisRecordsDataItem objectWithKeyValues:object];
            [_diagnosisRecordsArray addObject:dataItem];
        }
        [_tableView reloadData];
    } failureTips:^(NSString *tips) {
        [CommonUtil showAlert:@"提示" message:tips];
    }];
}

-(void)queryEntityAndIndividualDiagnosisRecords:(NSString *)searchText
{
    if (!searchText) {
        return;
    }
    
    [self showMBStatusInViewController:@"正在查询..."];
    
    NSString *token = BloomBeautyToken;
    NSDictionary *parameters = @{
                                 @"entityId":[MFLoginCenter sharedCenter].currentShopingGuideInfo.entityId,
                                 @"queryParam": searchText,
                                 @"pageNo": @(1),
                                 @"pageSize": @(100),
                                 @"token": token
                                 };
    
    [MFHTTPUtil POST_ToDict:MFApiQueryEntityAndIndividualDiagnosisRecordsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *diagnosisRecordsList = responseObject[@"diagnosisRecords"];
        [_diagnosisRecordsArray removeAllObjects];
        for (id object in diagnosisRecordsList) {
            EntityDiagnosisRecordsDataItem *dataItem = [EntityDiagnosisRecordsDataItem objectWithKeyValues:object];
            [_diagnosisRecordsArray addObject:dataItem];
        }
        [_tableView reloadData];
        
        [self hiddenMBStatus];
        
        if (_tableView.mj_header) {
            _tableView.mj_header = nil;
        }
        
    } failureTips:^(NSString *tips) {
        [CommonUtil showAlert:@"提示" message:tips];
    }];
}

-(void)initHeader
{
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf queryEntityDiagnosisRecords];
        [_tableView.mj_header endRefreshing];
    }];
}

-(void)showDiagnosticReport:(NSNumber *)diagnosisResultId IndividualNo:(NSString *)individualNo
{
    NSDictionary *parameters = @{
                                 @"individualNo": individualNo,
                                 @"token": BloomBeautyToken
                                 };
    
    [self showMBCircleInViewController];
    
    [MFHTTPUtil POST_ToDict:MFApiQueryCustomerByIdURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hiddenMBStatus];
        NSMutableArray *arry = responseObject[@"customerVO"];
        if (!arry || arry.count == 0) {
            return;
        }
        
        CustomerInfo *customerInfo = [CustomerInfo objectWithKeyValues:arry[0]];

        [MFLoginCenter sharedCenter].currentCustomerInfo = customerInfo;
        
        dispatch_main_async_safe(^{
            UIStoryboard *storyBoard = BBCreateStoryBoard;
            MFCustomerDiagnosticReportViewController *diagnosticReport = [storyBoard instantiateViewControllerWithIdentifier:@"MFCustomerDiagnosticReportViewController"];
            diagnosticReport.diagnosticReportCustomerInfo = [MFLoginCenter sharedCenter].currentCustomerInfo;
            diagnosticReport.diagnosisResultId = diagnosisResultId;
            [self.navigationController pushViewController:diagnosticReport animated:YES];
        });
        
    } failureTips:^(NSString *tips) {
        [self hiddenMBStatus];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
