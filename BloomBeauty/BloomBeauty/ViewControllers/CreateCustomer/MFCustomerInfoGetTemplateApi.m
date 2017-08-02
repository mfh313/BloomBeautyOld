//
//  MFCustomerInfoGetTemplateApi.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/3.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoGetTemplateApi.h"

@implementation MFCustomerInfoGetTemplateApi

- (NSString *)requestUrl {
    return MFApiCustomerInfoGetTemplateURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    
    return params;
}

@end
