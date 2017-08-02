//
//  MFImageInfoApi.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFImageInfoApi.h"
#import "MFCommodityUrlHelper.h"

@implementation MFImageInfoApi

-(NSString *)requestUrl
{
    NSString *url = [MFCommodityUrlHelper itemUrlInfo:self.imageUrl];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <= 299) {
        return YES;
    } else {
        return NO;
    }
}

@end
