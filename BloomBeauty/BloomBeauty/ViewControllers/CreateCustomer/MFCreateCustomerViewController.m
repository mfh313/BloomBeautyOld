//
//  MFCreateCustomerViewController.m
//  装扮灵
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCreateCustomerViewController.h"
#import "MFCreateCustomerView.h"
#import "MFUILongPressImageView.h"
#import "MFLoginCenter.h"
#import "CustomerInfo.h"
#import "MFCustomerInfoMainViewController.h"
#import "MFImageSaveHelper.h"


@interface MFCreateCustomerViewController ()<MFLongPressImageViewDelegate,MFCreateCustomerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet MFCreateCustomerView *_creatCustomView;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet MFUILongPressImageView *_headImageView;
    
    UIImagePickerControllerSourceType _sourceType;
    UIPopoverController *popCon;
    
    
}

@property (nonatomic,strong) CustomerInfo* customerInfo;
@property (nonatomic,strong) NSString *imageStreams;
@property (nonatomic,assign) MFCustomerStatus viewStatus;

@end

@implementation MFCreateCustomerViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新建顾客";
    
    [self MF_wantsFullScreenLayout:NO];
    
    _creatCustomView.delegate = self;
    _creatCustomView.viewStatus = MFCustomerStatusAdd;
    
    _headImageView.delegate = self;
    
    _headImageView.layer.cornerRadius = 41;
    _headImageView.layer.masksToBounds = YES;
    
    [self initSubViews];
}

#pragma mark - MFLongPressImageViewDelegate
- (void)OnPress:(MFUILongPressImageView*)imgView
{
    [self.view endEditing:YES];
    
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",@"取消", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"取消", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    image =  [image resizeImageSize:CGSizeMake(120.0f, 120.0f)];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *base64Data = [GTMBase64 encodeData:imageData];
    self.imageStreams = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    _headImageView.image = image;
    
    if (_sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [[MFImageSaveHelper new] saveImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [popCon dismissPopoverAnimated:YES];
    }
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
        else
        {
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
                [popCon presentPopoverFromRect:_headImageView.bounds inView:_headImageView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                
            }];
        }
    }
}

#pragma mark - MFCreateCustomerViewDelegate
- (void)saveCustomerInfo:(MFCreateCustomerView *)imgView info:(id)info
{
    CustomerInfo *customerInfo = (CustomerInfo*)info;
    
    NSString *token = BloomBeautyToken;
    NSDictionary *parameters = @{
                                 @"brandId": customerInfo.brandId,
                                 @"phoneNumber": customerInfo.phoneNumber,
                                 @"token": token
                                 };
    
    [self showMBStatusInViewController:@"正在新建顾客..."];
    
    [MFHTTPUtil POST_ToDict:MFApiQueryCustomerURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BOOL isExist = false;
        NSMutableArray *array = responseObject[@"customerVO"];
        if(array != nil && array.count>0)
        {
            CustomerInfo *jsonObj = [CustomerInfo objectWithKeyValues:array[0]];
            if(jsonObj != nil && [CommonUtil isNotNull:jsonObj.searchKey])
            {
                isExist = true;
                self.customerInfo = jsonObj;
            }
        }
        
        if(isExist)
        {
            [self hiddenMBStatus];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"该用户已经存在,是否查看顾客信息"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }else
        {
            [self postCustomerInfo:customerInfo];
        }
        
    } failureTips:^(NSString *tips) {
        [self showTips:tips];
    }];
 
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self showCustomerInfo:self.customerInfo];
    }
    
    [self initSubViews];
}

-(void)initSubViews
{
    [_headImageView setImage:MFImage(@"zbl31")];
    
    CustomerInfo *customerInfo = [[CustomerInfo alloc]initInfo];
    [_creatCustomView initView:MFCustomerStatusAdd customerInfo:customerInfo];
    
    self.viewStatus = MFCustomerStatusAdd;
    self.imageStreams = @"";

}

- (void)onClickAnalysisBtn:(id)sender
{
    [self initSubViews];
    
    if ([self.delegate respondsToSelector:@selector(jumpToCustomerAnalysis)])
    {
        [self.delegate jumpToCustomerAnalysis];
    }
}

