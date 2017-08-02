//
//  MFCustomerInfoMainViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/11.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerInfoMainViewController.h"
#import "MFCustomerInfoMainHeader.h"
#import "MFCustomerInfoViewController.h"
#import "MFCustomerConsumptionRecordViewController.h"
#import "MFCustomerDiagnosticRecordsViewController.h"
#import "MFCreateCustomerCollectionCellObj.h"
#import "MFCustomerDiagnosticReportViewController.h"
#import "CKRadialMenu.h"
#import "MFSelecedButton.h"
#import "MFImageSaveHelper.h"
#import "MFCustomerMaintenanceViewController.h"
#import "MFCustomerBodyMadeViewController.h"
#import "MFCustomerInfoMainNavBarView.h"
#import "MFCustomerInfoMainNewViewController.h"



#pragma mark - MFCustomerInfoMainViewController
@interface MFCustomerInfoMainViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,MFCustomerInfoMainHeaderDelegate,MFSelecedButtonDelegate,MFCustomerDelegate,MFCustomerInfoMainNavBarViewDelegate>
{
    
    __weak IBOutlet MFCustomerInfoMainHeader *_infoHeader;
    __weak IBOutlet MFCustomerInfoMainNavBarView *_customerInfoNavBar;
    
    __weak IBOutlet UIView *_btnBgView;
    __weak IBOutlet UIScrollView *_contentView;
    
    UIView *_currentSelectedIndexView;
    
    NSMutableArray *_contentViewControllers;
    NSMutableArray *_middleBtnArray;
    NSMutableArray *_middleBtnObjects;
    NSMutableArray *_btnTitleArray;
    NSInteger _selecedIndex;
    
    MFCustomerBaseViewController *currentVC;
    
    UIImagePickerControllerSourceType _sourceType;
    
    UIPopoverController *popCon;
    UIImage * _image;
}

@end

@implementation MFCustomerInfoMainViewController

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

-(void)onClickBackBtn
{
    if (self.viewStatus == MFCustomerStatusEdit) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"顾客详情";
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    _customerInfoNavBar.m_delegate = self;
    
    _middleBtnArray = [NSMutableArray array];
    _contentViewControllers = [NSMutableArray array];
    
    _infoHeader.delegate = self;
    
    self.viewStatus = MFCustomerStatusView;
    [self queryInfo];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CKRadialMenuManager sharedManager].nowNav = self.navigationController;
    [[CKRadialMenuManager sharedManager] showMenu];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[CKRadialMenuManager sharedManager] hiddenMenu];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)initContentViewControllers
{
    [_contentViewControllers removeAllObjects];
    NSUInteger viewControllerCount = _btnTitleArray.count;
    
    for (int i = 0; i < viewControllerCount; i++) {
        [_contentViewControllers addObject:[NSNull null]];
    }
}

-(void)queryInfo
{
    if (!self.individualNo) {
        return;
    }
    
    [self showMBCircleInViewController];
    NSDictionary *parameters = @{
                                 @"individualNo": self.individualNo,
                                 @"token": BloomBeautyToken
                                 };
    
    __weak typeof(self)weakSelf = self;
    
    [MFHTTPUtil POST_ToDict:MFApiQueryCustomerByIdURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf hiddenMBStatus];
        NSMutableArray *arry = responseObject[@"customerVO"];
        if (arry.count == 0) {
            return;
        }
        
        CustomerInfo *obj = [CustomerInfo objectWithKeyValues:arry[0]];
        
        strongSelf.customerInfo = obj;
        strongSelf.customerInfo.phoneNumber = obj.searchKey;

        [strongSelf layoutInfoMainSubViews];
        
    } failureTips:^(NSString *tips) {
        [weakSelf hiddenMBStatus];
    }];
    
}

-(void)layoutInfoMainSubViews
{
    [_infoHeader setName:[self.customerInfo getFullName]];
    if (self.customerInfo.isDiagnosis)
    {
        self.diagnosticStatus = [self.customerInfo.isDiagnosis MF_isDiagnosis];
    }
    else
    {
        self.diagnosticStatus = NO;
    }
    
    [_infoHeader setHeadImageByUrl:self.customerInfo];
    
    [[MFLoginCenter sharedCenter] setCurrentCustomerInfo:self.customerInfo];
    
    
    [self setBtnTitleArray];
    [_infoHeader setAnalysisStatus:self.diagnosticStatus];
    [self setMiddleBtns:self.diagnosticStatus];
    
    [self initContentViewControllers];
    
    _selecedIndex = 0;
    [self setSelectedBtn:_selecedIndex];
    self.viewStatus = MFCustomerStatusView;
    [self setSelectedViewController:_selecedIndex];
}

