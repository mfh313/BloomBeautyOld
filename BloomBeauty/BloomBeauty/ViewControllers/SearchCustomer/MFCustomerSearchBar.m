//
//  MFCustomerSearchBar.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerSearchBar.h"

@interface MFCustomerSearchBar () <UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *_inputTextField;
    
    __weak IBOutlet UIButton *_deleteSmallBtn;
    
    __weak IBOutlet UIButton *_bgBtn;
    
    __weak IBOutlet UIButton *_cancelBtn;
    
    __weak IBOutlet UIImageView *_searchIconView;
    
    __weak IBOutlet UILabel *_placeHolderLabel;
}

@end

@implementation MFCustomerSearchBar
@synthesize delegate;
@synthesize cancelBtnAlwaysShow;

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_bgBtn setBackgroundImage:MFImageStretchCenter(@"searchbox") forState:UIControlStateNormal];
    [_deleteSmallBtn setHidden:YES];
    
    [_searchIconView setHidden:NO];
    [_placeHolderLabel setHidden:NO];
    
    [_cancelBtn setTitleColor:BBDefaultColor forState:UIControlStateNormal];
    [_cancelBtn setHidden:YES];

}

- (IBAction)onClickCancelBtn:(id)sender {
    
    [self resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(searchBarOnClickCancelSearch:)]) {
        [self.delegate searchBarOnClickCancelSearch:self];
    }
    
    [_cancelBtn setHidden:YES];
}

- (void)onSearchCustomer {
    
    [_inputTextField resignFirstResponder];
    
     NSString *searchText = [_inputTextField.text copy];
    if ([self.delegate respondsToSelector:@selector(searchBar:searchText:)])
    {
        [self.delegate searchBar:self searchText:searchText];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self onSearchCustomer];
        return NO;
    }
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_deleteSmallBtn setHidden:NO];
    [_cancelBtn setHidden:NO];
    
    if (self.cancelBtnAlwaysShow) {
        [_cancelBtn setHidden:NO];
    }
    
    [_searchIconView setHidden:YES];
    [_placeHolderLabel setHidden:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_deleteSmallBtn setHidden:YES];
    [_cancelBtn setHidden:YES];
    
    if (self.cancelBtnAlwaysShow) {
        [_cancelBtn setHidden:NO];
    }
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
    
    if (!_inputTextField.text || [_inputTextField.text isEqualToString:@""]) {
        [_searchIconView setHidden:NO];
        [_placeHolderLabel setHidden:NO];
    }
    
    return [super resignFirstResponder];
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolderLabel.text = placeHolder;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_inputTextField becomeFirstResponder];
}

- (NSString*)getSearchText
{
    return _inputTextField.text;
}

- (void)setText:(NSString *)text
{
    _inputTextField.text = text;
}

@end
