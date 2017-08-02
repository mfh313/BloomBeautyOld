//
//  MFUpdatePortraitEntityApi.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/15.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUpdatePortraitEntityApi.h"

@implementation MFUpdatePortraitEntityApi

- (NSString *)requestUrl {
    return MFApiUpdatePortraitEntityURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"individualNo"] = self.individualNo;
    params[@"imageStreams"] = self.imageStreams;
    
    return params;
}

@end
