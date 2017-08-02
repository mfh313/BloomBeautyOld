//
//  MFRoundTextField.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFRoundTextField.h"

@interface MFRoundTextField () <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *_inputTextField;
    
    __weak IBOutlet UIButton *_deleteSmallBtn;
    
    __weak IBOutlet UIButton *_bgBtn;
    
}

@end

@implementation MFRoundTextField
@synthesize delegate,text;

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_bgBtn setBackgroundImage:MFImageStretchCenter(@"search") forState:UIControlStateNormal];
    [_deleteSmallBtn setHidden:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.textFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.textFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if ([string isEqualToString:@"\n"]) {
        
        if ([self.delegate respondsToSelector:@selector(onClickKeyBoardDone)]) {
            [self.delegate onClickKeyBoardDone];
        }
        
        return NO;
    }
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     [_deleteSmallBtn setHidden:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_deleteSmallBtn setHidden:YES];
}

- (IBAction)onClickSmallDeleteBtn:(id)sender {
    _inputTextField.text = nil;
}

- (void)clearContent
{
    [self onClickSmallDeleteBtn:nil];
}

- (BOOL)resignFirstResponder
{
    [_inputTextField resignFirstResponder];
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [_inputTextField becomeFirstResponder];
    return [super becomeFirstResponder];
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _inputTextField.placeholder = placeHolder;
}

-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _inputTextField.returnKeyType = returnKeyType;
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _inputTextField.keyboardType = keyboardType;
}

- (void)setText:(NSString *)atext
{
    _inputTextField.text = atext;
}

-(NSString *)text
{
    return _inputTextField.text;
}

-(UITextField *)inputTextField
{
    return _inputTextField;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_inputTextField becomeFirstResponder];
}


@end
