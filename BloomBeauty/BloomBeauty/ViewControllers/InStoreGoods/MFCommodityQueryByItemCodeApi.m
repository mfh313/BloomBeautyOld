//
//  MFCommodityQueryByItemCodeApi.m
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCommodityQueryByItemCodeApi.h"

@implementation MFCommodityQueryByItemCodeApi

- (NSString *)requestUrl {
    return MFApiQueryCommodityByItemCodeURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"entityId"] = self.entityId;
    params[@"commodityCode"] = self.commodityCode;
    
    return params;
}

@end
