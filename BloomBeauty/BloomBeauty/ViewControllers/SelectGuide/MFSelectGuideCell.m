//
//  MFSelectGuideCell.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/7.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSelectGuideCell.h"

@interface MFSelectGuideCell ()
{
    __weak IBOutlet UILabel *_nameLabel;
}

@end


@implementation MFSelectGuideCell
@synthesize cellSelected;

-(void)setCellSelected:(BOOL)selected
{
    cellSelected = selected;
    if (cellSelected) {
        _nameLabel.textColor = BBDefaultColor;
    }
    else
    {
        _nameLabel.textColor = MFDarkTextColor;
    }
}

-(void)setName:(NSString *)name
{
    _nameLabel.text = name;
}

@end
