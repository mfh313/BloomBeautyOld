//
//  MFCustomerInfoMainNewViewController.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/13.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoMainNewViewController.h"
#import "MFCustomerInfoMainHeaderView.h"
#import "MFCustomerCreateViewController.h"
#import "MFImageSaveHelper.h"
#import "MFQueryCustomerByIdApi.h"
#import "MFCustomerInfoViewController.h"
#import "MFCustomerConsumptionRecordViewController.h"
#import "MFCustomerDiagnosticRecordsViewController.h"
#import "MFUpdateCustomerApi.h"
#import "MFUpdatePortraitEntityApi.h"
#import "MFCustomerInfoMainRightTitleNavView.h"


@implementation MFCustomerInfoMiddleBtnObject

+(instancetype)objectWith:(NSString *)key class:(Class)viewClass btnTitle:(NSString *)title
{
    MFCustomerInfoMiddleBtnObject *object = [[MFCustomerInfoMiddleBtnObject alloc] init];
    
    object.key = key;
    object.viewClass = viewClass;
    object.title = title;
    
    return object;
}


@end

@interface MFCustomerInfoMainNewViewController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFCustomerInfoMainHeaderViewDataSource,MFCustomerInfoMainHeaderViewDelegate,WCActionSheetDelegate,MFCustomerInfoViewControllerDelegate,MFCustomerInfoMainRightTitleDelegate>
{
    __weak IBOutlet MFCustomerInfoMainHeaderView *_headerView;
    __weak IBOutlet UIScrollView *_contentVCView;
    BOOL _diagnosticStatus;
    BOOL _editingInfo;
    NSString *_imageStreams;
    NSMutableArray *_contentViewControllers;
    NSInteger _currentSelectedIndex;
    MFCustomerInfoMainRightTitleNavView *_navRightView;
    
}

@property (strong, nonatomic) CustomerInfo *customerInfo;

@end

@implementation MFCustomerInfoMainNewViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CKRadialMenuManager sharedManager].nowNav = self.navigationController;
    [[CKRadialMenuManager sharedManager] showMenu];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[CKRadialMenuManager sharedManager] hiddenMenu];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"顾客详情";
    
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn)];
    
    _navRightView = [MFCustomerInfoMainRightTitleNavView viewWithNib];
    _navRightView.delegate = self;
    _navRightView.frame = CGRectMake(0, 0, 350, 44);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightView];
    [self setRightBarButtonItem:rightBarButtonItem];
    
    _headerView.m_dataSource = self;
    _headerView.m_delegate = self;
    
    _editingInfo = NO;
    [self queryCustomerInfo];
}

-(NSMutableArray *)middleBtnObjects:(BOOL)diagnosticStatus
{
    NSMutableArray *objects = [NSMutableArray array];
    
    [objects addObject:[MFCustomerInfoMiddleBtnObject objectWith:@"MFCustomerInfoViewController"
                                                           class:NSClassFromString(@"MFCustomerInfoViewController")btnTitle:@"顾客资料"]];
    [objects addObject:[MFCustomerInfoMiddleBtnObject objectWith:@"MFCustomerConsumptionRecordViewController"
                                                           class:NSClassFromString(@"MFCustomerConsumptionRecordViewController")btnTitle:@"消费记录"]];
    if (diagnosticStatus) {
        [objects addObject:[MFCustomerInfoMiddleBtnObject objectWith:@"MFCustomerDiagnosticRecordsViewController"
                                                               class:NSClassFromString(@"MFCustomerDiagnosticRecordsViewController")btnTitle:@"诊断记录"]];
    }
    
    [objects addObject:[MFCustomerInfoMiddleBtnObject objectWith:@"MFCustomerBodyMadeViewController"
                                                           class:NSClassFromString(@"MFCustomerBodyMadeViewController")btnTitle:@"定制服务"]];
    
    return objects;
}

-(NSMutableArray *)middleBtnObjects
{
    return [self middleBtnObjects:_diagnosticStatus];
}

-(BOOL)isDiagnosis
{
    if (self.customerInfo.isDiagnosis)
    {
        return [self.customerInfo.isDiagnosis MF_isDiagnosis];
    }
    
    return NO;
}

-(void)didClickMiddleButton:(NSString *)viewKey index:(NSInteger)index
{
    if ([viewKey isEqualToString:@"MFCustomerBodyMadeViewController"]) {
        [self presentBodyMadeVC];
    }
    else
    {
        [self setSelectedViewController:index];
    }
}