-(void)setBtnTitleArray
{
    _middleBtnObjects = [self middleBtnObjects:self.diagnosticStatus];
    
    if (!_btnTitleArray) {
        _btnTitleArray = [NSMutableArray array];
    }
    [_btnTitleArray removeAllObjects];
    
    for (int i = 0; i < _middleBtnObjects.count; i++) {
        MFCustomerInfoMiddleBtnObject *object = _middleBtnObjects[i];
        [_btnTitleArray addObject:object.title];
    }
    
}

-(MFCustomerBaseViewController *)getViewController:(NSInteger)index
{
    MFCustomerBaseViewController *indexViewController = nil;
    if ([[_contentViewControllers objectAtIndex:index] isKindOfClass:[NSNull class]])
    {
        if (index > _middleBtnObjects.count - 1) {
            return nil;
        }
        
        MFCustomerInfoMiddleBtnObject *object = _middleBtnObjects[index];
        UIStoryboard *srotyBoard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
        
        NSString *identifier = NSStringFromClass(object.viewClass);
        indexViewController = [srotyBoard instantiateViewControllerWithIdentifier:identifier];
        
        [_contentViewControllers replaceObjectAtIndex:index withObject:indexViewController];
    }
    else
    {
        indexViewController = [_contentViewControllers objectAtIndex:index];
    }
    
    indexViewController.customerInfo = self.customerInfo;
    indexViewController.viewStatus = self.viewStatus;
    indexViewController.delegate = self;
    return indexViewController;
}

-(void)setSelectedViewController:(NSInteger)index
{
//    if(index == 0)
//    {
//        [_rightTitleView setEditBtnHide:NO];
//    }
//    else
//    {
//        [_rightTitleView setEditBtnHide:YES];
//    }
    
    id selectedVC = [_contentViewControllers objectAtIndex:_selecedIndex];
    if (selectedVC && [selectedVC isKindOfClass:[UIViewController class]])
    {
        UIViewController *selectedViewController = (UIViewController *)selectedVC;
        [selectedViewController willMoveToParentViewController:nil];
        [selectedViewController.view removeFromSuperview];
        [selectedViewController removeFromParentViewController];
    }
    _selecedIndex = index;
    currentVC = [self getViewController:_selecedIndex];
    [self addChildViewController:currentVC];
    currentVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.bounds), CGRectGetHeight(_contentView.bounds));
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_contentView addSubview:currentVC.view];
    [currentVC didMoveToParentViewController:self];
}


-(void)setSelectedBtn:(NSInteger)index
{
    [_middleBtnArray enumerateObjectsUsingBlock:^(MFSelecedButton *obj, NSUInteger idx, BOOL * stop) {
        if (obj.tag == index)
        {
            [obj setSelected:YES];
        }
        else
        {
            [obj setSelected:NO];
        }
    }];
    
    CGRect currentSelectedFrame = _currentSelectedIndexView.frame;
    MFSelecedButton *selectedBtn = _middleBtnArray[index];
    currentSelectedFrame.origin.x = selectedBtn.frame.origin.x;
    _currentSelectedIndexView.frame = currentSelectedFrame;
}

