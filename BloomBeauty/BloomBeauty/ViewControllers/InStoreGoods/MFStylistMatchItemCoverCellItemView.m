//
//  MFStylistMatchItemCoverCellItemView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/14.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFStylistMatchItemCoverCellItemView.h"

@interface MFStylistMatchItemCoverCellItemView ()
{
    __weak IBOutlet UILabel *_itemNameLabel;
    __weak IBOutlet UILabel *_itemCodeLabel;

    __weak IBOutlet MFOnePixLine *_line;
}

@end

@implementation MFStylistMatchItemCoverCellItemView

-(void)setItemName:(NSString *)itemName itemCode:(NSString *)itemCode
{
    _itemNameLabel.text = itemName;
    _itemCodeLabel.text = itemCode;
}

-(void)setLineHidden:(BOOL)hidden
{
    [_line setHidden:hidden];
}

@end
