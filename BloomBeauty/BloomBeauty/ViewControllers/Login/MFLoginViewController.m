//
//  MFLoginViewController.m
//  装扮灵
//
//  Created by Administrator on 15/10/18.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFLoginViewController.h"
#import "MFLoginInputView.h"
#import "MFLoginCenter.h"
#import "UpgradeInfo.h"
#import "UpgradeInfoUtil.h"
#import "MFBrandInfo.h"
#import "MFCustomerInfoManager.h"

@interface MFLoginViewController () <MFLoginInputViewDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIButton *loginBtn;
    
    __weak IBOutlet UIView *_loginContentView;
    
    __weak IBOutlet MFLoginInputView *_inputView;
    __weak IBOutlet UIButton *_iconBtn;
    
    CGRect _loginContentViewFrame;
    __weak IBOutlet NSLayoutConstraint *_newLayout;
}

@end

@implementation MFLoginViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inputView.mSuperView = self.view;
    _inputView.delegate = self;
    
    [loginBtn setBackgroundImage:MFImageStretchCenter(@"tittle2") forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[UpgradeInfoUtil sharedUtil] checkUpgradeInfo:^(UpgradeInfo *info) {
        
        if(info.isNeedUprade == true)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新版本"
                                                            message:info.upgradeDesc
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
        }
    }];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
#ifdef DEBUG
    
#else
    _inputView.name = [[NSUserDefaults standardUserDefaults] valueForKey:LoginNamekey];
#endif
    
    [_inputView checkLoginBtnStatus];
    
}

#pragma mark - MFLoginInputViewDelegate
-(void)inputViewHasNamePassWord:(BOOL)has
{
    [loginBtn setEnabled:has];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect loginBtnFrameInSelf = [loginBtn convertRect:loginBtn.frame toView:self.view];
    CGRect contentViewFrameInSelf = [_loginContentView convertRect:_loginContentView.frame toView:self.view];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    if (CGRectGetMaxY(loginBtnFrameInSelf) > CGRectGetMinY(keyboardBounds))
    {
        _loginContentViewFrame = contentViewFrameInSelf;
        
        CGFloat y = CGRectGetMaxY(contentViewFrameInSelf) - CGRectGetMinY(keyboardBounds);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        _newLayout.constant = CGRectGetMinY(contentViewFrameInSelf) - y - 10 - 20;
        [self.view layoutIfNeeded];
        
        [UIView commitAnimations];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    _newLayout.constant = 47;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (IBAction)clickLoginBtn:(id)sender
{
    [self.view endEditing:YES];
    
#ifdef DEBUG
    
#else
    NSString *name = [_inputView.name copy];
    NSString *password = [_inputView.password copy];
    
    if([CommonUtil isNull:name])
    {
        [self showTips:@"请输入用户名"];
        return;
    }
    if([CommonUtil isNull:password])
    {
        [self showTips:@"请输入密码"];
        return;
    }
#endif
    
    __weak typeof(self) weakSelf = self;
    
    [self showMBStatusInViewController:@"正在登录..." withDuration:10];
    [[UpgradeInfoUtil sharedUtil] checkUpgradeInfo:^(UpgradeInfo *info) {
        
        if (!info)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"当前未获取更新信息"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
            [self hiddenMBStatus];
            return;
        }
        
        BOOL isUpdated = NO;
        
        if([info.version isEqualToString:[UpgradeInfoUtil getNowStrVersion]])
        {
            isUpdated = true;
        }
        
        if([info.forcedUpgrade isEqualToString:@"Y"])
        {
            if(isUpdated == false)
            {
                NSString *message = [NSString stringWithFormat:@"当前版本为%@与服务器版本%@不一致",[UpgradeInfoUtil getNowStrVersion],info.version];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本不一致"
                                                                message:message
                                                               delegate:weakSelf
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定",nil];
                [alert show];
                [self hiddenMBStatus];
                return ;
            }
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf startLoginService];
        
    }];
}

-(void)startLoginService
{
    NSString *name = [_inputView.name copy];
    NSString *password = [_inputView.password copy];
    
    __weak typeof(self) weakSelf = self;
    [[MFLoginCenter sharedCenter] loginWith:name password:password Block:^(NSString *statusCode, NSString *message, BOOL success)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf hiddenMBStatus];
         if (success)
         {
             NSLog(@"[MFLoginCenter sharedCenter].loginInfo.userName: %@", [MFLoginCenter sharedCenter].loginInfo.userName);
             
             [MFCustomerInfoManager sharedManager];
             
             if ([strongSelf.delegate respondsToSelector:@selector(didLoginSuccess)]) {
                 [strongSelf.delegate didLoginSuccess];
             }
             
             [[MFDatabaseUtil sharedManager] initDatabase:[MFLoginCenter sharedCenter].loginInfo.userId.stringValue];
             [[UserDao sharedManager]insertOrUpdate:[MFLoginCenter sharedCenter].loginInfo];
         }
         else
         {
             [_inputView shakeAnimation];
             [strongSelf showTips:message];
         }
         
     }];
}

- (IBAction)clickForgetPassword:(id)sender {
    
}

- (IBAction)clickCheckNewVersion:(id)sender
{
    [[UpgradeInfoUtil sharedUtil] checkUpgradeInfo:^(UpgradeInfo *info) {
        
        if(info.isNeedUprade == true)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新版本"
                                                            message:info.upgradeDesc
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"当前版本是最新版本"];
            [self showTipsByWindow:message withDuration:1 window:MFAppWindow];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UpgradeInfo *upgradeInfo = [[UpgradeInfoUtil sharedUtil] upgradeInfo];
        if(upgradeInfo != nil)
        {
            NSMutableDictionary *systemPlist = [PlistUtil find:PLIST_SYSTEM_DIR fileName:PLIST_SYSTEM_FILE_NAME] ;
            [systemPlist setObject:upgradeInfo.version forKey:PLIST_SYSTEM_KEY_VERSION];
            [PlistUtil update:PLIST_SYSTEM_DIR fileName:PLIST_SYSTEM_FILE_NAME dict:systemPlist];
            
            NSURL *url = [NSURL URLWithString:upgradeInfo.lastUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
