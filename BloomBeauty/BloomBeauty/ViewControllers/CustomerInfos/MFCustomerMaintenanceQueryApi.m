//
//  MFCustomerMaintenanceQueryApi.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/5.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceQueryApi.h"

@implementation MFCustomerMaintenanceQueryApi

- (NSString *)requestUrl {
    return MFApiCustomerQueryMaintenanceURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"individualNo"] = self.individualNo;
    
    return params;
}

@end
