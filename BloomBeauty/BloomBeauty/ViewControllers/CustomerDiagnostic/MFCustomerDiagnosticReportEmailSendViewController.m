//
//  MFCustomerDiagnosticReportEmailSendViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/22.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticReportEmailSendViewController.h"
#import "MFRoundTextField.h"

@interface MFCustomerDiagnosticReportEmailSendViewController ()<MFRoundTextFieldDelegate>
{

    __weak IBOutlet UIImageView *_bgImageView;
    
    
    __weak IBOutlet MFRoundTextField *_textField;
}

@end

@implementation MFCustomerDiagnosticReportEmailSendViewController
@synthesize delegate,emailAddress;

- (void)viewDidLoad {
    [super viewDidLoad];
    _bgImageView.image = MFImageStretchCenter(@"zbl36");
    _textField.delegate = self;
    [_textField setReturnKeyType:UIReturnKeyDone];
    if ([CommonUtil isNull:self.emailAddress]) {
        [_textField setPlaceHolder:@"请输入邮箱地址"];
        [_textField becomeFirstResponder];
    }
    else
    {
        [_textField setPlaceHolder:self.emailAddress];
        [_textField setText:self.emailAddress];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self onClickCancelBtn:nil];
}

- (IBAction)onClickCancelBtn:(id)sender {
    [self.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(onClickDismissWindow)]) {
        [self.delegate onClickDismissWindow];
    }
}

- (IBAction)onClickSendEmail:(id)sender {
    NSString *text = _textField.text;
    if (!text) {
        text = self.emailAddress;
    }
    
    if ([self.delegate respondsToSelector:@selector(onClickDiagnosticReportEmailSend:)]) {
        [self.delegate onClickDiagnosticReportEmailSend:text];
    }
}

-(void)onClickKeyBoardDone
{
    [self onClickSendEmail:nil];
}

-(void)onCLickKeyBoardClearBtn
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
