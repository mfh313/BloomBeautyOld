//
//  MFCustomerCreateViewController.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/4.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerCreateViewController.h"
#import "MFCustomerCreateLogicController.h"
#import "MFCustomerInfoCellView.h"
#import "MFCreateCustomerViewHeader.h"
#import "MFCreateCustomerViewAvatarHeader.h"
#import "MFImageSaveHelper.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "MFAddCustomerApi.h"
#import "MFCustomerInfoMainNewViewController.h"

@interface MFCustomerCreateViewController ()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFCustomerInfoCellViewDelegate,MFLongPressImageViewDelegate,WCActionSheetDelegate>
{
    __weak IBOutlet UICollectionView *_customerInfoView;
    NSMutableArray *_requiredArray;
    NSMutableArray *_optionalArray;
    MFCustomerCreateLogicController *m_logic;
    
    MFUILongPressImageView *_headImageView;
    
    NSString *_avatarImageData;
    UIImage *_avatarImage;
    
    NSMutableDictionary *_tempCreateInfo;
    NSString *_showIndividualNo;
}

@end

@implementation MFCustomerCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建顾客";
    
    [_customerInfoView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    _customerInfoView.backgroundColor = [UIColor whiteColor];
    
    [_customerInfoView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFCustomerCreateViewController"];
    [_customerInfoView registerClass:[MFUICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCreateCustomerSectionHeaderView"];
    [_customerInfoView registerClass:[MFUICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCreateCustomerViewAvatarHeader"];
    
    m_logic = [MFCustomerCreateLogicController new];
    _requiredArray = [m_logic editRequiredCustomerInfoModel];
    _optionalArray = [m_logic editOptionalCustomerInfoModel];
}

-(void)reInitSubView
{
    _headImageView = nil;
    _avatarImageData = nil;
    _avatarImage = nil;
    
    [_requiredArray removeAllObjects];
    [_optionalArray removeAllObjects];
    _requiredArray = [m_logic editRequiredCustomerInfoModel];
    _optionalArray = [m_logic editOptionalCustomerInfoModel];
    
    [_customerInfoView reloadData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view.window endEditing:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return _requiredArray.count;
    }
    else if (section == 2)
    {
        return _optionalArray.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *identifier = @"MFCustomerCreateViewController";
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFCustomerInfoCellView *cellView = [MFCustomerInfoCellView viewWithNib];
        cellView.m_delegate = self;
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFCustomerInfoShowObject *infoObject = nil;
    if (indexPath.section == 1) {
        infoObject = _requiredArray[indexPath.row];
    }
    else if (indexPath.section == 2)
    {
        infoObject = _optionalArray[indexPath.row];
    }
    
    MFCustomerInfoCellView *cellView = (MFCustomerInfoCellView *)cell.m_subContentView;
    cellView.superScrollView = collectionView;
    
    [cellView setCustomerInfoShowObject:infoObject];
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(collectionView.bounds) - 120 -  40) / 2, 36);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 66, 0, 66);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        if (indexPath.section == 0)
        {
            MFUICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCreateCustomerViewAvatarHeader" forIndexPath:indexPath];
            
            if (headerView.m_subContentView == nil) {
                MFCreateCustomerViewAvatarHeader *header = [MFCreateCustomerViewAvatarHeader viewWithNib];
                header.frame = headerView.bounds;
                headerView.m_subContentView = header;
            }
            
            headerView.m_subContentView.frame = headerView.bounds;
            
            MFCreateCustomerViewAvatarHeader *header = (MFCreateCustomerViewAvatarHeader *)headerView.m_subContentView;
            _headImageView = header.avatarCreateView;
            _headImageView.delegate = self;
            if (_avatarImage) {
                _headImageView.image = _avatarImage;
            }
            
            reusableview = headerView;
            return reusableview;
        }
        
        MFUICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCreateCustomerSectionHeaderView" forIndexPath:indexPath];
        
        if (headerView.m_subContentView == nil) {
            MFCreateCustomerViewHeader *header = [MFCreateCustomerViewHeader viewWithNib];
            header.frame = headerView.bounds;
            headerView.m_subContentView = header;
        }
        
        headerView.m_subContentView.frame = headerView.bounds;
        
        MFCreateCustomerViewHeader *header = (MFCreateCustomerViewHeader *)headerView.m_subContentView;
        if (indexPath.section == 1)
        {
            [header setRequiredType:YES];
        }
        else if (indexPath.section == 2)
        {
            [header setRequiredType:NO];
        }

        reusableview = headerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 150);
    }
    else if (section == 1)
    {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 72);
    }
    else if (section == 2)
    {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 56);
    }
    
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - MFLongPressImageViewDelegate
- (void)OnPress:(MFUILongPressImageView*)imgView
{
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
        
        CGRect sourceRect = [_customerInfoView convertRect:_headImageView.frame toView:self.view];
        
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
    _avatarImageData = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    _avatarImage = image;
    _headImageView.image = _avatarImage;
    
    [[MFImageSaveHelper new] saveImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

+(BOOL)hasCameraAuthor
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status != AVAuthorizationStatusAuthorized) {
        return NO;
    }
    
    return YES;

}

