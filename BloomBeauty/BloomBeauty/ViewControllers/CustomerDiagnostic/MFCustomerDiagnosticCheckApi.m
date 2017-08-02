//
//  MFCustomerDiagnosticCheckApi.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/12.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticCheckApi.h"

@implementation MFCustomerDiagnosticCheckApi

- (NSString *)requestUrl {
    
    if ([MFApiUtil packageTest]) {
        return @"http://bloombeauty-fileserver.eeka.info/diagnosticData/test/diagnosticDataVersion_test.json";
    }
    return @"http://bloombeauty-fileserver.eeka.info/diagnosticData/diagnosticDataVersion.json";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


@end