-(void)setMiddleBtns:(BOOL)diagnosticStatus
{
    CGFloat btnWidth = 185;
    CGFloat btnHeight = 48;
    CGFloat btnVSpace = 0;
    CGFloat btnCount = _btnTitleArray.count;
    
    CGFloat MiddleBtnsWidth = btnCount * btnWidth + (btnCount - 1) * btnVSpace;
    CGFloat btnOrignX = (CGRectGetWidth(_btnBgView.bounds) - MiddleBtnsWidth) / 2;
    
    UIView *btnView = [UIView new];
    btnView.frame = CGRectMake(btnOrignX, 0, MiddleBtnsWidth, btnHeight);
    btnView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_btnBgView addSubview:btnView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_btnBgView.frame) - MFOnePixHeigtht, CGRectGetWidth(_btnBgView.frame), MFOnePixHeigtht)];
    line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    line.backgroundColor = [UIColor hx_colorWithHexString:@"e3e5e8"];
    [_btnBgView addSubview:line];
    
    for (int i = 0; i < btnCount; i++)
    {
        CGRect btnFrame = CGRectMake(i * (btnWidth + btnVSpace), 0, btnWidth, btnHeight);
        MFSelecedButton *btn = [MFSelecedButton viewWithNibName:@"MFSelecedButton"];
        btn.touchDelegate = self;
        btn.normalTextColor = [UIColor hx_colorWithHexString:@"2d2c2c"];
        btn.selectedTextColor = BBDefaultColor;
        btn.tag = i;
        btn.frame = btnFrame;
        [btn setText:_btnTitleArray[i]];
        [btn setSelected:NO];
        [btnView addSubview:btn];
        
        [_middleBtnArray addObject:btn];
    }
    
    _currentSelectedIndexView = [UIView new];
    _currentSelectedIndexView.backgroundColor = BBDefaultColor;
    [btnView addSubview:_currentSelectedIndexView];
    
    MFSelecedButton *selectedBtn = _middleBtnArray.firstObject;
    _currentSelectedIndexView.frame = CGRectMake(selectedBtn.frame.origin.x, CGRectGetHeight(btnView.frame) - 3 * MFOnePixHeigtht, CGRectGetWidth(selectedBtn.frame), 3 * MFOnePixHeigtht);
}

-(void)OnTouchDown:(MFSelecedButton *)btn
{
    [self onClickSelecedButton:btn];
}

-(void)onClickSelecedButton:(MFSelecedButton *)btn
{
    _selecedIndex = btn.tag;
    [self setSelectedBtn:_selecedIndex];
    
    MFCustomerInfoMiddleBtnObject *object = _middleBtnObjects[_selecedIndex];
    if ([object.key isEqualToString:@"MFCustomerMaintenanceViewController"]) {
        [self presentCustomerMaintenanceVC];
    }
    else if ([object.key isEqualToString:@"MFCustomerBodyMadeViewController"]) {
        [self presentBodyMadeVC];
    }
    else
    {
        [self setSelectedViewController:_selecedIndex];
    }
}

#pragma mark - MFCustomerInfoMainHeaderDelegate
-(void)postEditCustomerImgInfo:(CustomerInfo *)info
{
    if([CommonUtil isNotNull:self.imageStreams])
    {
        NSString *token = BloomBeautyToken;
        NSDictionary *parameters = @{
                                     @"individualNo":info.individualNo,
                                     @"imageStreams":self.imageStreams,
                                     @"token": token
                                     };
        [MFHTTPUtil POST_ToDict:MFApiUpdatePortraitEntityURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(_image != nil)
            {
                if (responseObject[@"portraitUpdateDate"] != nil) {
                    NSString *portraitUpdateDate = responseObject[@"portraitUpdateDate"];
                    [[ImageSanBoxUtil sharedUtil] setImageByLoginUser:[self.customerInfo getImgNameByDate:portraitUpdateDate] image:_image];
                    info.imageStreams = self.imageStreams;
                    [[CustomerDao sharedManager] updatePortrait:info];
                }
            }
            _image = nil; 
        } failureTips:^(NSString *tips) {
            
        }];
    }
}

