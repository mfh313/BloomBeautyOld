//
//  MFCustomerInfoMainRightTitleNavView.m
//  BloomBeauty
//
//  Created by EEKA on 16/7/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerInfoMainRightTitleNavView.h"

@interface MFCustomerInfoMainRightTitleNavView ()
{
    __weak IBOutlet UIButton *_editBtn;
    __weak IBOutlet UIButton *_diagnosticBtn;
}

@end


@implementation MFCustomerInfoMainRightTitleNavView

-(void)setEditBtnHide:(BOOL)hidden
{
    [_editBtn setHidden:hidden];
}

-(void)setDiagnosticBtnHide:(BOOL)hidden
{
    [_diagnosticBtn setHidden:hidden];
}

-(void)setEditBtnTitle:(NSString *)title
{
    [_editBtn setTitle:title forState:UIControlStateNormal];
}

-(void)setEditBtnTitleColor:(UIColor *)titleColor
{
    [_editBtn setTitleColor:titleColor forState:UIControlStateNormal];
}

- (IBAction)onClickEditCustomerInfo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onClickEditCustomer)]) {
        [self.delegate onClickEditCustomer];
    }
}

- (IBAction)onClickDiagnostic:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onClickDiagnosticCustomer)]) {
        [self.delegate onClickDiagnosticCustomer];
    }
}


@end
