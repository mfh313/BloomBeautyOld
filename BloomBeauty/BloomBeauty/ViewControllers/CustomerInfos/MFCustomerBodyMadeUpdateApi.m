//
//  MFCustomerBodyMadeUpdateApi.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeUpdateApi.h"

@implementation MFCustomerBodyMadeUpdateApi

- (NSString *)requestUrl {
    return MFApiCustomerBodyMadeUpdateURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"individualNo"] = self.individualNo;
    
    for (NSString *key in self.updateKeyValues.allKeys) {
        NSString *object = self.updateKeyValues[key];
        if (object) {
            [params setObject:object forKey:key];
        }
        
    }
    
    return params;
}

@end
