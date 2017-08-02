//
//  MFCustomerFavoriteQueryApi.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerFavoriteQueryApi.h"

@implementation MFCustomerFavoriteQueryApi

- (NSString *)requestUrl {
    return MFApiQueryFavoritesURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = BloomBeautyToken;
    
    params[@"token"] = token;
    params[@"individualNo"] = self.individualNo;
    
    if (self.commodityCode) {
        params[@"commodityCode"] = self.commodityCode;
    }
    
    return params;
}

@end
