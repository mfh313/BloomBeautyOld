//
//  MFCustomerDiagnosticRecordsViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/12.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticRecordsViewController.h"
#import "MFCustomerDiagnosticRecordsCell.h"
#import "DiagnosisResult.h"
#import "MFCustomerDiagnosticReportViewController.h"

@interface MFCustomerDiagnosticRecordsViewController () <UITableViewDataSource,UITableViewDelegate,MFCustomerDiagnosticRecordsItemViewDelegate>
{
    __weak IBOutlet MFUITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation MFCustomerDiagnosticRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [_tableView registerNib:[MFCustomerDiagnosticRecordsCell nib] forCellReuseIdentifier:[MFCustomerDiagnosticRecordsCell nibid]];
    [self queryList:@(5)];
    [self initHeader];
}

-(void)queryList:(NSNumber*)num  {
    if(self.customerInfo != nil)
    {
        NSString *token = BloomBeautyToken;
        NSDictionary *parameters = @{
                                     @"individualNo":self.customerInfo.individualNo,
                                     @"maxNum": num ,
                                     @"token": token
                                     };
        
        [MFHTTPUtil POST_ToDict:MFApiQueryDiagnosisRecordsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *posVoucherRecordList = responseObject[@"results"];
            [_dataArray removeAllObjects];
            for (id object in posVoucherRecordList) {
                DiagnosisResult *obj = [DiagnosisResult objectWithKeyValues:object];
                [_dataArray addObject:obj];
            }
            [_tableView reloadData];
        } failureTips:^(NSString *tips) {
            [CommonUtil showAlert:@"提示" message:tips];
        }];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    MFCustomerDiagnosticRecordsItemView *header = [MFCustomerDiagnosticRecordsItemView viewWithNibName:@"MFCustomerDiagnosticRecordsItemView"];
    header.frame = headView.bounds;
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [headView addSubview:header];
    header.backgroundColor = [UIColor hx_colorWithHexString:@"4F515C"];
    [header setLabelColor:[UIColor whiteColor]];
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFCustomerDiagnosticRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:[MFCustomerDiagnosticRecordsCell nibid]];
    [cell.itemView setWhiteGrayColor:indexPath.row];
    cell.itemView.indexPath = indexPath;
    cell.itemView.delegate = self;
    DiagnosisResult *obj =   _dataArray[indexPath.row];
    NSMutableString *mutableStr = [NSMutableString stringWithString:obj.diagnosisDate];
    [mutableStr replaceOccurrencesOfString:@"T" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [mutableStr length])];
    
    NSString *number =  [NSString stringWithFormat:@"%d",(int)(indexPath.row + 1)];
    [cell.itemView setLineNumber:number DiagnosticDate:mutableStr entityName:obj.entityName  shopingGuideName:obj.employeeName];
    return cell;
}

#pragma mark - MFCustomerDiagnosticRecordsItemViewDelegate
-(void)onClickDiagnosticBtn:(NSIndexPath *)indexPath
{
    DiagnosisResult *obj = _dataArray[indexPath.row];
    if(obj != nil)
    {
        UIStoryboard *storyBoard = BBCreateStoryBoard;
        MFCustomerDiagnosticReportViewController *diagnosticReport = [storyBoard instantiateViewControllerWithIdentifier:@"MFCustomerDiagnosticReportViewController"];
        diagnosticReport.diagnosisResultId = obj.diagnosisResultId;
        diagnosticReport.diagnosticReportCustomerInfo = self.customerInfo;
        [self.navigationController pushViewController:diagnosticReport animated:YES];
    }
}

-(void)initHeader
{
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf queryList:@(5)];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)initFooter
{
    __weak MFCustomerDiagnosticRecordsViewController *weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryList:@(_dataArray.count + 5)];
        [_tableView.mj_footer endRefreshing];
    }];
    
    [_tableView.mj_footer setHidden:YES];
    if (_tableView.contentSize.height >= _tableView.contentOffset.y) {
        [_tableView.mj_footer setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
 

@end
