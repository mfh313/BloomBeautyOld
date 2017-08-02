//
//  MFCustomerInfoManager.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerInfoManager.h"
#import "MFGetRegionsApi.h"
#import "MFCustomerInfoGetTemplateApi.h"

@implementation MFCustomerRegionDataItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"cityInfoArray" : @"cityList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cityInfoArray" : [MFCustomerCityDataItem class]};
}

@end


#pragma mark - MFCustomerCityDataItem
@implementation MFCustomerCityDataItem

@end


#pragma mark - MFCustomerZoneDataItem
@implementation MFCustomerZoneDataItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"zoneCode" : @"cityCode",
             @"zoneName" : @"cityName"
             };
}

@end

#pragma mark - MFCustomerInfoOccupationDataItem
@implementation MFCustomerInfoOccupationDataItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"key" : @"dicKey",
             @"value" : @"dicValue"
             };
}

@end

#pragma mark - MFCustomerInfoManager
@interface MFCustomerInfoManager ()
{
    NSMutableArray *_regionArray;
    NSMutableArray *_zoneArray;
    
    MFGetRegionsApi *_getRegionsApi;
    MFCustomerInfoGetTemplateApi *_getTemplateApi;
    
    NSMutableArray *_occupations;
    NSMutableDictionary *_customerMentality;
    NSMutableDictionary *_oftenAccompanyPerson;
    NSMutableDictionary *_oftenEnterOccation;
    
}

@end

@implementation MFCustomerInfoManager

+ (instancetype)sharedManager
{
    static MFCustomerInfoManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _regionArray = [NSMutableArray array];
        _zoneArray = [NSMutableArray array];
        _getRegionsApi = [MFGetRegionsApi new];
        [self getRegions:nil];
        
        _occupations = [NSMutableArray array];
        _getTemplateApi = [MFCustomerInfoGetTemplateApi new];
        [self getCustomerInfoTemplates];

    }
    return self;
}

-(void)getCustomerInfoTemplates
{
    [_getTemplateApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        
        NSDictionary *dictionaryMap = responseObject[@"dictionaryMap"];
        if ([dictionaryMap isKindOfClass:[NSNull class]]) {
            return;
        }
        
        [_occupations removeAllObjects];
        NSMutableArray *occupationList = responseObject[@"occupationList"];
        for (int i = 0; i < occupationList.count; i++) {
            MFCustomerInfoOccupationDataItem *dataItem = [MFCustomerInfoOccupationDataItem yy_modelWithDictionary:occupationList[i]];
            [_occupations addObject:dataItem];
        }
        
        _customerMentality = dictionaryMap[@"customerMentality"];
        _oftenAccompanyPerson = dictionaryMap[@"oftenAccompanyPerson"];
        _oftenEnterOccation = dictionaryMap[@"oftenEnterOccation"];

        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    
    }];
}

-(void)getRegions:(void (^)(NSMutableArray *regionArray))completionBlock
{
    if (_regionArray.count > 0) {
        if (completionBlock) {
            completionBlock(_regionArray);
        }
        return;
    }
    
    [_getRegionsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        
        NSArray *regionList = responseObject[@"regionList"];
        if ([regionList isKindOfClass:[NSNull class]]) {
            completionBlock(nil);
            return;
        }
        
        NSMutableDictionary *cityInfoDic = [NSMutableDictionary dictionary];
        NSArray *cityInfos = responseObject[@"zoneList"];
        for (int i = 0; i < cityInfos.count; i++) {
            
            NSDictionary *cityInfoItem = cityInfos[i];
            NSString *cityCode = cityInfoItem[@"regionCode"];
            
            MFCustomerCityDataItem *cityDataItem = [MFCustomerCityDataItem new];
            cityDataItem.cityCode = cityCode;
            cityDataItem.cityName = cityInfoItem[@"regionName"];
            
            NSArray *zoneList = cityInfoItem[@"cityList"];
            if ([zoneList isKindOfClass:[NSNull class]]) {
                continue;
            }
            
            NSMutableArray *zoneArray = [NSMutableArray array];
            for (int j = 0; j < zoneList.count; j++) {
                MFCustomerZoneDataItem *zoneDataItem = [MFCustomerZoneDataItem yy_modelWithDictionary:zoneList[j]];
                [zoneArray addObject:zoneDataItem];
            }
            
            cityDataItem.zoneInfoArray = zoneArray;
            if (cityCode) {
                [cityInfoDic setObject:cityDataItem forKey:cityCode];
            };
        }
        
        [_regionArray removeAllObjects];
        for (int i = 0; i < regionList.count; i++) {
            MFCustomerRegionDataItem *dataItem = [MFCustomerRegionDataItem yy_modelWithDictionary:regionList[i]];
            
            NSMutableArray *cityInfoArray = dataItem.cityInfoArray;
            for (int j = 0; j < cityInfoArray.count; j++) {
                MFCustomerCityDataItem *cityDataItem = cityInfoArray[j];
                
                NSString *cityCode = cityDataItem.cityCode;
                MFCustomerCityDataItem *cityInfoItem = cityInfoDic[cityCode];
                cityDataItem.zoneInfoArray = cityInfoItem.zoneInfoArray;
                
            }
            
            [_regionArray addObject:dataItem];
        }
        
        if (completionBlock) {
            completionBlock(_regionArray);
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (completionBlock) {
            completionBlock(nil);
        }
    }];
}