+ (BOOL)hasPhotoAlbumAuthor
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusAuthorized)
    {
        return YES;
    }
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

-(void)onClickSaveCustomerInfo
{
    NSMutableDictionary *creatInfo = [NSMutableDictionary dictionary];
    NSMutableArray *infoArray = [NSMutableArray arrayWithArray:_requiredArray];
    [infoArray addObjectsFromArray:_optionalArray];
    
    for (int i = 0; i < infoArray.count; i++) {
        MFCustomerInfoShowObject *infoObject = infoArray[i];
        
        NSMutableDictionary *valueInfo = infoObject.valueInfo;
        for (int j = 0; j < valueInfo.allKeys.count; j++) {
            NSString *key = valueInfo.allKeys[j];
            [creatInfo setObject:valueInfo[key] forKey:key];
        }
    }
    
    NSArray *apiRequiredkeyArray = @[@"lastName",@"firstName",@"phoneNumber",@"sex",@"birthDay",@"regionCity",@"occupationType",@"oftenEnterOccation",@"oftenAccompanyPerson",@"customerMentality"];
    NSArray *requiredDescArray = @[@"姓不能为空",@"名不能为空",@"手机号码不能为空",@"请选择性别",@"请填写生日信息",@"请选择常住地区",@"请选择职业",@"请选择常出入场合",@"请选择常购物同伴",@"请选择购买心理"];
    
    for (int i = 0; i < apiRequiredkeyArray.count; i++) {
        NSString *key = apiRequiredkeyArray[i];
        NSString *errorTips = requiredDescArray[i];
        
        if ([key isEqualToString:@"birthDay"]) {
            if (creatInfo[@"yob"] && creatInfo[@"mob"] && creatInfo[@"dob"] && creatInfo[@"isLunar"]) {
                continue;
            }
            
            [self showTips:errorTips];
            return;
        }
        else if ([key isEqualToString:@"regionCity"])
        {
            if (creatInfo[@"regionCode"]) {
                continue;
            }
            
            [self showTips:errorTips];
            return;
        }
        else if (!creatInfo[key])
        {
            [self showTips:errorTips];
            return;
        }
    }
    
    [creatInfo setObject:[MFLoginCenter sharedCenter].loginInfo.userId forKey:@"userId"];
    if (_avatarImageData) {
        [creatInfo setObject:_avatarImageData forKey:@"imageStreams"];
    }
    
    [self postCustomerInfo:creatInfo];
}

-(void)postCustomerInfo:(NSMutableDictionary *)createInfo
{
    [self showMBStatusInViewController:@"正在新建顾客..."];
    __weak __typeof(self) weakSelf = self;
    
    MFAddCustomerApi *createApi = [MFAddCustomerApi new];
    createApi.creatInfo = createInfo;
    [createApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
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
        
        _showIndividualNo = responseObject[@"individualNo"];
        if ([_showIndividualNo isKindOfClass:[NSNull class]]) {
            [CommonUtil showAlert:@"错误" message:@"顾客编码返回为空"];
            return;
        }
        
        NSString *customerFlag = responseObject[@"customerFlag"];;
        if ([customerFlag isKindOfClass:[NSString class]] && [customerFlag isEqualToString:@"Y"]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"该用户已经存在,是否查看顾客信息"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        
        [weakSelf showCustomerInfo:_showIndividualNo];
        [weakSelf reInitSubView];
 
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [weakSelf hiddenMBStatus];
        NSError *error = request.error;
        NSString *desc = [error localizedDescription];
        desc = [NSString stringWithFormat:@"错误描述：%@\n错误码：%@",desc,@(error.code)];
        [CommonUtil showAlert:@"网络开了小差,请重新提交" message:desc];
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self showCustomerInfo:_showIndividualNo];
    }
    
    [self reInitSubView];
}

- (void)showCustomerInfo:(NSString *)individualNo
{
    UIStoryboard *storyboard = MFStoryBoard(@"BloomBeauty_CustomerInfo");
    MFCustomerInfoMainNewViewController *customerInfoController = (MFCustomerInfoMainNewViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MFCustomerInfoMainNewViewController"];
    customerInfoController.individualNo = individualNo;
    [self.navigationController pushViewController:customerInfoController animated:YES];
}

- (IBAction)onClickDoneButton:(id)sender {
    [self onClickSaveCustomerInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
