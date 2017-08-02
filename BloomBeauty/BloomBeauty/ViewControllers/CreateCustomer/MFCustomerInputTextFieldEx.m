//
//  MFCustomerInputTextFieldEx.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/5.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInputTextFieldEx.h"

@interface MFCustomerInputTextFieldEx () <UITextFieldDelegate>
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_descLabel;
    __weak IBOutlet UILabel *_placeHolderLabel;
    __weak IBOutlet UITextField *_inputTextField;
    __weak IBOutlet UIView *_birthdayView;
    __weak IBOutlet MFSwitch *_birthDaySwith;
    __weak IBOutlet UILabel *_birthDayLabel;
    
}

@end

@implementation MFCustomerInputTextFieldEx

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _inputTextField.delegate = self;
    [_inputTextField setHidden:YES];
    [_placeHolderLabel setHidden:YES];
    
    [_birthdayView setHidden:YES];
    
    [self initBirthdayView];
    [_birthdayView setHidden:YES];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEditing)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGes];
    
    UITapGestureRecognizer *birthDayLabelGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEditing)];
    _birthDayLabel.userInteractionEnabled = YES;
    [_birthDayLabel addGestureRecognizer:birthDayLabelGes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextFieldDelegate begin
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_placeHolderLabel setHidden:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.m_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.m_delegate textFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.m_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.m_delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
#pragma mark - UITextFieldDelegate end

-(void)initBirthdayView
{
    _birthDaySwith.style = ZJSwitchStyleBorder;
    _birthDaySwith.onTintColor = BBDefaultColor;
    _birthDaySwith.tintColor = BBDefaultColor;
    _birthDaySwith.thumbTintColor = [UIColor whiteColor];
    _birthDaySwith.onText = @"公历";
    _birthDaySwith.offText = @"农历";
    _birthDayLabel.text = @"1980-01-01";
    [_birthDaySwith addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    
    [_birthDaySwith setOn:YES];
}

- (void)handleSwitchEvent:(MFSwitch *)sender
{
    BOOL isOn = [sender isOn];
    [self.window endEditing:YES];
    
    if ([self.m_delegate respondsToSelector:@selector(onDidSelectIsLunar:)]) {
        [self.m_delegate onDidSelectIsLunar:isOn];
    }
}

-(void)setBirthDayView:(NSString *)dateDesc IsLunar:(BOOL)isLunar
{
    _birthDayLabel.text = dateDesc;
    [_birthDaySwith setOn:isLunar];
}

-(void)setTitle:(NSString *)title desc:(NSString *)desc
{
    [self setTitle:title];
    [self setContentDesc:desc];
}

-(void)setPlaceHolder:(NSString *)placeHolder hidden:(BOOL)hidden
{
    [_placeHolderLabel setHidden:hidden];
    _placeHolderLabel.text = placeHolder;
}

-(void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

-(void)setContentDesc:(NSString *)desc
{
    _descLabel.text = desc;
    _inputTextField.text = desc;
}

-(void)setInputTextField:(MFCustomerInfoShowType)type
{
    _inputTextField.keyboardType = UIKeyboardTypeDefault;
}

-(void)setShowType:(MFCustomerInfoShowType)type editing:(BOOL)editing canEdit:(BOOL)canEdit
{
    [_descLabel setHidden:YES];
    [_placeHolderLabel setHidden:YES];
    [_inputTextField setHidden:YES];
    [_birthdayView setHidden:YES];
    
    [self setInputTextField:type];
    
    switch (type) {
        case CustomerInfoTypeBirthDay:
        {
            if (editing) {
                [_birthdayView setHidden:NO];
            }
            else
            {
                [_descLabel setHidden:NO];
            }
            
        }
            break;
        case CustomerInfoTypeDefault:
        {
            if (editing) {
                [_inputTextField setHidden:NO];
                
                if (!canEdit) {
                    [_inputTextField setHidden:YES];
                    [_descLabel setHidden:NO];
                }
            }
            else
            {
                [_descLabel setHidden:NO];
            }
        }
            break;
            
        default:
        {
            [_descLabel setHidden:NO];
            if (!canEdit) {
                [_inputTextField setHidden:YES];
                [_descLabel setHidden:NO];
            }
        }
            
            break;
    }
}

-(void)onTapEditing
{
    if ([self.m_delegate respondsToSelector:@selector(onTapEditing)]) {
        [self.m_delegate onTapEditing];
    }
}

-(void)onClickInputingShowType:(MFCustomerInfoShowType)type
{
    [_placeHolderLabel setHidden:YES];
    
    switch (type) {
        case CustomerInfoTypeDefault:
        {
            [_inputTextField becomeFirstResponder];
        }
            break;
        case CustomerInfoTypeBirthDay:
        case CustomerInfoTypeProvincesCities:
        case CustomerInfoTypeCoverSelect:
        {
            [self.window endEditing:YES];
            [self showCoverSelectView];
        }
            break;
            
        default:
        {
            [self.window endEditing:YES];
        }
            
            break;
    }

}

-(void)showCoverSelectView
{
    if ([self.m_delegate respondsToSelector:@selector(showCoverSelectView)]) {
        [self.m_delegate showCoverSelectView];
    }
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
        CGFloat yOffset = CGRectGetMinY(keyboardBounds) - CGRectGetMaxY(textFieldFrameInWindow);
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

-(NSString *)text
{
    return _inputTextField.text;
}

-(UITextField *)containTextField
{
    return _inputTextField;
}

@end
