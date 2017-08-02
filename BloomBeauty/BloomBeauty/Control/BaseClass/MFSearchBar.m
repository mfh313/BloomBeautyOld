//
//  MFSearchBar.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSearchBar.h"

@interface MFSearchBar () <UITextFieldDelegate>
{
    __weak IBOutlet UIImageView *_searchBackgroundView;
    __weak IBOutlet UITextField *_inputTextField;
    __weak IBOutlet UIButton *_deleteBtn;
    __weak IBOutlet UILabel *_placeHolderLabel;
    __weak IBOutlet UIButton *_cancelBtn;
    
}

@end

@implementation MFSearchBar
@synthesize delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _searchBackgroundView.image = MFImageStretchCenter(@"searchbox");
    [_deleteBtn setHidden:YES];
    [_cancelBtn setHidden:YES];
}

- (void)onClickSearch:(id)sender {
    
    [_inputTextField resignFirstResponder];
    
     NSString *searchText = [_inputTextField.text copy];
    if ([self.delegate respondsToSelector:@selector(searchBar:searchText:)])
    {
        [self.delegate searchBar:self searchText:searchText];
    }
}

- (IBAction)onClickCancelBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        [self.delegate searchBar:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if ([string isEqualToString:@"\n"]) {
        [self onClickSearch:nil];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_deleteBtn setHidden:NO];
    [_placeHolderLabel setHidden:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_deleteBtn setHidden:YES];
    if (!_inputTextField.text || [_inputTextField.text isEqualToString:@""]) {
        [_placeHolderLabel setHidden:NO];
    }
}

- (IBAction)onClickSmallDeleteBtn:(id)sender {
    _inputTextField.text = nil;
}

- (void)clearContent
{
    [self onClickSmallDeleteBtn:nil];
}

-(BOOL)becomeFirstResponder
{
    [_inputTextField becomeFirstResponder];
    [_cancelBtn setHidden:NO];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [_inputTextField resignFirstResponder];
    
    if (!_inputTextField.text || [_inputTextField.text isEqualToString:@""]) {
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

- (NSString*)searchText
{
    return _inputTextField.text;
}


@end
