//
//  MFCustomerInfoCoverSelectCellView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/6.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoCoverSelectCellView.h"

@interface MFCustomerInfoCoverSelectCellView ()
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIButton *_checkView;
}

@end

@implementation MFCustomerInfoCoverSelectCellView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_checkView setHidden:YES];
    _checkView.userInteractionEnabled = NO;
}

-(void)setTitle:(NSString *)title selected:(BOOL)isSelected
{
    _titleLabel.text = title;
    if (isSelected) {
        [_checkView setHidden:NO];
    }
    else
    {
        [_checkView setHidden:YES];
    }
}

@end