-(void)initContentViewControllers
{
    if (!_contentViewControllers) {
        _contentViewControllers = [NSMutableArray array];
    }
    [_contentViewControllers removeAllObjects];
    
    NSInteger viewControllerCount = [[self middleBtnObjects:_diagnosticStatus] count];
    
    for (int i = 0; i < viewControllerCount; i++) {
        [_contentViewControllers addObject:[NSNull null]];
    }
}

-(UIViewController *)selectedViewController:(NSInteger )index
{
    if (_contentViewControllers.count < index) {
        return nil;
    }
    
    MFCustomerBaseViewController *indexViewController = nil;
    
    id selectedVC = [_contentViewControllers objectAtIndex:index];
    if ([selectedVC isKindOfClass:[UIViewController class]])
    {
        indexViewController  = (MFCustomerBaseViewController *)selectedVC;
    }
    else if ([selectedVC isKindOfClass:[NSNull class]])
    {
        NSMutableArray *middleObjects = [self middleBtnObjects:_diagnosticStatus];
        MFCustomerInfoMiddleBtnObject *infoObject = middleObjects[index];
        
        UIStoryboard *srotyBoard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
        NSString *identifier = NSStringFromClass(infoObject.viewClass);
        MFCustomerBaseViewController *viewVC = [srotyBoard instantiateViewControllerWithIdentifier:identifier];
        [_contentViewControllers replaceObjectAtIndex:index withObject:viewVC];
        
        if ([identifier isEqualToString:@"MFCustomerInfoViewController"]) {
            MFCustomerInfoViewController *infoVC = (MFCustomerInfoViewController *)viewVC;
            infoVC.m_delegate = self;
        }
        
        indexViewController = viewVC;
        
    }
    
    indexViewController.customerInfo = self.customerInfo;
    
    return indexViewController;
}

-(BOOL)isEditingInfo
{
    return _editingInfo;
}

-(NSInteger)viewControllerIndexWithVCKey:(NSString *)key
{
    NSMutableArray *middleObjects = [self middleBtnObjects:_diagnosticStatus];
    for (int i = 0; i < middleObjects.count; i++) {
        MFCustomerInfoMiddleBtnObject *infoObject = middleObjects[i];
        if ([infoObject.key isEqualToString:key]) {
            return i;
        }
    }
    
    return NSNotFound;
}

-(void)setSelectedViewController:(NSInteger)index
{
    if (_contentViewControllers.count == 0) {
        [self initContentViewControllers];
    }
    
    id selectedVC = [_contentViewControllers objectAtIndex:_currentSelectedIndex];
    if (selectedVC && [selectedVC isKindOfClass:[UIViewController class]])
    {
        UIViewController *selectedViewController = (UIViewController *)selectedVC;
        [selectedViewController willMoveToParentViewController:nil];
        [selectedViewController.view removeFromSuperview];
        [selectedViewController removeFromParentViewController];
    }
    
    _currentSelectedIndex = index;
    
    UIViewController *currentVC = [self selectedViewController:_currentSelectedIndex];
    [self addChildViewController:currentVC];
    currentVC.view.frame = _contentVCView.bounds;
    _contentVCView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_contentVCView addSubview:currentVC.view];
    [currentVC didMoveToParentViewController:self];
}

-(void)queryCustomerInfo
{
    if (!self.individualNo) {
        return;
    }
    
    [self showMBCircleInViewController];
    
    __weak __typeof(self) weakSelf = self;
    
    MFQueryCustomerByIdApi *queryApi = [MFQueryCustomerByIdApi new];
    queryApi.individualNo = self.individualNo;
    [queryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [weakSelf hiddenMBStatus];
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSString *statusCode = responseObject[@"statusCode"];
        if ([statusCode isKindOfClass:[NSNull class]]) {
            [CommonUtil showAlert:@"网络开了小差,请重新提交" message:@"返回没有状态码"];
            return;
        }
        if (![statusCode isEqualToString:@"200"]) {
            NSString *title = [NSString stringWithFormat:@"出错了，状态码=%@",statusCode];
            [CommonUtil showAlert:title message:responseObject[@"message"]];
            return;
        }
        
        NSMutableArray *customerVO = responseObject[@"customerVO"];
        if (customerVO.count == 0) {
            return;
        }
        
        CustomerInfo *customerInfo = [CustomerInfo yy_modelWithDictionary:customerVO.firstObject];
        
        self.customerInfo = customerInfo;
        
        [[MFLoginCenter sharedCenter] setCurrentCustomerInfo:self.customerInfo];
        
        [self layoutInfoMainSubViews];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [weakSelf hiddenMBStatus];
        NSError *error = request.error;
        NSString *desc = [error localizedDescription];
        desc = [NSString stringWithFormat:@"错误描述：%@\n错误码：%@",desc,@(error.code)];
        [CommonUtil showAlert:@"网络开了小差,请重新提交" message:desc];
        
    }];
}