-(void)postEditCustomerInfo:(CustomerInfo *)info
{
    NSString *email = info.email;
    NSString *weChat = info.weChat;
    NSString *occupationType = info.occupationType;
    
    if (!email) {
        email = @"";
    }
    
    if (!weChat) {
        weChat = @"";
    }
    
    if (!occupationType) {
        occupationType = @"";
    }
    
    NSString *token = BloomBeautyToken;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"individualNo":info.individualNo,
                                                                                      @"lastName":info.lastName,
                                                                                      @"firstName":info.firstName,
                                                                                      @"yob":info.yob,
                                                                                      @"mob":info.mob,
                                                                                      @"dob":info.dob,
                                                                                      @"isLunar":info.isLunar,
                                                                                      @"email":email,
                                                                                      @"weChat":weChat,
                                                                                      @"occupationType":occupationType,
                                                                                      @"token": token
       
                                                                                      }];
    NSString *regionCode = info.regionCode;
    NSString *cityCode = info.cityCode;
    NSString *address = info.address;
    
    parameters[@"regionCode"] = info.regionCode;
    parameters[@"cityCode"] = info.cityCode;
    
    if ([CommonUtil isNull:regionCode]) {
        parameters[@"regionCode"] = [MFLoginCenter sharedCenter].loginInfo.regionCode;
    }
    
    if ([CommonUtil isNull:cityCode]) {
        parameters[@"cityCode"] = [MFLoginCenter sharedCenter].loginInfo.cityCode;
    }
    
    if (address) {
        parameters[@"address"] = info.address;
    }
    
    [self showMBStatusInViewController:@"正在更新顾客信息..."];
    [MFHTTPUtil POST_ToDict:MFApiUpdateCustomerURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hiddenMBStatus];
        [MFLoginCenter sharedCenter].currentCustomerInfo = info;
        
        NSString *fullName = [info getFullName];
        
        [_infoHeader setName:fullName];
        
        [[CustomerDao sharedManager] insertOrUpdate:info];
        [self showTips:@"顾客资料修改成功"];
        
    } failureTips:^(NSString *tips) {
        [self hiddenMBStatus];
        [CommonUtil showAlert:@"提示" message:tips]; 
    }];
}



#pragma mark - MFCustomerInfoMainRightTitleDelegate
-(void)onClickEditCustomer
{
    if(self.viewStatus == MFCustomerStatusView)
    {
        [self setNowViewStatus:MFCustomerStatusEdit];
        
        self.title = @"顾客详情 (正在修改顾客资料)";
//        [_rightTitleView setEditBtnTitle:@"提交资料"];
//        [_rightTitleView setEditBtnTitleColor:BBDefaultColor];
//        
//        [_rightTitleView setDiagnosticBtnHide:YES];
    }
    else
    {
        [self.view endEditing:YES];
        
        MFCustomerInfoViewController *currentVC2 = (MFCustomerInfoViewController*)currentVC;
        CustomerInfo *obj = nil;
        [self postEditCustomerInfo:obj];
        [self postEditCustomerImgInfo:obj];
        [self setNowViewStatus:MFCustomerStatusView];

        
        self.title = @"顾客详情";
//        [_rightTitleView setEditBtnTitle:@"编辑资料"];
//        [_rightTitleView setEditBtnTitleColor:MFDarkTextColor];
//        
//        [_rightTitleView setDiagnosticBtnHide:NO];
    }
}

-(void)setNowViewStatus:(MFCustomerStatus )status
{
    currentVC.viewStatus = status;
    self.viewStatus = status;
}

-(void)onClickDiagnosticCustomer
{
    [MFLoginCenter sharedCenter].currentCustomerInfo = self.customerInfo;
    [[MFAppViewControllerManager sharedManager] jumpToCustomerAnalysis];
}

#pragma mark - MFLongPressImageViewDelegate
- (void)OnTouchDownImgView:(MFUILongPressImageView*)imgView
{
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",@"取消", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil  otherButtonTitles:@"从相册选择",@"取消", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (_sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [[MFImageSaveHelper new] saveImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [popCon dismissPopoverAnimated:NO];
    }
    
    _image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(_image != nil)
    {
        _image =  [_image resizeImageSize:CGSizeMake(120.0f, 120.0f)];
    }
    
    NSData *imageData = UIImagePNGRepresentation(_image);
    NSData *base64Data = [GTMBase64 encodeData:imageData];
    self.imageStreams = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    [_infoHeader setHeadImage:_image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 1 || buttonIndex == -1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        _sourceType = sourceType;
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = _sourceType;
        
        if (_sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
        }
        else
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                popCon = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
                [popCon presentPopoverFromRect:_infoHeader.headImageView.bounds inView:_infoHeader.headImageView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                
            }];
        }
        
    }
}

-(void)presentCustomerMaintenanceVC
{
    UIViewController *vc = [self customerMaintenanceVC];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(MFCustomerMaintenanceViewController *)customerMaintenanceVC
{
    UIStoryboard *srotyBoard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
    return [srotyBoard instantiateViewControllerWithIdentifier:@"MFCustomerMaintenanceViewController"];
}

-(void)presentBodyMadeVC
{
    UIViewController *vc = [self bodyMadeVC];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(MFCustomerBodyMadeViewController *)bodyMadeVC
{
    UIStoryboard *srotyBoard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
    return [srotyBoard instantiateViewControllerWithIdentifier:@"MFCustomerBodyMadeViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
