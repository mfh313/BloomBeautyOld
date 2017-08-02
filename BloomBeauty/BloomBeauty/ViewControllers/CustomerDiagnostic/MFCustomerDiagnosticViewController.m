//
//  MFCustomerDiagnosticViewController.m
//  BloomBeauty
//
//  Created by EEKA on 16/1/15.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticViewController.h"
#import "MFCustomerDiagnosisCellView.h"
#import "MFCustomerDiagnosticLogic.h"
#import "MFCustomerDiagnosticReportViewController.h"
#import <Bugly/Bugly.h>
#import "MFCustomerDiagnosticApi.h"
#import "MFDiagnosticQuestionDressingSolveView.h"

@interface MFCustomerDiagnosticViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MFCustomerDiagnosisCellViewDelegate,MFDiagnosticQuestionDressingSolveViewDelegate>
{
    __weak IBOutlet MFUITableView *_tableView;
    
    NSMutableArray *_diagnosticQuestions;
    NSMutableDictionary *_diagnosisDataCacheHeightDic;
    
    MFNavigationRightView *_rightNaviItemView;
    
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    
    MFCustomerDiagnosticApi *_customerDiagnosticApi;
}

@end

@implementation MFCustomerDiagnosticViewController

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    
    self.title = [NSString stringWithFormat:@"顾客诊断 = %@",text.string];
}

-(void)startLoopCheck
{
#ifdef DEBUG
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
#else
    
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self startLoopCheck];
    
    self.title = @"顾客诊断";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [_tableView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self setNaviItemViews];

    _customerDiagnosticApi = [MFCustomerDiagnosticApi new];
    
    _diagnosisDataCacheHeightDic = [NSMutableDictionary dictionary];
    [self getDiagnosisData];
}

-(void)checkDiagnosisData
{
    __weak typeof(self) weakSelf = self;
    [[MFCustomerDiagnosticLogic sharedLogic] needLoadQuestions:^(BOOL needReload) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!needReload) {
            return;
        }
        
        [strongSelf getDiagnosisData];
        
    }];
}

-(void)getDiagnosisData
{
    __weak typeof(self) weakSelf = self;
    
    [MFCustomerDiagnosticLogic getDiagnosticData:^(NSMutableArray *dataArray) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_main_async_safe(^{
            [strongSelf hiddenMBStatus];
        });
        
        _diagnosticQuestions = dataArray;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [strongSelf reInitDiagnosisModelArray];
            [strongSelf preCacheCellHeight];
            
            dispatch_main_async_safe(^{
                [_tableView reloadData];
            });
        });
        
    } progress:^(NSString *message) {
        
        dispatch_main_async_safe(^{
            [weakSelf showMBStatusInViewController:message];
        });
        
    } failBlock:^(NSError *error) {
        
        dispatch_main_async_safe(^{
            [weakSelf hiddenMBStatus];
            [CommonUtil showAlert:@"错误" message:[error localizedDescription]];
        });
        
    }];
    
    
}

-(void)preCacheCellHeight
{
    for (int i = 0; i < _diagnosticQuestions.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MFDiagnosticQuestionDataItem *diagnosticDataItem = _diagnosticQuestions[indexPath.row];
        
        float cellHeight = [MFCustomerDiagnosisCellView heightForDiagnosticQuestionDataItem:diagnosticDataItem];
        
        [_diagnosisDataCacheHeightDic setObject:@(cellHeight) forKey:indexPath];
    }
}

