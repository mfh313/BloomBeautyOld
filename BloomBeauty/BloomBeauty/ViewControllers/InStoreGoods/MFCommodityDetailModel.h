//
//  MFCommodityDetailModel.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"
#import "NSString+commodityCodeFavorite.h"
#import "MFOneClothesMatchDataItem.h"
#import "MFCommodityUrlHelper.h"
#import "MFSmallCellSizeCacheManger.h"

@interface MFInStoreGoodsModel : MFObject

@property (nonatomic,strong) NSString *originalItemUrl;
@property (nonatomic,strong) NSString *smallItemUrl;
@property (nonatomic,strong) NSString *itemStyleColor;
@property (nonatomic,assign) BOOL isFavorite;
@property (nonatomic,assign) CGSize imageSize;

@end


@interface MFCommodityDetailModel : MFObject

@property (nonatomic,strong) NSString *commodityCode;
@property (nonatomic,strong) NSString *commodityThumbNailUrl;
@property (nonatomic,strong) NSString *commodityImageOriginalUrl;
@property (nonatomic,strong) NSString *itemName;
@property (nonatomic,strong) NSString *hasStylistMatch;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,strong) NSNumber *listPrice;
@property (nonatomic,strong) NSMutableDictionary *sizeDic;
@property (nonatomic,assign) BOOL isFavorite;

@end



@interface MFCommodityCollectionGroup : MFObject

@property (nonatomic,strong) NSMutableArray *commodityDetailModels;
@property (nonatomic,strong) NSArray *commodityCodeInfoArray;

@end
