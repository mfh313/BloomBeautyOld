//
//  MFSalingProdouctSearchResultView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFSalingProdouctSearchResultView.h"
#import "MFCommodityAvailableSizeView.h"
#import "MFCommodityDetailImageView.h"
#import "MFQueryAvailableSizeApi.h"
#import "MFCommodityDetailModel.h"

@interface MFSalingProdouctSearchResultView ()
{
    __weak IBOutlet MFCommodityDetailImageView *_imageView;
    __weak IBOutlet MFCommodityAvailableSizeView *_detailSizeView;
    
    MFQueryAvailableSizeApi *_queryAvailableSizeApi;
}

@end


@implementation MFSalingProdouctSearchResultView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _queryAvailableSizeApi = [MFQueryAvailableSizeApi new];
}


-(void)queryAvailableDetail
{
    _imageView.imageUrl = self.itemOriginalItemUrl;
    [_imageView fillContentImageView];
    
    [self queryAvailableSize];
}

-(void)queryAvailableSize
{
    _queryAvailableSizeApi.entityId = [MFLoginCenter sharedCenter].currentShopingGuideInfo.entityId;
    _queryAvailableSizeApi.commodityCode = self.itemStyleColor;
    [_queryAvailableSizeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        if ([responseObject[@"statusCode"] isKindOfClass:[NSNull class]]
             || [responseObject[@"commodityDetail"] isKindOfClass:[NSNull class]])
        {
            return;
        }
        
        NSMutableDictionary *commodityDetailDic = responseObject[@"commodityDetail"];
        MFCommodityDetailModel *detailModel = [MFCommodityDetailModel MM_modelWithDictionary:commodityDetailDic];
        
        dispatch_main_async_safe(^{
            [_detailSizeView setCommodityCode:detailModel.commodityCode];
            [_detailSizeView setListPrice:detailModel.listPrice.stringValue];
            [_detailSizeView setSizeMap:detailModel.sizeDic];
        });
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

@end
