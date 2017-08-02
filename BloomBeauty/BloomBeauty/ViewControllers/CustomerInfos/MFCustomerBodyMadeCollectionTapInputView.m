//
//  MFCustomerBodyMadeCollectionTapInputView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeCollectionTapInputView.h"

@interface MFCustomerBodyMadeCollectionTapInputView ()<UITextFieldDelegate>
{
    __weak IBOutlet UIView *_inputView;
    __weak IBOutlet UITextField *_inputTextField;
    __weak IBOutlet UILabel *_unitLabel;
    __weak IBOutlet UILabel *_valueLabel;
}

@end

@implementation MFCustomerBodyMadeCollectionTapInputView
@synthesize m_delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [_inputView setHidden:NO];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapInputBgView)];
    [_inputView addGestureRecognizer:tapGes];
    
    [_inputTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_inputTextField setReturnKeyType:UIReturnKeyDone];
    [_inputTextField setEnablesReturnKeyAutomatically:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(UITextField *)containTextField
{
    return _inputTextField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.m_delegate respondsToSelector:@selector(textFieldDidEndEditing:tapView:)]) {
        [self.m_delegate textFieldDidEndEditing:textField tapView:self];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [_inputTextField resignFirstResponder];
        return NO;
    }
    
    if ([self.m_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:tapView:)]) {
        return [self.m_delegate textField:textField shouldChangeCharactersInRange:range replacementString:string tapView:self];
    }
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (!_inputTextField.isFirstResponder) {
        return;
    }
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect textFieldFrameInWindow= [_inputTextField convertRect:_inputTextField.frame toView:MFAppWindow];
    
    keyboardBounds = [MFAppWindow convertRect:keyboardBounds toView:MFAppWindow];
    
    if (CGRectGetMaxY(textFieldFrameInWindow) > CGRectGetMinY(keyboardBounds))
    {
        CGFloat yOffset = CGRectGetHeight(keyboardBounds);
        if ([self.m_delegate respondsToSelector:@selector(onKeyBoardWillShow:curve:needOffet:)]) {
            [self.m_delegate onKeyBoardWillShow:duration curve:curve needOffet:yOffset];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (!_inputTextField.isFirstResponder) {
        return;
    }
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [MFAppWindow convertRect:keyboardBounds toView:MFAppWindow];
    
    if ([self.m_delegate respondsToSelector:@selector(onKeyBoardWillHide:curve:keyboardEndFrame:)]) {
        [self.m_delegate onKeyBoardWillHide:duration curve:curve keyboardEndFrame:keyboardBounds];
    }
}

-(void)onTapInputBgView
{
    [self onTapBeginEditing];
}

-(void)setInputViewValue:(NSString *)value unit:(NSString *)unit
{
    [_inputView setHidden:NO];
    [_valueLabel setHidden:YES];
    
    _inputTextField.text = value;
    _unitLabel.text = unit;
}

-(void)setValueString:(NSString *)value
{
    [_inputView setHidden:YES];
    [_valueLabel setHidden:NO];
    
    _valueLabel.text = value;
}

-(void)onTapBeginEditing
{
    [_inputTextField becomeFirstResponder];
}

@end
