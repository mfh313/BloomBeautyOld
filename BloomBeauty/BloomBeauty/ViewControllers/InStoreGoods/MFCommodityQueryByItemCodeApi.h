//
//  MFCommodityQueryByItemCodeApi.h
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFCommodityQueryByItemCodeApi : MFNetworkRequest

@property (nonatomic,copy) NSString *entityId;
@property (nonatomic,copy) NSString *commodityCode;

@end
