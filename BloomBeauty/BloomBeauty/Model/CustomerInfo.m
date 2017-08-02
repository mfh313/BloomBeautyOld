//
//  LoginUserInfo.m
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "CustomerInfo.h"
#import "CommonUtil.h"
#import "DiagnosisResult.h"
#import "MFCustomerFavoriteQueryApi.h"
#import "MFCommodityUrlHelper.h"

NSString *const MFNotifiCurrentCustomerInfoChange = @"currentCustomerInfoChange";

@implementation CustomerInfo

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.email = @"";
        self.weChat = @"";
        self.imageStreams = @"";
        self.occupationType = @"";
        self.regionCode = 0;
        self.cityCode = 0;
        self.favoriteArray = [NSMutableArray array];
    }
    
    return self;
}

-(id)initInfo
{
    self = [self init] ;
    if (self) {
        
    }
    return self ;
}

-(NSString*)getStrIsDiagnosis
{
    NSString *val = @"未诊断";
    if([CommonUtil isNotNull:self.isDiagnosis] )
    {
        if([self.isDiagnosis MF_isDiagnosis])
        {
            val = @"已诊断";
        }
        else
        {
            val = @"未诊断";
        }
    }
    return val;
    
}

-(NSString*) getFullName
{
    NSMutableString *fullName = [[NSMutableString alloc]init];
    if([CommonUtil isNotNull:self.lastName] )
    {
        [fullName appendString:self.lastName];
    }
    if([CommonUtil isNotNull:self.firstName] )
    {
        [fullName appendString:self.firstName];
    }
    return fullName;
}

-(NSString*) getImgNameByPortraitUpdateDate
{
    return [self getImgNameByDate:_portraitUpdateDate];
}

-(NSString*) getImgNameByDate:(NSString*)date
{
    NSString *portraitUpdateDate = @"";
    if([CommonUtil isNotNull:date])
    {
        portraitUpdateDate = [date stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        portraitUpdateDate = [portraitUpdateDate stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        portraitUpdateDate = [portraitUpdateDate stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    }
    NSString *str = [NSString stringWithFormat:@"%@_%@",_individualNo,portraitUpdateDate];
    return str;
}

//获取最后一次诊断记录
-(void)getLastOneDiagnosticRecord
{
    if(!self.individualNo)
    {
        return;
    }
    
    NSString *token = BloomBeautyToken;
    NSDictionary *parameters = @{
                                 @"individualNo":self.individualNo,
                                 @"maxNum":@1,
                                 @"token": token
                                 };
    [MFHTTPUtil POST_ToDict:MFApiQueryDiagnosisRecordsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *posVoucherRecordList = responseObject[@"results"];
        for (id object in posVoucherRecordList) {
            DiagnosisResult *obj = [DiagnosisResult objectWithKeyValues:object];
            self.lastDiagnosisResultId  = obj.diagnosisResultId;
            break;
        }
    } failureTips:^(NSString *tips) {
        
    }];
}

-(void)queryFavorites
{
    if ([self.individualNo isKindOfClass:[NSNull class]]) {
        return;
    }
    
    if([CommonUtil isNull:self.individualNo]){
        return;
    }
    
    MFCustomerFavoriteQueryApi *queryFavoritesApi = [MFCustomerFavoriteQueryApi new];
    queryFavoritesApi.individualNo = self.individualNo;
    
    [queryFavoritesApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSArray *favoriteCommodityList = responseObject[@"favoriteCommodityList"];
        if ([favoriteCommodityList isKindOfClass:[NSNull class]]) {
            return;
        }
        
        for (int i = 0; i < favoriteCommodityList.count; i++)
        {
             CustomerFavoriteCommodityItem *favoriteCommodityItem = [CustomerFavoriteCommodityItem MM_modelWithDictionary:favoriteCommodityList[i]];
            if (!favoriteCommodityItem.smallItemUrl) {
                favoriteCommodityItem.smallItemUrl = [MFCommodityUrlHelper inStoreGoodsSmallItemUrl:favoriteCommodityItem.originalItemUrl];
             }
             [_favoriteArray addObject:favoriteCommodityItem];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(void)removeFavoriteItemStyleColor:(NSString *)itemStyleColor
{
    NSMutableArray *favoriteCommodityList = self.favoriteArray;
    for (int i = 0; i < favoriteCommodityList.count; i++)
    {
        CustomerFavoriteCommodityItem *favoriteCommodityItem = favoriteCommodityList[i];
        if ([favoriteCommodityItem.itemStyleColor isEqualToString:itemStyleColor]) {
            [favoriteCommodityList removeObject:favoriteCommodityItem];
        }
    }
}

-(void)addFavoriteItemStyleColor:(NSString *)itemStyleColor
{
    MFCustomerFavoriteQueryApi *addApi = [MFCustomerFavoriteQueryApi new];
    addApi.individualNo = self.individualNo;
    addApi.commodityCode = itemStyleColor;
    
    [addApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSMutableArray *favoriteCommodityList = responseObject[@"favoriteCommodityList"];
        for (int i = 0; i < favoriteCommodityList.count; i++)
        {
            CustomerFavoriteCommodityItem *favoriteCommodityItem = [CustomerFavoriteCommodityItem MM_modelWithDictionary:favoriteCommodityList[i]];
            [_favoriteArray addObject:favoriteCommodityItem];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

@end

#pragma mark - NSString
@implementation NSString (MF_isDiagnosis)

-(BOOL)MF_isDiagnosis
{
    if ([self isEqualToString:@"Y"]) {
        return YES;
    }
    
    return NO;
}

@end

#pragma mark - CustomerFavoriteCommodityItem

@implementation CustomerFavoriteCommodityItem


@end

