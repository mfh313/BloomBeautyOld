//
//  MFCustomerBodyMadeInputView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeInputView.h"
#import "MFRoundTextField.h"
#import "MFCustomerBodyMadeLogicController.h"
#import "MFCustomerBodyMadeModel.h"

@interface MFCustomerBodyMadeInputView () <MFRoundTextFieldDelegate,UITextFieldDelegate>
{
    __weak IBOutlet MFUIButton *_bgView;
    __weak IBOutlet UIImageView *_borderImageView;
    __weak IBOutlet MFRoundTextField *_textField;
    __weak IBOutlet UILabel *_unitLabel;
    __weak IBOutlet UILabel *_tipsLabel;
    
    __weak IBOutlet NSLayoutConstraint *_bottomConstraint;
    
    MFCustomerBodyMadeModel *m_bodyMadeItem;
}

@end

@implementation MFCustomerBodyMadeInputView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _borderImageView.image = MFImageStretchCenter(@"zbl36");
    _textField.delegate = self;
    _textField.textFieldDelegate = self;
    [_textField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_textField setReturnKeyType:UIReturnKeyDone];
    
    UITextField *_interlTextField = [_textField inputTextField];
    [_interlTextField setEnablesReturnKeyAutomatically:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupEvents];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [self onClickFinishInput:nil];
        
        return NO;
    }
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect bgFrameInSelf = [_bgView convertRect:_bgView.frame toView:self];
    
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    if (CGRectGetMaxY(bgFrameInSelf) > CGRectGetMinY(keyboardBounds))
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        _bottomConstraint.constant = CGRectGetMinY(keyboardBounds);
        [self layoutIfNeeded];
        
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
    
    _bottomConstraint.constant = (CGRectGetHeight(self.frame) - CGRectGetHeight(_bgView.frame)) / 2;
    
    [self layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)setupEvents
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
    
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
    [self onClickCancelBtn:nil];
}


- (IBAction)onClickCancelBtn:(id)sender {
    [_textField resignFirstResponder];
    if ([self.m_delegate respondsToSelector:@selector(cancelInputBodyMade)]) {
        [self.m_delegate cancelInputBodyMade];
    }
}

- (IBAction)onClickFinishInput:(id)sender {
    
    NSString *inputString = [self inputString];
    
    if ([CommonUtil isNull:inputString]) {
        return;
    }
    
    if ([self.m_delegate respondsToSelector:@selector(onFinishEndEditingBodyMadeModel:string:)]) {
        [self.m_delegate onFinishEndEditingBodyMadeModel:m_bodyMadeItem string:inputString];
    }
}

-(NSString *)inputString
{
    NSString *text = _textField.text;
    
    return text;
}

-(void)setBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem
{
    m_bodyMadeItem = bodyMadeItem;
    
    _tipsLabel.text = bodyMadeItem.remark;
    NSString *string = [MFCustomerBodyMadeHelper bodyMadeValueShowStringWithOutUnit:bodyMadeItem.bodyMadeValue];
    
    [_textField setPlaceHolder:string];
    [_textField setText:string];
    
    _unitLabel.text = bodyMadeItem.unitDesc;
   
}

- (BOOL)resignFirstResponder
{
    [_textField resignFirstResponder];
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [_textField becomeFirstResponder];
    return [super becomeFirstResponder];
}

@end
