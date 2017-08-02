//
//  MFCustomerBodyMadeViewController.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeViewController.h"
#import "MFCustomerBodyMadeLogicController.h"
#import "MFCustomerBodyMadeCollectionHeaderView.h"
#import "MFCustomerBodyMadeCollectionItemView.h"
#import "MFCustomerBodyMadeModel.h"
#import "MFCustomerBodyMadeUnderwearItemView.h"
#import "MFCustomerBodyMadeQueryApi.h"
#import "MFCustomerBodyMadeUpdateApi.h"
#import "MFCustomerBodyMadeInputView.h"
#import "MFCustomerBodyMadeCollectionInputTipsView.h"
#import "MFCustomerBodyMadeCollectionNormalHeaderView.h"
#import "MFDiagnosticQuestionDressingSolveView.h"

@interface MFCustomerBodyMadeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MFCustomerBodyMadeInputViewDelegate,MFCustomerBodyMadeCollectionItemViewDelegate>
{
    __weak IBOutlet UICollectionView *_bodyMadeCollectionView;
    __weak IBOutlet UIButton *_submitBtn;
    
    MFCustomerBodyMadeLogicController *m_logic;
    NSMutableArray *_underWearTemplates;
    NSMutableArray *_bodyMadeTemplates;
    
    UICollectionViewFlowLayout *_layout;
    
    MFCustomerBodyMadeUpdateApi *_bodyMadeUpdateApi;
    MFCustomerBodyMadeQueryApi *_bodyMadeQueryApi;
    
    BOOL _editingBodyMade;
    
    NSMutableDictionary *_bodyMadeResultInfo;
    MFCustomerBodyMadeInputView *_inputView;
}

@end

