//
//  MFCustomerMaintenanceViewController.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceViewController.h"
#import "MFCustomerMaintenanceCellView.h"
#import "MFCustomerMaintenanceLogicController.h"
#import "MFCustomerMaintenanceModel.h"
#import "TTTAttributedLabel.h"
#import "MFCustomerMaintenanceUpdateApi.h"
#import "MFCustomerMaintenanceQueryApi.h"
#import "MFCustomerMaintenanceReportRichView.h"

@interface MFCustomerMaintenanceViewController ()<UITableViewDataSource,UITableViewDelegate,MFCustomerMaintenanceCellViewDelegate>
{
    __weak IBOutlet UIButton *_submitBtn;
    __weak IBOutlet UITableView *_tableView;
    MFCustomerMaintenanceLogicController *m_logic;
    
    NSMutableArray *_maintenanceTemplates;
    
    MFCustomerMaintenanceUpdateApi *_updateApi;
    MFCustomerMaintenanceQueryApi *_queryApi;
    
    MFCustomerMaintenanceReportRichView *_reportView;
    NSMutableDictionary *_maintenanceResults;
}

@end

@implementation MFCustomerMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"顾客喜好";
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    [self setRightNaviButtonWithTitle:@"重新顾客维护" action:@selector(resetInputMaintenanceData)];
    
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 80, 0)];
    
    m_logic = [MFCustomerMaintenanceLogicController new];
    [m_logic readjsonData];
    
    _maintenanceTemplates = [m_logic maintenanceTemplates];
    
    _updateApi = [MFCustomerMaintenanceUpdateApi new];
    _queryApi = [MFCustomerMaintenanceQueryApi new];
    
    [self initReportView];
    
    [self queryCustomerMaintenanceData];
}

-(void)resetInputMaintenanceData
{
    [_reportView setHidden:YES];
    [_tableView setContentOffset:CGPointZero];
}

-(void)initReportView
{
    _reportView = [[MFCustomerMaintenanceReportRichView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_reportView];
    
    [_reportView setHidden:YES];
}

-(void)onClickBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickSubmitBtn:(id)sender {
    [self submitCustomerMaintenanceData];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _maintenanceTemplates.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MFCustomerMaintenanceModel *model = (MFCustomerMaintenanceModel *)_maintenanceTemplates[section];
    return model.contentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFGoodsFilterItemCellView"];
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MFCustomerMaintenanceCellView"];
        MFCustomerMaintenanceCellView *cellView = [[MFCustomerMaintenanceCellView alloc] initWithFrame:cell.contentView.bounds];
        cellView.m_delegate = self;
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.frame;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFTableViewCell *mcell = (MFTableViewCell *)cell;
    MFCustomerMaintenanceCellView *cellView = (MFCustomerMaintenanceCellView *)mcell.m_subContentView;
    cellView.backgroundColor = [UIColor whiteColor];
    
    MFCustomerMaintenanceModel *model = (MFCustomerMaintenanceModel *)_maintenanceTemplates[indexPath.section];
    [cellView setMaintenanceModel:model contentModelIndex:indexPath.row];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGRect labelFrame = CGRectMake(50, 0, CGRectGetWidth(headerView.bounds), CGRectGetHeight(headerView.bounds));
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
    [headerView addSubview:label];
    
    MFCustomerMaintenanceModel *model = (MFCustomerMaintenanceModel *)_maintenanceTemplates[section];
    NSString *title = model.title;
    NSString *remark = model.titleRemark;
    NSString *string = [NSString stringWithFormat:@"%@",title];
    if (remark) {
        string = [NSString stringWithFormat:@"%@%@",title,remark];
    }
    
    NSMutableAttributedString * (^configureBlock) (NSMutableAttributedString *) = ^NSMutableAttributedString *(NSMutableAttributedString *inheritedString)
    {
        if (remark) {
            NSRange remarkRange = NSMakeRange(inheritedString.length - remark.length, remark.length);
            UIFont *font = [UIFont systemFontOfSize:16.0f];
            CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
            if (boldFont) {
                [inheritedString removeAttribute:(NSString *)kCTFontAttributeName range:remarkRange];
                [inheritedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:remarkRange];
                
                CFRelease(boldFont);
            }
            
            [inheritedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:remarkRange];
            [inheritedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:BBDefaultColor range:remarkRange];

        }
        
        return inheritedString;
    };
    
    [label setText:string afterInheritingLabelAttributesAndConfiguringWithBlock:configureBlock];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFCustomerMaintenanceModel *model = (MFCustomerMaintenanceModel *)_maintenanceTemplates[indexPath.section];
    CGFloat width = CGRectGetWidth(_tableView.frame);
    return [MFCustomerMaintenanceCellView cellHeightForMaintenanceModel:model
                                                      contentModelIndex:indexPath.row
                                                        availableWidth:width];
}

-(void)submitCustomerMaintenanceData
{
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    if (!individualNo) {
        [self showTips:@"请先设置一个当前顾客" withDuration:0.5];
        return;
    }
    
    NSMutableDictionary *selectedQuestionsDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < _maintenanceTemplates.count; i++) {
        MFCustomerMaintenanceModel *dataItem = _maintenanceTemplates[i];
        
        NSMutableArray *contentArray = dataItem.contentArray;
        for (int j = 0; j < contentArray.count; j++) {
            MFCustomerMaintenanceContentModel *contentModel = contentArray[j];
            
            NSString *questionNumber = contentModel.questionNumber;
            NSMutableArray *selectedQuestions = contentModel.selectedQuestions;
            
            NSString *resultStr = [selectedQuestions componentsJoinedByString:@","];
            if (resultStr) {
                [selectedQuestionsDic setObject:resultStr forKey:questionNumber];
            }
            
        }
    }
    
    NSDictionary *questionJSON = @{@"individualNo": individualNo,
                                   @"map": selectedQuestionsDic
                                   };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:questionJSON
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self showMBCircleInViewController];
    _updateApi.questionJson = jsonString;
    [_updateApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        if ([responseObject[@"statusCode"] isKindOfClass:[NSNull class]]) {
            return;
        }
        
        NSString *statusCode = responseObject[@"statusCode"];
        if ([statusCode isEqualToString:@"200"]) {
            [self showTips:@"提交数据成功"];
            [self queryCustomerMaintenanceData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

-(void)showReportView
{
    [_reportView setHidden:NO];
    [self.view bringSubviewToFront:_reportView];
    
    [_reportView setMaintenanceTemplates:_maintenanceTemplates results:_maintenanceResults];
}

-(void)queryCustomerMaintenanceData
{
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    if (!individualNo) {
        [self showTips:@"请先设置一个当前顾客" withDuration:0.5];
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    _queryApi.individualNo = individualNo;
    [_queryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        
        NSDictionary *customerMaintainMap = responseObject[@"customerMaintainMap"];
        if ([customerMaintainMap isKindOfClass:[NSNull class]]) {
            return;
        }
        _maintenanceResults = [NSMutableDictionary dictionaryWithDictionary:customerMaintainMap];
        
        if (_maintenanceResults.keyValues.count > 0) {
            dispatch_main_async_safe((^
                                      {
                                          [strongSelf showReportView];
                                      }));
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
