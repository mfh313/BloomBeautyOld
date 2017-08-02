//
//  MFCustomerMaintenanceUpdateApi.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/5.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceUpdateApi.h"

@implementation MFCustomerMaintenanceUpdateApi

- (NSString *)requestUrl {
    return MFApiCustomerMaintenanceUpdateURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"questionJson"] = self.questionJson;
    
    return params;
}



@end