@implementation MFCustomerBodyMadeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"定制服务";
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    [self setRightNaviButtonWithTitle:@"重新量体" action:@selector(resetInputBodyMadeData)];
    
    
    _bodyMadeCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _bodyMadeCollectionView.collectionViewLayout = _layout;
    
    m_logic = [MFCustomerBodyMadeLogicController new];
    [m_logic readjsonData];
    
    _bodyMadeUpdateApi = [MFCustomerBodyMadeUpdateApi new];
    _bodyMadeQueryApi = [MFCustomerBodyMadeQueryApi new];
    
    _underWearTemplates = [m_logic underWearTemplates];
    _bodyMadeTemplates = [m_logic bodyMadeTemplates];
    
    [_bodyMadeCollectionView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFCustomerBodyMadeUnderwearItemView"];
    [_bodyMadeCollectionView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFDiagnosticQuestionDressingSolveView"];
    [_bodyMadeCollectionView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"bodyMadeFirstTipIdentifier"];
    [_bodyMadeCollectionView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFCustomerBodyMadeCollectionItemView"];
    [_bodyMadeCollectionView registerClass:[MFCustomerBodyMadeCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCustomerBodyMadeBodyMadeHeader"];
    
    _editingBodyMade = YES;
    
    _bodyMadeResultInfo = [NSMutableDictionary dictionary];
    [self queryBodyMadeData];
    
    [self initBodyMadeInputView];
    
    [_inputView setHidden:YES];
}

-(void)initBodyMadeInputView
{
    _inputView = [MFCustomerBodyMadeInputView viewWithNib];
    _inputView.m_delegate = self;
    _inputView.frame = self.view.bounds;
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_inputView];
}

#pragma mark - MFCustomerBodyMadeInputViewDelegate

+ (BOOL)checkNumber:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
    }
    
    NSString *regex = @"^[0-9]+(.[0-9]{1})?$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
}

-(void)onFinishEndEditingBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem string:(NSString *)value
{
    BOOL matchValue = [[self class] checkNumber:value];
    
    if (matchValue) {
        bodyMadeItem.bodyMadeValue = [MFCustomerBodyMadeHelper makeBodyMadeValueJsonString:bodyMadeItem value:value];
    }
    else
    {
        [CommonUtil showAlert:@"提示" message:@"输入数据以cm（厘米）为单位精确到小数点后一位，如88.8cm,88cm,60度。注意输入小数点。"];
        return;
    }
    
    [_inputView setHidden:YES];
    [_inputView resignFirstResponder];
    
    [_bodyMadeCollectionView reloadData];
}

-(void)cancelInputBodyMade
{
    [_inputView setHidden:YES];
    [_inputView resignFirstResponder];
}

#pragma mark - MFCustomerBodyMadeCollectionItemViewDelegate
-(void)onClickInputBodyMade:(MFCustomerBodyMadeModel *)bodyMadeItem
{
//    [_inputView setHidden:NO];
//    
//    [_inputView becomeFirstResponder];
//    [_inputView setBodyMadeModel:bodyMadeItem];
}

-(void)setEditingBodyMade:(BOOL)editingBodyMade
{
    if (editingBodyMade) {
        [_submitBtn setHidden:NO];
    }
    else
    {
        [_submitBtn setHidden:YES];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _underWearTemplates.count;
    }
    else if (section == 1)
    {
        if (_editingBodyMade) {
            return _bodyMadeTemplates.count + 1;
        }
        
        return _bodyMadeTemplates.count;
    }
    
    return 0;
        
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0)
    {
        UICollectionViewCell *cell = [self collectionView:collectionView underWearCellForItemAtIndexPath:indexPath];
        return cell;
    }
    else if (section == 1)
    {
        if (_editingBodyMade)
        {
            if (indexPath.row == 0)
            {
                return [self collectionView:collectionView bodyMadeFirstTipCellForItemAtIndexPath:indexPath];
            }
            else
            {
                return [self collectionView:collectionView bodyMadeCellForItemAtIndexPath:indexPath];
            }
        }
        
        return [self collectionView:collectionView bodyMadeCellForItemAtIndexPath:indexPath];

    }
    
    return [UICollectionViewCell new];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView underWearCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFCustomerBodyMadeUnderWearModel *underWearModel = _underWearTemplates[indexPath.row];
    if ([underWearModel.key isEqualToString:@"solveProblem"]) {
        return [self collectionView:collectionView dressingSolveCellForItemAtIndexPath:indexPath];
    }
    
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFCustomerBodyMadeUnderwearItemView" forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFCustomerBodyMadeUnderwearItemView *cellView = [[MFCustomerBodyMadeUnderwearItemView alloc] initWithFrame:CGRectZero];
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    MFCustomerBodyMadeUnderwearItemView *cellView = (MFCustomerBodyMadeUnderwearItemView *)cell.m_subContentView;
    
    [cellView setUnderWearModel:underWearModel editing:_editingBodyMade];
    
    return cell;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dressingSolveCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFDiagnosticQuestionDressingSolveView" forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFDiagnosticQuestionDressingSolveView *cellView = [MFDiagnosticQuestionDressingSolveView viewWithNib];
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFDiagnosticQuestionDressingSolveView *cellView = (MFDiagnosticQuestionDressingSolveView *)cell.m_subContentView;
    MFCustomerBodyMadeUnderWearModel *underWearModel = _underWearTemplates[indexPath.row];
    [cellView setUnderWearModel:underWearModel editing:_editingBodyMade];
    
    return cell;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView bodyMadeFirstTipCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bodyMadeFirstTipIdentifier" forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFCustomerBodyMadeCollectionInputTipsView *cellView = [MFCustomerBodyMadeCollectionInputTipsView viewWithNib];
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    
    MFCustomerBodyMadeCollectionInputTipsView *tipsView = (MFCustomerBodyMadeCollectionInputTipsView *)cell.m_subContentView;
    NSDictionary *info = [m_logic bodyMadeFirstTipInfo];
    [tipsView setTipsInfo:info];
    
    return cell;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView bodyMadeCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFCustomerBodyMadeCollectionItemView" forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFCustomerBodyMadeCollectionItemView *cellView = [MFCustomerBodyMadeCollectionItemView viewWithNib];
        cellView.m_delegate = self;
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    MFCustomerBodyMadeCollectionItemView *cellView = (MFCustomerBodyMadeCollectionItemView *)cell.m_subContentView;
    cellView.superScrollView = _bodyMadeCollectionView;
    
    MFCustomerBodyMadeModel *bodyMadeItem = nil;
    if (_editingBodyMade)
    {
        bodyMadeItem = _bodyMadeTemplates[indexPath.row - 1];
    }
    else
    {
        bodyMadeItem = _bodyMadeTemplates[indexPath.row];
    }
    
    [cellView setBodyMadeModel:bodyMadeItem editing:_editingBodyMade];
    
    return cell;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MFCustomerBodyMadeUnderWearModel *underWearModel = _underWearTemplates[indexPath.row];
        
        if ([underWearModel.key isEqualToString:@"solveProblem"]) {
            return [MFDiagnosticQuestionDressingSolveView sizeForUnderWearModel:underWearModel
                                                                 availableWidth:CGRectGetWidth(collectionView.frame) editing:_editingBodyMade];
        }
        
        return [MFCustomerBodyMadeUnderwearItemView sizeForUnderWearModel:underWearModel
                                                           availableWidth:CGRectGetWidth(collectionView.frame)
                                                                  editing:_editingBodyMade];
    }
    else if (indexPath.section == 1)
    {
//        if (_editingBodyMade)
//        {
//            if (indexPath.row == 0)
//            {
//                NSDictionary *info = [m_logic bodyMadeFirstTipInfo];
//                CGSize size = [MFCustomerBodyMadeCollectionInputTipsView sizeForTipsInfo:info];
//                return size;
//            }
//            else
//            {
//                MFCustomerBodyMadeModel *bodyMadeItem = _bodyMadeTemplates[indexPath.row - 1];
//                return [MFCustomerBodyMadeCollectionItemView sizeForBodyMadeModel:bodyMadeItem];
//            }
//            
//        }
//        else
//        {
//            MFCustomerBodyMadeModel *bodyMadeItem = _bodyMadeTemplates[indexPath.row];
//            return [MFCustomerBodyMadeCollectionItemView sizeForBodyMadeModel:bodyMadeItem];
//        }
        
        return [MFCustomerBodyMadeCollectionItemView sizeForBodyMadeModel:nil];
    }
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        MFCustomerBodyMadeCollectionHeaderView *headerView = (MFCustomerBodyMadeCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCustomerBodyMadeBodyMadeHeader" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            
            [headerView setTitle:@"内衣尺寸"];
        }
        else if (indexPath.section == 1) {
            
            [headerView setTitle:@"量体定制"];
        }
        
        reusableview = headerView;
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 72);
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 56);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0)
    {
        return UIEdgeInsetsMake(15, 0, 0, 0);
    }
    else if  (section == 1)
    {
        return UIEdgeInsetsMake(10, 56, 0, 56);
    }
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //上下
    if (section == 1) {
        return 10;
    }
    
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //左右
    if (section == 1) {
        return (CGRectGetWidth(collectionView.frame) - 3*241 - 112) / 2;
    }
    
    return 0;
}

