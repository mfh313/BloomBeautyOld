//
//  MFCustomerDiagnosticApi.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticApi.h"

@implementation MFCustomerDiagnosticApi

- (NSString *)requestUrl {
    return MFApiDiagnosisCustomerURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"entityId"] = self.entityId;
    params[@"employeeId"] = self.employeeId;
    params[@"questionJson"] = self.questionJson;
    params[@"questionVersion"] = self.questionVersion;
    
    return params;
}

@end
