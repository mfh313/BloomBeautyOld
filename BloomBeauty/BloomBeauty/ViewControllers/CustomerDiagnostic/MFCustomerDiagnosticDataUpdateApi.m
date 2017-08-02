//
//  MFCustomerDiagnosticDataUpdateApi.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/12.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticDataUpdateApi.h"

@implementation MFCustomerDiagnosticDataUpdateApi

- (NSString *)requestUrl {
    return self.dataUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
