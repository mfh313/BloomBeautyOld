//
//  MFCustomerDiagnosticReportItemBtn.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/5.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticReportItemBtn.h"

@implementation MFCustomerDiagnosticReportItemBtn

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundImage:MFImageStretchCenter(@"border_btn") forState:UIControlStateNormal];
    [self setBackgroundImage:MFImageStretchCenter(@"color") forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}


@end
