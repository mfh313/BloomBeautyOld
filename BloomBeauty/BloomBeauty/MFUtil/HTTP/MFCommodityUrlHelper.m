//
//  MFCommodityUrlHelper.m
//  BloomBeauty
//
//  Created by EEKA on 16/7/29.
//  Copyright © 2016年 EEKA. All rights reserved.
//

//七牛文档说明
//http://developer.qiniu.com/code/v6/api/kodo-api/image/imageview2.html

#import "MFCommodityUrlHelper.h"

@implementation MFCommodityUrlHelper

+(NSString *)inStoreGoodsSmallItemUrl:(NSString *)originalItemUrl
{
    NSString *para = @"?imageView2/2/w/468";
    if (![originalItemUrl hasSuffix:para]) {
        return [originalItemUrl stringByAppendingString:para];
    }
    return originalItemUrl;
}

+(NSString *)consumptionRecordSmallItemUrl:(NSString *)originalItemUrl
{
    NSString *para = @"?imageView2/2/w/260/h/260";
    if (![originalItemUrl hasSuffix:para]) {
        return [originalItemUrl stringByAppendingString:para];
    }
    return originalItemUrl;
}

+(NSString *)inStoreGoodsShowingOriginalItemUrl:(NSString *)originalItemUrl
{
    return originalItemUrl;
}

+(NSString *)oneClothesMatchShowingItemUrl:(NSString *)originalItemUrl
{
    return originalItemUrl;
}

+(NSString *)itemUrlInfo:(NSString *)originalItemUrl
{
    NSString *imageInfoString = nil;
    if ([originalItemUrl containsString:@"?"]) {
        imageInfoString = [originalItemUrl stringByAppendingString:@"|imageInfo"];
    }
    else
    {
        imageInfoString = [originalItemUrl stringByAppendingString:@"?imageInfo"];
    }
    
    return [imageInfoString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}

@end