-(void)layoutInfoMainSubViews
{
    _diagnosticStatus = [self isDiagnosis];
    
    NSInteger currentSelectedVCIndex = 0;
    [_headerView setMiddleBtnSelectIndex:currentSelectedVCIndex];
    [_headerView setCustomerInfo:self.customerInfo];
    
    [self initContentViewControllers];
    
    [self setSelectedViewController:currentSelectedVCIndex];
}

#pragma mark - MFCustomerInfoMainHeaderViewDelegate
-(void)onTouchDownHeadImage
{
    if (!_editingInfo) {
        return;
    }
    
    [self.view endEditing:YES];
    
    WCActionSheet *actionSheet = [[WCActionSheet alloc] initWithTitle:@"选择图片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"从相册选择",nil];
    [actionSheet showInView:MFAppWindow];
}

- (void)actionSheet:(WCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        BOOL hasCameraAuthor = [MFCustomerCreateViewController hasCameraAuthor];
        if(!hasCameraAuthor) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"请在iPad的\"设置-隐私-相机\"选项中，允许装扮灵访问你的相机。"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    else if(buttonIndex == 1)
    {
        BOOL hasPhotoAlbumAuthor = [MFCustomerCreateViewController hasPhotoAlbumAuthor];
        if(!hasPhotoAlbumAuthor) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"请在iPad的\"设置-隐私-照片\"选项中，允许装扮灵访问你的相册。"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
        imagePickerController.popoverPresentationController.sourceView = self.view;
        
        CGRect sourceRect = [_headerView imagePickerSourceRectToView:self.view];
        
        imagePickerController.popoverPresentationController.sourceRect = sourceRect;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] resizeImageSize:CGSizeMake(120.0f, 120.0f)];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *base64Data = [GTMBase64 encodeData:imageData];
    _imageStreams = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    
    [[MFImageSaveHelper new] saveImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [_headerView setHeaderImage:image];
}

-(void)onClickBackBtn
{
    if (_editingInfo) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您正在修改顾客资料，是否退出编辑？"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)onClickEditCustomer
{
    NSInteger infoVCIndex = [self viewControllerIndexWithVCKey:@"MFCustomerInfoViewController"];
    if (infoVCIndex == NSNotFound) {
        return;
    }
    
    MFCustomerInfoViewController *infoVC = (MFCustomerInfoViewController *)[self selectedViewController:infoVCIndex];
    
    if (!_editingInfo) {
        _editingInfo = YES;
        self.title = @"顾客详情 (正在修改顾客资料)";
        [_navRightView setEditBtnTitle:@"提交资料"];
        
        _currentSelectedIndex = infoVCIndex;
        [_headerView setMiddleBtnSelectIndex:_currentSelectedIndex];
        [self setSelectedViewController:_currentSelectedIndex];
        
        [infoVC setEditngInfo:_editingInfo];
    }
    else
    {
        if (![self checkEditCustomerInfo]) {
            return;
        }
        
        _editingInfo = NO;
        self.title = @"顾客详情";
        [_navRightView setEditBtnTitle:@"编辑资料"];
        [infoVC setEditngInfo:_editingInfo];
        
        [self postEditCustomerInfo];
        [self editCustomerAvatarInfo];
    }
}

-(BOOL)checkEditCustomerInfo
{
    NSInteger infoVCIndex = [self viewControllerIndexWithVCKey:@"MFCustomerInfoViewController"];
    if (infoVCIndex == NSNotFound) {
        return NO;
    }
    
    MFCustomerInfoViewController *infoVC = (MFCustomerInfoViewController *)[self selectedViewController:infoVCIndex];
    NSMutableDictionary *updateInfos = [infoVC editingInfoValues];
    
    NSArray *apiRequiredkeyArray = @[@"lastName",@"firstName",@"birthDay",@"regionCity",@"occupationType",@"oftenEnterOccation",@"oftenAccompanyPerson",@"customerMentality"];
    NSArray *requiredDescArray = @[@"姓不能为空",@"名不能为空",@"请填写生日信息",@"请选择常住地区",@"请选择职业",@"请选择常出入场合",@"请选择常购物同伴",@"请选择购买心理"];
    for (int i = 0; i < apiRequiredkeyArray.count; i++) {
        NSString *key = apiRequiredkeyArray[i];
        NSString *errorTips = requiredDescArray[i];
        
        if ([key isEqualToString:@"birthDay"]) {
            if (updateInfos[@"yob"] && updateInfos[@"mob"] && updateInfos[@"dob"] && updateInfos[@"isLunar"]) {
                continue;
            }
            
            [self showTips:errorTips];
            return NO;
        }
        else if ([key isEqualToString:@"regionCity"])
        {
            if (updateInfos[@"regionCode"]) {
                continue;
            }
            
            [self showTips:errorTips];
            return NO;
        }
        else if (!updateInfos[key])
        {
            [self showTips:errorTips];
            return NO;
        }
    }
    
    return YES;
}

-(void)postEditCustomerInfo
{
    NSInteger infoVCIndex = [self viewControllerIndexWithVCKey:@"MFCustomerInfoViewController"];
    if (infoVCIndex == NSNotFound) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    [self showMBCircleInViewController];
    
    MFCustomerInfoViewController *infoVC = (MFCustomerInfoViewController *)[self selectedViewController:infoVCIndex];
    NSMutableDictionary *updateInfos = [infoVC editingInfoValues];
    
    MFUpdateCustomerApi *updateCustomerApi = [MFUpdateCustomerApi new];
    updateCustomerApi.individualNo = self.individualNo;
    updateCustomerApi.editingInfoValues = updateInfos;
    [updateCustomerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSString *statusCode = responseObject[@"statusCode"];
        if ([statusCode isKindOfClass:[NSNull class]]) {
            [CommonUtil showAlert:@"网络开了小差,请重新提交" message:@"返回没有状态码"];
            return;
        }
        if (![statusCode isEqualToString:@"200"]) {
            NSString *title = [NSString stringWithFormat:@"出错了，状态码=%@",statusCode];
            [CommonUtil showAlert:title message:responseObject[@"message"]];
            return;
        }
        
        [weakSelf showTips:@"顾客资料修改成功"];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSError *error = request.error;
        NSString *desc = [error localizedDescription];
        desc = [NSString stringWithFormat:@"错误描述：%@\n错误码：%@",desc,@(error.code)];
        [CommonUtil showAlert:@"网络开了小差,请重新提交" message:desc];
        
    }];
}

-(void)editCustomerAvatarInfo
{
    if ([CommonUtil isNull:_imageStreams]) {
        return;
    }
    
    MFUpdatePortraitEntityApi *updatePortraitEntityApi = [MFUpdatePortraitEntityApi new];
    updatePortraitEntityApi.individualNo = self.individualNo;
    updatePortraitEntityApi.imageStreams = _imageStreams;
    [updatePortraitEntityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSString *statusCode = responseObject[@"statusCode"];
        if ([statusCode isKindOfClass:[NSNull class]]) {
            [CommonUtil showAlert:@"网络开了小差,请重新提交" message:@"返回没有状态码"];
            return;
        }
        if (![statusCode isEqualToString:@"200"]) {
            NSString *title = [NSString stringWithFormat:@"出错了，状态码=%@",statusCode];
            [CommonUtil showAlert:title message:responseObject[@"message"]];
            return;
        }
        
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSError *error = request.error;
        NSString *desc = [error localizedDescription];
        desc = [NSString stringWithFormat:@"错误描述：%@\n错误码：%@",desc,@(error.code)];
        [CommonUtil showAlert:@"网络开了小差,请重新提交" message:desc];
        
    }];

}

-(void)onClickDiagnosticCustomer
{
    if (!self.customerInfo) {
        return;
    }
    
    [MFLoginCenter sharedCenter].currentCustomerInfo = self.customerInfo;
    [[MFAppViewControllerManager sharedManager] jumpToCustomerAnalysis];
}

-(void)presentBodyMadeVC
{
    UIStoryboard *srotyBoard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
    UIViewController *vc  = [srotyBoard instantiateViewControllerWithIdentifier:@"MFCustomerBodyMadeViewController"];
    MFNavigationController *nav = [[MFNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
