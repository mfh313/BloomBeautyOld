//
//  MFGoodsFilterItemData.h
//  BloomBeauty
//
//  Created by EEKA on 16/3/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFGoodsFilterItemData : MFObject


@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *matchContent;
@property (nonatomic,assign) BOOL isSelected;

+(MFGoodsFilterItemData *)getItemDataWithTitle:(NSString *)title matchContent:(NSString *)matchContent;

+(NSMutableArray *)getItemDatasForCommodityCode;

+(NSMutableArray *)getItemDatasForOccasions;


@end
