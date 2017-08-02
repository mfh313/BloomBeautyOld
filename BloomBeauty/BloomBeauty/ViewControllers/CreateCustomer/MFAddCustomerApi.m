//
//  MFAddCustomerApi.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/13.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFAddCustomerApi.h"

@implementation MFAddCustomerApi

- (NSString *)requestUrl {
    return MFApiAddCustomerURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    
    for (int j = 0; j < self.creatInfo.allKeys.count; j++) {
        NSString *key = self.creatInfo.allKeys[j];
        [params setObject:self.creatInfo[key] forKey:key];
    }
    
    return params;
}

@end
