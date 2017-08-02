//
//  MFGetCitiesApi.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFGetCitiesApi.h"

@implementation MFGetCitiesApi

- (NSString *)requestUrl {
    return MFApiGetCitiesURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"regionCode"] = self.regionCode;
    
    return params;
}

@end
