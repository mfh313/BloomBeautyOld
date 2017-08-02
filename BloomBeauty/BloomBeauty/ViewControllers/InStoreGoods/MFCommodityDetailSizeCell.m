//
//  MFCommodityDetailSizeCell.m
//  BloomBeauty
//
//  Created by 马方华 on 15/12/24.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCommodityDetailSizeCell.h"

@interface MFCommodityDetailSizeCell ()
{
    
    __weak IBOutlet UILabel *_sizeLabel;

    __weak IBOutlet UILabel *_countLabel;
}

@end

@implementation MFCommodityDetailSizeCell

-(void)setSize:(NSString *)size count:(NSString *)count
{
    _sizeLabel.text = [NSString stringWithFormat:@"%@码",size];
    _countLabel.text = [NSString stringWithFormat:@"%@件",count];
}

@end