-(void)postCustomerInfo:(CustomerInfo *)info
{
    NSString *userId = @"";
    NSString *regionCode	 = @"";
    NSString *cityCode = @"";
    NSString *email = @"";
    NSString *weChat	 = @"";
    NSString *occupationType = @"";
    NSString *imageStreams = @"";
    
    if(info.userId != nil)
    {
        userId = [info.userId stringValue];
    }
    if(info.regionCode != nil)
    {
        regionCode = info.regionCode;
    }
    if(info.cityCode != nil)
    {
        cityCode = info.cityCode;
    }
    if(info.email != nil)
    {
        email = info.email;
    }
    
    if(info.weChat != nil)
    {
        weChat = info.weChat;
    }
    
    if(info.occupationType != nil)
    {
        occupationType = info.occupationType;
    }
    if(self.imageStreams != nil)
    {
        imageStreams = self.imageStreams;
    }
    
    NSString *token = BloomBeautyToken;
    NSDictionary *parameters = @{
                                 @"brandId": info.brandId,
                                 @"phoneNumber": info.phoneNumber,
                                 @"lastName":info.lastName,
                                 @"firstName":info.firstName,
                                 @"yob":info.yob,
                                 @"mob":info.mob,
                                 @"dob":info.dob,
                                 @"maintainEmployeeId":info.maintainEmployeeId,
                                 @"maintainEntityId":info.maintainEntityId,
                                 @"isLunar":info.isLunar,
                                 @"email":email,
                                 @"weChat":weChat,
                                 @"imageStreams":imageStreams,
                                 @"occupationType":occupationType,
                                 @"userId": userId,
                                 @"regionCode": regionCode,
                                 @"cityCode": cityCode,
                                 @"address": info.address,
                                 @"token": token
                                 };
    [self showMBStatusInViewController:@"正在新建顾客..."];
    
    __weak typeof(self) weakSelf = self;
    [MFHTTPUtil POST_ToDict:MFApiAddCustomerURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = self;
        [strongSelf hiddenMBStatus];
        
        NSString *individualNo = responseObject[@"individualNo"];
        info.individualNo = individualNo;
        if(info.individualNo != nil && info.individualNo > 0)
        {
            [MFLoginCenter sharedCenter].currentCustomerInfo = info;
            
            if([CommonUtil isNotNull:info.portraitUrl])
            {
                UIImage *image = _headImageView.image;
                [[ImageSanBoxUtil sharedUtil] setImageByLoginUser:[info getImgNameByPortraitUpdateDate] image:image];
            }
            
            [strongSelf initSubViews];
            [strongSelf showCustomerInfo:info];
            
        }else
        {
            [CommonUtil showAlert:@"提示" message:@"接口返回数据有问题"];
        }
        
    } failureTips:^(NSString *tips) {
        [weakSelf hiddenMBStatus];
        [CommonUtil showAlert:@"提示" message:tips];
    }];
    
}

- (void)showCustomerInfo:(CustomerInfo *)info
{
    UIStoryboard *storyboard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
    MFCustomerInfoMainViewController *customerInfoController = (MFCustomerInfoMainViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MFCustomerInfoMainViewController"];
    customerInfoController.individualNo = info.individualNo;
    [self.navigationController pushViewController:customerInfoController animated:YES];
}

- (IBAction)saveCustomerInfo:(id)sender
{
    [self.view endEditing:YES];
    
    CustomerInfo *customerInfo = [_creatCustomView getSaveObj];
    if ([CommonUtil isNull:customerInfo.lastName]) {
        [CommonUtil showAlert:@"提示" message:@"姓不能为空"];
        return;
    }
    if ([CommonUtil isNull:customerInfo.firstName]) {
        [CommonUtil showAlert:@"提示" message:@"名不能为空"];
        return;
    }
    if ([CommonUtil isNull:customerInfo.phoneNumber]) {
        [CommonUtil showAlert:@"提示" message:@"手机号不能为空"];
        return;
    }
    if (![CommonUtil checkTel:customerInfo.phoneNumber]) {
        [CommonUtil showAlert:@"提示" message:@"输入手机号格式有误"];
        return;
    }
    
    [self saveCustomerInfo:_creatCustomView info:customerInfo];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
