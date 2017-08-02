//
//  MFCommodityUrlHelper.h
//  BloomBeauty
//
//  Created by EEKA on 16/7/29.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFCommodityUrlHelper : MFObject

+(NSString *)inStoreGoodsSmallItemUrl:(NSString *)originalItemUrl;

+(NSString *)inStoreGoodsShowingOriginalItemUrl:(NSString *)originalItemUrl;

+(NSString *)oneClothesMatchShowingItemUrl:(NSString *)originalItemUrl;

+(NSString *)consumptionRecordSmallItemUrl:(NSString *)originalItemUrl;

//查询图片大小
+(NSString *)itemUrlInfo:(NSString *)originalItemUrl;

@end
