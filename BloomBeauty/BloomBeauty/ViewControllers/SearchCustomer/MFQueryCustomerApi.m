//
//  MFQueryCustomerApi.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFQueryCustomerApi.h"

@implementation MFQueryCustomerApi

- (NSString *)requestUrl {
    return MFApiQueryCustomerURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"brandId"] = self.brandId;
    params[@"phoneNumber"] = self.searchKey;
    
    return params;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 10;
}

@end
