//
//  MFCustomerConsumptionRecordViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/12.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerConsumptionRecordViewController.h"
#import "PurchaseRecords.h"
#import "PosVoucherDetail.h"
#import "MFCommodityDetailModel.h"
#import "MFCustomerConsumptionRecordCellHeaderView.h"
#import "MFCustomerConsumptionRecordCellView.h"
#import "MFCommodityDetailViewController.h"

#define CellItemColummCount 2

@interface MFCustomerConsumptionRecordViewController () <UITableViewDataSource,UITableViewDelegate,MFCustomerConsumptionRecordCellViewDelegate>
{
    __weak IBOutlet MFUITableView *_tableView;
    NSMutableArray* _dataArray;
    
    __weak IBOutlet UIView *_contentView;
    __weak IBOutlet UIView *_blankView;
    
}

@end

@implementation MFCustomerConsumptionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _tableView.rowHeight = 150;
    _tableView.sectionHeaderHeight = 44;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    
    [self queryList:@(10)];
    [self initFooter];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PurchaseRecords *records = _dataArray[section];
    return [self rowCount:(int)records.posVoucherDetailList.count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MFDiagnosisHistoryCellView";
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MFCustomerConsumptionRecordCellView *cellView = [[MFCustomerConsumptionRecordCellView alloc] initWithFrame:cell.contentView.bounds withColummCount:CellItemColummCount];
        cellView.m_delegate = self;
        cell.m_subContentView = cellView;
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    MFCustomerConsumptionRecordCellView *cellView = (MFCustomerConsumptionRecordCellView *)cell.m_subContentView;
    cellView.frame = cell.contentView.bounds;
    cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    PurchaseRecords *records = _dataArray[indexPath.section];
    [cellView setPosVoucherDetails:records.posVoucherDetailList indexPath:indexPath];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    MFCustomerConsumptionRecordCellHeaderView *header = [MFCustomerConsumptionRecordCellHeaderView viewWithNibName:@"MFCustomerConsumptionRecordCellHeaderView"];
    header.frame = headView.bounds;
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [headView addSubview:header];
    
    PurchaseRecords *records = _dataArray[section];
    [header setConsumptionNumber:records.posVoucherCode shopName:records.entityName time:records.posVoucherDate];
    
    return headView;
}

- (void)initFooter
{
    MFCustomerConsumptionRecordViewController *weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryList:@(_dataArray.count+5)];
        [_tableView.mj_footer endRefreshing];
    }];
}

-(void)onClickCustomerConsumptionRecordCellVieWithDetail:(PosVoucherDetail *)detail
{
 
}

-(int)rowCount:(int)viewsCount
{
    if (viewsCount == 0) {
        return 0;
    }
    
    int columms = CellItemColummCount;
    
    int row = viewsCount / columms;
    int exRow = viewsCount % columms;
    if (exRow != 0) {
        row = viewsCount / columms + 1;
    }
    
    return row;
}

-(void)queryList:(NSNumber*)num  {
    if(!self.customerInfo)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSString *token = BloomBeautyToken;
    NSDictionary *parameters = @{
                                 @"individualNo":self.customerInfo.individualNo,
                                 @"maxNum": num,
                                 @"token": token
                                 };
    [self showMBStatusInViewController:@"正在查询消费记录..."];
    [MFHTTPUtil POST_ToDict:MFApiQueryPurchaseRecordsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *posVoucherRecordList = responseObject[@"posVoucherRecordList"];
        [_dataArray removeAllObjects];
        for (id object in posVoucherRecordList) {
            PurchaseRecords *obj = [PurchaseRecords objectWithKeyValues:object];
            NSMutableArray *posVoucherDetailList = object[@"posVoucherDetail"];
            NSMutableArray *newArray = [[NSMutableArray alloc]init];
            for (id detail in posVoucherDetailList) {
                PosVoucherDetail *posVoucherDetail  = [PosVoucherDetail objectWithKeyValues:detail];
                if (!posVoucherDetail.smallItemUrl) {
                    posVoucherDetail.smallItemUrl = [MFCommodityUrlHelper consumptionRecordSmallItemUrl:posVoucherDetail.originalItemUrl];
                }

                [newArray addObject:posVoucherDetail];
                [obj setPosVoucherDetailList:newArray];
            }
            [_dataArray addObject:obj];
        }
        
        [weakSelf hiddenMBStatus];
        [weakSelf reloadSubViews];
        
    } failureTips:^(NSString *tips) {
        [weakSelf hiddenMBStatus];
        [CommonUtil showAlert:@"提示" message:tips];
    }];
}

-(void)reloadSubViews
{
    [_tableView reloadData];
    
    if (_dataArray.count > 0) {
        _blankView.hidden = YES;
        _contentView.hidden = NO;
    }
    else
    {
        _blankView.hidden = NO;
        _contentView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
} 


@end
