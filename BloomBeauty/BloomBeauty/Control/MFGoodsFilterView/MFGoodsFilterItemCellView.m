//
//  MFGoodsFilterItemCellView.m
//  BloomBeauty
//
//  Created by EEKA on 16/3/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFGoodsFilterItemCellView.h"

@implementation MFGoodsFilterItemCellView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGes];
    
    _bottomLine.exBackgroundColor = [UIColor hx_colorWithHexString:@"d4d4d4"];
}

-(void)onTap:(id )sender
{
    if ([self.m_delegate respondsToSelector:@selector(onDidSelectedFilterItem:)]) {
        [self.m_delegate onDidSelectedFilterItem:self.indexPath];
    }
}

-(void)setTitle:(NSString *)title selected:(BOOL)isSelected
{
    titleLabel.text = title;
    checkBox.hidden = !isSelected;
}

@end
