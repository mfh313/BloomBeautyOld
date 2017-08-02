//
//  MFUpdateCustomerApi.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/15.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUpdateCustomerApi.h"

@implementation MFUpdateCustomerApi

- (NSString *)requestUrl {
    return MFApiUpdateCustomerURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"individualNo"] = self.individualNo;
    
    for (int j = 0; j < self.editingInfoValues.allKeys.count; j++) {
        NSString *key = self.editingInfoValues.allKeys[j];
        [params setObject:self.editingInfoValues[key] forKey:key];
    }
    
    return params;
}

@end
