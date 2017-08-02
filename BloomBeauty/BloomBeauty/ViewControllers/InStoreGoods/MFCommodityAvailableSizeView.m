//
//  MFCommodityAvailableSizeView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCommodityAvailableSizeView.h"
#import "MFCommodityAvailableSizeItemView.h"

@interface MFCommodityAvailableSizeView ()
{
    __weak IBOutlet UILabel *_commodityCodeLabel;
    __weak IBOutlet UILabel *_listPriceLabel;
    __weak IBOutlet MFCommodityAvailableSizeItemView *_sizeTipView;
}

@end

@implementation MFCommodityAvailableSizeView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setCommodityCode:(NSString *)commodityCode
{
    _commodityCodeLabel.text = commodityCode;
}

-(void)setListPrice:(NSString *)listPrice
{
    _listPriceLabel.text = listPrice;
}

-(void)setSizeMap:(NSMutableDictionary *)sizeMap
{
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[sizeMap allKeys]];
    [keys sortUsingSelector:@selector(compare:)];
    NSMutableArray *sizeKeysArray = [keys mutableCopy];
    
    CGFloat itemOrignY = CGRectGetMaxY(_sizeTipView.frame);
    
    for (int i = 0; i < sizeKeysArray.count; i++) {
        NSString *size = sizeKeysArray[i];
        NSString *count = [NSString stringWithFormat:@"%@",[sizeMap objectForKey:size]];
        
        MFCommodityAvailableSizeItemView *sizeItemView = [MFCommodityAvailableSizeItemView viewWithNib];
        sizeItemView.frame = CGRectMake(0, itemOrignY, CGRectGetWidth(self.bounds), 44);
        [self addSubview:sizeItemView];
        
        [sizeItemView setTitleLabelHidden:YES];
        [sizeItemView setSize:size count:count];
        
        itemOrignY = itemOrignY + 44;
    }
    
}

@end
