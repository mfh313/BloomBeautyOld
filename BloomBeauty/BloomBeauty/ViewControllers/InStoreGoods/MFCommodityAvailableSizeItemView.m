//
//  MFCommodityAvailableSizeItemView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCommodityAvailableSizeItemView.h"


@interface MFCommodityAvailableSizeItemView ()
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_sizeLabel;
    __weak IBOutlet UILabel *_countLabel;
}

@end

@implementation MFCommodityAvailableSizeItemView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setTitleLabelHidden:(BOOL)hidden
{
    [_titleLabel setHidden:hidden];
}

-(void)setSize:(NSString *)sizeString count:(NSString *)countString
{
    _sizeLabel.text = sizeString;
    _countLabel.text = countString;
}

@end