-(void)resetInputBodyMadeData
{
    _editingBodyMade = YES;
    [self setEditingBodyMade:_editingBodyMade];
    
    [_bodyMadeCollectionView setContentOffset:CGPointZero];
    [_bodyMadeCollectionView reloadData];
}

- (IBAction)onClickSubmitBtn:(id)sender {
    [self submitBodyMadeData];
}

-(void)submitBodyMadeData
{
    NSMutableDictionary *paramaDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < _underWearTemplates.count; i++) {
        MFCustomerBodyMadeUnderWearModel *underWearModel = _underWearTemplates[i];
        NSString *key = underWearModel.key;
        NSArray *keyValues = underWearModel.selectedQuestions;
        
        NSString *valueString = nil;
        if (keyValues.count > 0) {
            valueString = [keyValues componentsJoinedByString:@","];
        }
        
        if (valueString && key) {
            paramaDic[key] = valueString;
        }
    }
    
    for (int i = 0; i < _bodyMadeTemplates.count; i++) {
        MFCustomerBodyMadeModel *bodyMadeItem = _bodyMadeTemplates[i];
        NSString *key = bodyMadeItem.key;
        NSString *valueString = bodyMadeItem.bodyMadeValue;
        
        if (!valueString) {
            NSString *remark = bodyMadeItem.remark;
            NSString *tipsString = [NSString stringWithFormat:@"请录入%@",remark];
            [self showTips:tipsString withDuration:1.0];
            NSIndexPath *tipIndex = [NSIndexPath indexPathForRow:i inSection:1];
            [_bodyMadeCollectionView scrollToItemAtIndexPath:tipIndex atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            return;
        }
        
        if (valueString && key) {
            paramaDic[key] = valueString;
        }
    }
    
    [self postBodyData:paramaDic];
    
}

