//
//  MFGoodsFilterItemData.m
//  BloomBeauty
//
//  Created by EEKA on 16/3/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFGoodsFilterItemData.h"

@implementation MFGoodsFilterItemData

+(MFGoodsFilterItemData *)getItemDataWithTitle:(NSString *)title matchContent:(NSString *)matchContent
{
    MFGoodsFilterItemData *data = [[MFGoodsFilterItemData alloc] init];
    
    if (data) {
        data.title = title;
        data.matchContent = matchContent;
    }
    
    return data;
}

+(NSMutableArray *)getItemDatasForCommodityCode
{
    NSArray *titleArray = @[@"披肩",@"长袖薄外套",@"西装",@"风衣",@"短袖薄外套",@"中、长袖上衣",@"衬衣",@"中厚外套",@"短袖上衣",@"连衣裙",@"礼服",@"马夹",@"大衣",@"皮草御寒服",@"羽绒服",@"棉衣",@"针织衫"];
    NSArray *matchContentArray = @[@"00,01,02,09",
        @"10,11,19,15,16",
        @"12,13,14,42,43",
        @"17,18",
        @"40,47,48",
        @"23,24,25,26,29",
        @"44,22",
        @"30,31,32,33,34",
        @"45,46",
        @"60,61,62,63,64,65,66,69",
        @"67,68",
        @"81,84,85",
        @"90,91,92",
        @"9Q,98",
        @"96,97",
        @"93,94,95,99",
        @"20,21,41"];
    NSMutableArray *itemDatas = [NSMutableArray array];
    
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];
        NSString *matchContent = matchContentArray[i];
        MFGoodsFilterItemData *itemData = [MFGoodsFilterItemData getItemDataWithTitle:title matchContent:matchContent];
        [itemDatas addObject:itemData];
    }
    
    return itemDatas;
}

+(NSMutableArray *)getItemDatasForOccasions
{
    NSArray *titleArray = @[@"商务日装",@"社交晚宴",@"时尚职场",@"普通职场",@"婚庆喜庆",@"日常休闲",@"旅游休闲",@"运动休闲"];
    NSArray *matchContentArray = @[@"1",@"5",@"10",@"15",@"20",@"25",@"30",@"35"];
    NSMutableArray *itemDatas = [NSMutableArray array];
    
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];
        NSString *matchContent = matchContentArray[i];
        MFGoodsFilterItemData *itemData = [MFGoodsFilterItemData getItemDataWithTitle:title matchContent:matchContent];
        [itemDatas addObject:itemData];
    }
    
    return itemDatas;
}


@end
