//
//  MFCustomerBodyMadeQueryApi.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeQueryApi.h"

@implementation MFCustomerBodyMadeQueryApi

- (NSString *)requestUrl {
    return MFApiCustomerBodyMadeQueryURL;
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
