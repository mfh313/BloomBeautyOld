//
//  MFSalingProdouctQueryApi.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFSalingProdouctQueryApi.h"

@implementation MFSalingProdouctQueryApi

- (NSString *)requestUrl {
    return MFApiQueryAvailableCommodityURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"entityId"] = self.entityId;
    if (self.occasions) {
        params[@"occasions"] = self.occasions;
    }
    if (self.categoryCode) {
        params[@"categoryCode"] = self.categoryCode;
    }
    
    
    return params;
}

@end
