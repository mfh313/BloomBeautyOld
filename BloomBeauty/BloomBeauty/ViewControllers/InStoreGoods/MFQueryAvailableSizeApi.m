//
//  MFQueryAvailableSizeApi.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/14.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFQueryAvailableSizeApi.h"

@implementation MFQueryAvailableSizeApi

- (NSString *)requestUrl {
    return MFApiQueryAvailableSizeURL;
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