-(void)postBodyData:(NSDictionary *)valueInfo
{
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    if (!individualNo) {
        [self showTips:@"请先设置一个当前顾客" withDuration:0.5];
        return;
    }
    
    [self showMBStatusInViewController:@"正在提交量体数据..."];
    
    __weak __typeof(self) weakSelf = self;
    _bodyMadeUpdateApi.individualNo = individualNo;
    _bodyMadeUpdateApi.updateKeyValues = valueInfo;
    [_bodyMadeUpdateApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        dispatch_main_async_safe(^{
            [strongSelf hiddenMBStatus];
        });
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSString *statusCode = responseObject[@"statusCode"];
        if ([statusCode isKindOfClass:[NSNull class]]) {
            return;
        }
        
        if ([statusCode isEqualToString:@"200"]) {
            dispatch_main_async_safe(^{
                [self showTips:@"提交数据成功"];
                _editingBodyMade = NO;
                [self setEditingBodyMade:_editingBodyMade];
                [_bodyMadeCollectionView setContentOffset:CGPointZero];
                [_bodyMadeCollectionView reloadData];
            });
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"状态码=%@\n描述=%@",statusCode,responseObject[@"message"]];
            [CommonUtil showAlert:@"提示" message:message];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSString *tips = request.error.localizedDescription;
        [CommonUtil showAlert:@"提示" message:tips];
        
    }];
}

-(void)queryBodyMadeData
{
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    if (!individualNo) {
        [self showTips:@"请先设置一个当前顾客" withDuration:0.5];
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    _bodyMadeQueryApi.individualNo = individualNo;
    [_bodyMadeQueryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSDictionary *customerMeasurementData = responseObject[@"customerMeasurement"];
        if ([customerMeasurementData isKindOfClass:[NSNull class]]) {
            return;
        }
        
        BOOL hasBodyMadeData = NO;
        NSString *flag = responseObject[@"flag"];
        if ([flag isEqualToString:@"Y"]) {
            hasBodyMadeData = YES;
        }
        
        [_bodyMadeResultInfo removeAllObjects];
        for (int i = 0; i < customerMeasurementData.allKeys.count; i++) {
            NSString *key = customerMeasurementData.allKeys[i];
            id value = customerMeasurementData[key];
            if (![value isKindOfClass:[NSNull class]]) {
                _bodyMadeResultInfo[key] = value;
            }
        }
        
        if (hasBodyMadeData) {
            _editingBodyMade = NO;
        }
        else
        {
            _editingBodyMade = YES;
        }
        
        [strongSelf fixResultBodyMadeData];
        
        dispatch_main_async_safe(^{
            [strongSelf setEditingBodyMade:_editingBodyMade];
            [_bodyMadeCollectionView reloadData];
        });

        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}


-(void)fixResultBodyMadeData
{
    for (int i = 0; i < _underWearTemplates.count; i++) {
        MFCustomerBodyMadeUnderWearModel *underWearModel = _underWearTemplates[i];
        NSString *fixKey = underWearModel.key;
        NSString *valueString = _bodyMadeResultInfo[fixKey];
        
        NSArray *resultKey = [valueString componentsSeparatedByString:@","];
        underWearModel.selectedQuestions = [NSMutableArray arrayWithArray:resultKey];
    }
    
    for (int i = 0; i < _bodyMadeTemplates.count; i++) {
        MFCustomerBodyMadeModel *bodyMadeItem = _bodyMadeTemplates[i];
        NSString *key = bodyMadeItem.key;
        NSString *valueString = _bodyMadeResultInfo[key];
        
        bodyMadeItem.bodyMadeValue = valueString;
    }
}

-(void)onClickBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