+ (NSString *)regionDescWithRegionCode:(NSString *)regionCode cityCode:(NSString *)cityCode zoneCode:(NSString *)zoneCode
{
    return [[self sharedManager] regionDescWithRegionCode:regionCode cityCode:cityCode zoneCode:zoneCode];
}

- (NSString *)regionDescWithRegionCode:(NSString *)regionCode cityCode:(NSString *)cityCode zoneCode:(NSString *)zoneCode
{
    NSString *regionName = nil;
    NSString *cityName = nil;
    NSString *zoneName = nil;
    
    for (int i = 0; i < _regionArray.count; i++) {
        MFCustomerRegionDataItem *regionData = _regionArray[i];
        if ([regionData.regionCode isEqualToString:regionCode]) {
            
            regionName = regionData.regionName;
            
            NSMutableArray *cityInfoArray = regionData.cityInfoArray;
            for (int j = 0; j < cityInfoArray.count; j++) {
                MFCustomerCityDataItem *cityData = cityInfoArray[j];
                if ([cityData.cityCode isEqualToString:cityCode]) {
                    cityName = cityData.cityName;
                    
                    NSMutableArray *zoneInfoArray = cityData.zoneInfoArray;
                    for (int z = 0; z < zoneInfoArray.count; z++) {
                        MFCustomerZoneDataItem *zoneData = zoneInfoArray[z];
                        
                        if ([zoneData.zoneCode isEqualToString:zoneCode]) {
                            zoneName = zoneData.zoneName;
                        }
                    }
                }
            }
        }
    }
    
    NSString *regionDesc = nil;
    if (regionName) {
        regionDesc = regionName;
        if (cityName) {
            regionDesc = [regionDesc stringByAppendingString:cityName];
            if (zoneName) {
                regionDesc = [regionDesc stringByAppendingString:zoneName];
            }
        }
    }
    
    if (!regionDesc) {
        regionDesc = @"未获取省市描述";
    }
    
    return regionDesc;
}

-(NSMutableArray *)regionArray
{
    return _regionArray;
}

-(NSMutableArray *)occupations
{
    return _occupations;
}

- (NSMutableDictionary *)oftenEnterOccation
{
    return _oftenEnterOccation;
}

- (NSMutableDictionary *)oftenAccompanyPerson
{
    return _oftenAccompanyPerson;
}

- (NSMutableDictionary *)customerMentality
{
    return _customerMentality;
}

-(NSString *)occupationForkey:(NSString *)key
{
    for (int i = 0; i < _occupations.count; i++) {
        MFCustomerInfoOccupationDataItem *dataItem = _occupations[i];
        if ([dataItem.key isEqualToString:key]) {
            return dataItem.value;
        };
    }
    
    return nil;
}

-(NSString *)oftenEnterOccationDescForkey:(NSString *)key
{
    NSArray *keyArray = [key componentsSeparatedByString:@","];
    
    NSString *oftenEnterOccationDesc = [self showingContentString:_oftenEnterOccation view:@"oftenEnterOccation" selectedArray:keyArray];
    
    return oftenEnterOccationDesc;
}

-(NSString *)oftenAccompanyPersonDescForkey:(NSString *)key
{
    NSArray *keyArray = [key componentsSeparatedByString:@","];

    NSString *oftenAccompanyPersonDesc = [self showingContentString:_oftenAccompanyPerson view:@"oftenAccompanyPerson" selectedArray:keyArray];
    return oftenAccompanyPersonDesc;
}

-(NSString *)customerMentalityDescForkey:(NSString *)key
{
    NSArray *keyArray = [key componentsSeparatedByString:@","];
    NSString *customerMentalityDesc = [self showingContentString:_customerMentality view:@"customerMentality" selectedArray:keyArray];;
    
    return customerMentalityDesc;
}

-(NSString *)showingContentString:(NSMutableDictionary *)infoDic view:(NSString *)viewKey selectedArray:(NSArray *)selectedArray
{
    NSMutableArray *stringArray = [NSMutableArray array];
    for (int i = 0; i < selectedArray.count; i++) {
        NSString *key = selectedArray[i];
        if (infoDic[key]) {
            [stringArray addObject:infoDic[key]];
        }
    }
    
    return [stringArray componentsJoinedByString:@","];
}

@end
