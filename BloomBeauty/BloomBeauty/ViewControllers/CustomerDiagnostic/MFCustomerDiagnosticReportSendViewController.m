//
//  MFCustomerDiagnosticReportSendViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/18.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticReportSendViewController.h"
#import "MFDiagnosticReportSendWindow.h"
#import "MFCustomerDiagnosticReportEmailSendViewController.h"
#import "MFCustomerDiagnosticReportItemBtn.h"

@interface MFCustomerDiagnosticReportSendViewController ()<MFCustomerDiagnosticReportEmailSendDelegate>
{
    __weak IBOutlet UIImageView *_QRImageView;
    UIImage *_QRImage;
    
    __weak IBOutlet UILabel *_tipsLabel;
    
    MFDiagnosticReportSendWindow *_emailSendWindow;
    NSString *_customerDiagnosticUrlStr;
    __weak IBOutlet MFCustomerDiagnosticReportItemBtn *_mailSendBtn;
    __weak IBOutlet MFCustomerDiagnosticReportItemBtn *_weChatShareBtn;
    __weak IBOutlet MFCustomerDiagnosticReportItemBtn *_diagnosticBtn;
}

@end


@implementation MFCustomerDiagnosticReportSendViewController
@synthesize diagnosticReportCustomerInfo,diagnosisResultId;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self MF_wantsFullScreenLayout:NO];
    
    _tipsLabel.textColor = MFDarkTextColor;
    
    [_mailSendBtn setImage:MFImage(@"Mail_w") forState:UIControlStateHighlighted];
    [_weChatShareBtn setImage:MFImage(@"sent_w") forState:UIControlStateHighlighted];
    [_diagnosticBtn setImage:MFImage(@"Eyebtn_w") forState:UIControlStateHighlighted];
    
    _customerDiagnosticUrlStr = [diagnosisResultId customerDiagnosticUrlString];
    _QRImage = [LBXScanWrapper createQRWithString:_customerDiagnosticUrlStr size:_QRImageView.bounds.size];
    _QRImageView.image = _QRImage;
    
    [_QRImageView addMF_LongPressGesture];
    [_QRImageView setMF_LongPressGestureTitles:@[@"长按分享诊断报告"]
                                  object:self
                                SELArray:@[NSStringFromSelector(@selector(onClickWeiChatSend:))]];
}

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

- (IBAction)onClickWeiChatSend:(id)sender
{
    if (![MFWeiChatShareManger isWXAppInstalled])
    {
        return;
    }
    
    NSString *individualName = [self.diagnosticReportCustomerInfo getFullName];
    NSString *title = [NSString stringWithFormat:@"%@的诊断报告",individualName];
    
    [[MFWeiChatShareManger sharedManager] sendLinkContentToWeiChat:_customerDiagnosticUrlStr
                                                             Title:title
                                                       Description:@"诊断报告"
                                                    WithShareScene:WeiChatShareSession];
}

- (IBAction)onClickEmailSend:(id)sender
{
    NSString *receiptAddress = self.diagnosticReportCustomerInfo.email;
    MFCustomerDiagnosticReportEmailSendViewController *emailSendVC = [BBCreateStoryBoard instantiateViewControllerWithIdentifier:@"MFCustomerDiagnosticReportEmailSendViewController"];
    emailSendVC.delegate = self;
    emailSendVC.emailAddress = receiptAddress;
    emailSendVC.view.backgroundColor = [UIColor hx_colorWithHexString:@"#000" alpha:0.7];
    
    if (!_emailSendWindow) {
        _emailSendWindow = [MFDiagnosticReportSendWindow new];
    }
    
    _emailSendWindow.frame = MFAppWindow.bounds;
    _emailSendWindow.windowLevel = UIWindowLevelNormal + 1;
    _emailSendWindow.backgroundColor = [UIColor clearColor];
    _emailSendWindow.rootViewController = emailSendVC;
    _emailSendWindow.hidden = NO;
    
}

- (IBAction)onClickDiagnosticAgain:(id)sender {
    [[CKRadialMenuManager sharedManager]hiddenMenu];
    [[MFLoginCenter sharedCenter] setCurrentCustomerInfo:self.diagnosticReportCustomerInfo];
    [[MFAppViewControllerManager sharedManager] jumpToCustomerAnalysis];
}


-(void)onClickDismissWindow
{
    [_emailSendWindow endEditing:YES];
    _emailSendWindow.hidden = YES;
}

-(void)onClickDiagnosticReportEmailSend:(NSString *)emailAddress
{
    if ([CommonUtil isNull: emailAddress]) {
        [_emailSendWindow endEditing:YES];
        [self showTipsByWindow:@"请输入邮箱地址" withDuration:1.0 window:_emailSendWindow];
        return;
    }
    
    if (![CommonUtil validateEmail:emailAddress]) {
        [_emailSendWindow endEditing:YES];
        [self showTipsByWindow:@"请输入正确的邮箱地址" withDuration:1.0 window:_emailSendWindow];
        return;
    }
    
    [self onClickDismissWindow];
    [self sendEmail:emailAddress];
    
}

-(void)sendEmail:(NSString *)receiptAddress
{
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    NSNumber *brandID = self.diagnosticReportCustomerInfo.brandId;
    NSString *entityName = [MFLoginCenter sharedCenter].loginInfo.entityName;
    NSString *individualName = [self.diagnosticReportCustomerInfo getFullName];
    NSURL *customerDiagnosticUrl = [diagnosisResultId customerDiagnosticUrl];
    NSString *content = [NSString stringWithFormat:@"点击如下链接查看诊断报告：\n%@",customerDiagnosticUrl];
    
    if (!receiptAddress || !brandID || !entityName || !individualName) {
        return;
    }
    
    NSDictionary *parameters = @{@"receipt": receiptAddress,
                                 @"brandId": brandID,
                                 @"entityName": entityName,
                                 @"individualName": individualName,
                                 @"content": content,
                                 @"token": token
                                 };
    __weak typeof(self) weakSelf = self;
    [MFNetwork postWithUrl:MFApiDiagnosisReportSendEmailURL
                    params:parameters
                   success:^(id response) {
        
       NSString *statusCode = response[@"statusCode"];
       if ([statusCode isEqualToString:@"200"])
       {
           dispatch_main_async_safe(^{
               [weakSelf showTips:@"邮件发送成功"];
           });
           
       }
       else
       {
           dispatch_main_async_safe(^{
               [weakSelf showTips:@"邮件发送失败"];
           });
       }
           
    } fail:^(NSError *error) {
        dispatch_main_async_safe(^{
            [weakSelf showTips:@"邮件发送失败"];
        });
    }];
    
//    [MFHTTPUtil POST:MFApiDiagnosisReportSendEmailURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSString *statusCode = responseObject[@"statusCode"];
//         if ([statusCode isEqualToString:@"200"])
//         {
//             dispatch_main_async_safe(^{
//                 [CommonUtil showAlert:@"提示" message:@"邮件发送成功"];
//             });
//             
//         }
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         [CommonUtil showAlert:@"提示" message:@"邮件发送失败"];
//     }];
}

@end
