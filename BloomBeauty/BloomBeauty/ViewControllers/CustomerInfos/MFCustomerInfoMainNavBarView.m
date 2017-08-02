//
//  MFCustomerInfoMainNavBarView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/3.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoMainNavBarView.h"

@interface MFCustomerInfoMainNavBarView ()
{
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UIButton *_editButton;
    
    __weak IBOutlet UIButton *_diagnosisButton;
}

@end

@implementation MFCustomerInfoMainNavBarView

-(void)setNavBarTitle:(NSString *)title
{
    _titleLabel.text = title;
}

-(void)setDiagnosisButton:(BOOL)hidden
{
    [_diagnosisButton setHidden:hidden];
}

-(void)setEditButtonTitle:(NSString *)title
{
    [_editButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)onClickEditBtn:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickEditCustomer)]) {
        [self.m_delegate onClickEditCustomer];
    }
}

- (IBAction)onClickDiagnosisBtn:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickDiagnosticCustomer)]) {
        [self.m_delegate onClickDiagnosticCustomer];
    }
}


- (IBAction)onClickBackBtn:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickBackBtn)]) {
        [self.m_delegate onClickBackBtn];
    }
}


@end