-(void)onClickBackBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定退出诊断？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = 1234;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1234)
    {
        if (buttonIndex == 1)
        {
             [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)setNaviItemViews
{
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    
    _rightNaviItemView = [MFNavigationRightView viewWithNibName:@"MFNavigationRightView"];
    _rightNaviItemView.frame = CGRectMake(0, 0, 100, 44);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNaviItemView];
    [self setRightBarButtonItem:rightBarButtonItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CustomerInfo *info = [MFLoginCenter sharedCenter].currentCustomerInfo;
    if (info)
    {
        [_rightNaviItemView setHeadImageByUrl:info];
        [self setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightNaviItemView]];
    }
    else
    {
        [self setRightBarButtonItem:nil];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _diagnosticQuestions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[indexPath.row];
    
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFDiagnosticDataItem"];
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MFDiagnosticDataItem"];
        MFCustomerDiagnosisCellView *cellView = [MFCustomerDiagnosisCellView viewWithNibName:@"MFCustomerDiagnosisCellView"];
        cellView.delegate = self;
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFCustomerDiagnosisCellView *cellView = (MFCustomerDiagnosisCellView *)cell.m_subContentView;
    cellView.indexPath = indexPath;
    [cellView setQuestionDataItem:dataItem];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [_diagnosisDataCacheHeightDic objectForKey:indexPath];
    if (height) {
        return height.floatValue;
    }

    MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[indexPath.row];
    float cellHeight = [MFCustomerDiagnosisCellView heightForDiagnosticQuestionDataItem:dataItem];
    
    [_diagnosisDataCacheHeightDic setObject:@(cellHeight) forKey:indexPath];
    
    return cellHeight;
}

#pragma mark - MFCustomerDiagnosisCellViewDelegate
-(BOOL)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView shouldSelectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath
{
    MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[indexPath.row];
    NSMutableArray *selectedArray = dataItem.diagnosticResultSelectedArray;
    NSMutableArray *contentModelArray = dataItem.diagnosticContentArray;
    NSUInteger maxSelectedCount = dataItem.maxSelectedCount;
    
    NSUInteger selectedCount = selectedArray.count;
    if (maxSelectedCount > 1) {
        if (maxSelectedCount == selectedCount)
        {
            MFDiagnosticQuestionContentDataItem *selectContentModel = contentModelArray[subIndexPath.row];
            NSString *matchContent = selectContentModel.realMatch;
            if (![selectedArray containsObject:matchContent]) {
                NSString *tips = [NSString stringWithFormat:@"最多可以选%d个答案",(int)maxSelectedCount];
                [self showTips:tips withDuration:0.5];
                return NO;
            }
        }
    }
    
    return YES;
}


-(void)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView shouldNotSelectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath
{
    
}

-(void)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView didSelectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath
{
    MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[indexPath.row];
    NSMutableArray *selectedArray = dataItem.diagnosticResultSelectedArray;
    NSMutableArray *contentModelArray = dataItem.diagnosticContentArray;
    
    MFDiagnosticQuestionContentDataItem *currentSelectContentModel = contentModelArray[subIndexPath.row];
    
    NSString *matchContent = currentSelectContentModel.realMatch;
    NSLog(@"此时选中题号=%@，选中答案=%@",dataItem.questionsNumber,matchContent);
    
    NSUInteger maxSelectedCount = dataItem.maxSelectedCount;
    if (maxSelectedCount == 1)
    {
        
        if ([selectedArray containsObject:matchContent]) {
            [selectedArray removeObject:matchContent];
        }
        else
        {
            [selectedArray removeAllObjects];
            [selectedArray addObject:matchContent];
        }
    }
    else
    {
        [selectedArray addObject:matchContent];
    }
    
    for (int i = 0; i < contentModelArray.count; i++) {
        MFDiagnosticQuestionContentDataItem *contentModel = contentModelArray[i];
        NSString *matchRealContent = contentModel.realMatch;
        if ([dataItem.diagnosticResultSelectedArray containsObject:matchRealContent]) {
            contentModel.isSelected = YES;
        }
        else
        {
            contentModel.isSelected = NO;
        }
    }
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView didDeselectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath
{

    MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[indexPath.row];
    NSMutableArray *selectedArray = dataItem.diagnosticResultSelectedArray;
    NSMutableArray *contentModelArray = dataItem.diagnosticContentArray;
    MFDiagnosticQuestionContentDataItem *currentSelectContentModel = contentModelArray[subIndexPath.row];
    
    NSString *matchContent = currentSelectContentModel.realMatch;
    NSLog(@"此时反选选中题号=%@，选中答案=%@",dataItem.questionsNumber,matchContent);
    
    [selectedArray removeObject:matchContent];
    
    for (int i = 0; i < contentModelArray.count; i++) {
        MFDiagnosticQuestionContentDataItem *contentModel = contentModelArray[i];
        NSString *matchRealContent = contentModel.realMatch;
        if ([dataItem.diagnosticResultSelectedArray containsObject:matchRealContent]) {
            contentModel.isSelected = YES;
        }
        else
        {
            contentModel.isSelected = NO;
        }
    }
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)diagnosisCustomer
{
    if (![MFNetworkRequest networkReachable]) {
        [self showTips:@"网络无法连接\n请检测网络是否良好"];
        return;
    }
    
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    
    if (!individualNo) {
        [self showTips:@"此顾客individualNo为空!" withDuration:0.5];
        return;
        
    }
    
    NSMutableDictionary *diagnosisCustomerDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < _diagnosticQuestions.count; i++) {

        MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[i];
        NSMutableArray *selectedArray = dataItem.diagnosticResultSelectedArray;
        NSString *questionsNumber = dataItem.questionsNumber;

        if (0 == selectedArray.count)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
            NSString *unselectTips = [NSString stringWithFormat:@"问题%d未勾选完成",i+1];
            [self showTips:unselectTips withDuration:0.5];
            return;
        }
        
        NSString *resultStr = [selectedArray componentsJoinedByString:@","];
        if (resultStr) {
            [diagnosisCustomerDic setObject:resultStr forKey:questionsNumber];
        }
    }
    
    [self postDiagnosisCustomerReport:diagnosisCustomerDic];
}

-(void)postDiagnosisCustomerReport:(NSDictionary *)diagnosisCustomerDic
{
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    if (!individualNo) {
        [self showTips:@"请先设置一个当前顾客" withDuration:0.5];
        return;
    }
    
    NSDictionary *questionJSON = @{@"individualNo": individualNo,
                                   @"map": diagnosisCustomerDic
                                   };
    
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    BBEmployeeInfo *currentShopingGuideInfo = [MFLoginCenter sharedCenter].currentShopingGuideInfo;
    if (!currentShopingGuideInfo.entityId || !currentShopingGuideInfo.employeeId)
    {
        return;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:questionJSON
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    [self showMBStatusInViewController:@"正在诊断..." withDuration:5];
    
    __weak __typeof(self) weakSelf = self;

    _customerDiagnosticApi.entityId = currentShopingGuideInfo.entityId;
    _customerDiagnosticApi.employeeId = currentShopingGuideInfo.employeeId;
    _customerDiagnosticApi.questionVersion = @"1111";
    _customerDiagnosticApi.questionJson = jsonString;
    
    [_customerDiagnosticApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        [strongSelf hiddenMBStatus];
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        if ([responseObject[@"statusCode"] isKindOfClass:[NSNull class]]) {
            return;
        }
        
        NSString *statusCode = responseObject[@"statusCode"];
        if ([statusCode isEqualToString:@"200"])
        {
            NSNumber *diagnosisResultId = responseObject[@"diagnosisResultId"];
            
            dispatch_main_async_safe(^{
                [MFLoginCenter sharedCenter].currentCustomerInfo.lastDiagnosisResultId = diagnosisResultId;
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
                [strongSelf showDiagnosticReport:diagnosisResultId];
                [strongSelf reInitDiagnosisModelArray];
            });
        }
        else
        {
            
            NSDictionary *userInfo = @{@"errorTime":[[NSDate date] description],
                                       @"info":responseObject};
            NSString *reason = [NSString stringWithFormat:@"状态码=%@",statusCode];
            [Bugly reportException:[NSException exceptionWithName:@"顾客诊断失败" reason:reason userInfo:userInfo]];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"顾客诊断失败"
                                                            message:reason
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSError *error = request.error;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"errorTime"] = [[NSDate date] description];
        if ([MFLoginCenter sharedCenter].currentShopingGuideInfo) {
            userInfo[@"currentShopingGuideInfo"] = [MFLoginCenter sharedCenter].currentShopingGuideInfo;
        }
        
        [Bugly reportException:[NSException exceptionWithName:@"顾客诊断失败" reason:[error localizedDescription] userInfo:userInfo]];
        
        [weakSelf hiddenMBStatus];
        NSString *desc = [error localizedDescription];
        desc = [NSString stringWithFormat:@"错误描述：%@\n错误码：%@",desc,@(error.code)];
        [CommonUtil showAlert:@"网络开了小差,请重新提交" message:desc];
        
    }];
    
}

-(void)showDiagnosticReport:(NSNumber *)diagnosisResultId
{
    UIStoryboard *storyBoard = BBCreateStoryBoard;
    MFCustomerDiagnosticReportViewController *diagnosticReport = [storyBoard instantiateViewControllerWithIdentifier:@"MFCustomerDiagnosticReportViewController"];
    diagnosticReport.diagnosticReportCustomerInfo = [MFLoginCenter sharedCenter].currentCustomerInfo;
    diagnosticReport.diagnosisResultId = diagnosisResultId;
    
    [[[MFAppViewControllerManager sharedManager] currentRootNav] pushViewController:diagnosticReport animated:NO];
}

-(void)reInitDiagnosisModelArray
{
    @synchronized(self) {
        for (int i = 0; i < _diagnosticQuestions.count; i++) {

            MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[i];
            NSMutableArray *contentModelsArray = dataItem.diagnosticContentArray;
            NSMutableArray *resultSelectedArray = dataItem.diagnosticResultSelectedArray;
            
            [resultSelectedArray removeAllObjects];
            
            for (int i = 0; i < contentModelsArray.count; i++) {
                MFDiagnosticQuestionContentDataItem *contentModel = contentModelsArray[i];
                contentModel.isSelected = NO;
            }
        }
        

        [_diagnosisDataCacheHeightDic removeAllObjects];
        [self preCacheCellHeight];
        
        dispatch_main_async_safe(^{
            [_tableView setContentOffset:CGPointZero animated:NO];
            [_tableView reloadData];
        });
    }
    
}

- (IBAction)onClickDiagnosisBtn:(id)sender {
    [self diagnosisCustomer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
