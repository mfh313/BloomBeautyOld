//
//  MFCustomerInfoManager.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"
#import "MFBrandInfo.h"

@interface MFCustomerRegionDataItem : NSObject

@property (nonatomic,strong) NSString *regionCode;
@property (nonatomic,strong) NSString *regionName;
@property (nonatomic,strong) NSMutableArray *cityInfoArray;

@end

#pragma mark - MFCustomerCityDataItem
@interface MFCustomerCityDataItem : NSObject

@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *parentCityCode;
@property (nonatomic,strong) NSString *regionCode;
@property (nonatomic,strong) NSMutableArray *zoneInfoArray;

@end

#pragma mark - MFCustomerZoneDataItem
@interface MFCustomerZoneDataItem : NSObject

@property (nonatomic,strong) NSString *zoneCode;
@property (nonatomic,strong) NSString *zoneName;
@property (nonatomic,strong) NSString *parentCityCode;
@property (nonatomic,strong) NSString *regionCode;

@end

#pragma mark - MFCustomerInfoOccupationDataItem
@interface MFCustomerInfoOccupationDataItem : NSObject

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;

@end


#pragma mark - MFCustomerInfoManager
@interface MFCustomerInfoManager : MFObject

+ (instancetype)sharedManager;
+ (NSString *)regionDescWithRegionCode:(NSString *)regionCode cityCode:(NSString *)cityCode zoneCode:(NSString *)zoneCode;
- (void)getRegions:(void (^)(NSMutableArray *regionArray))completionBlock;
- (NSMutableArray *)occupations;
- (NSMutableDictionary *)oftenEnterOccation;
- (NSMutableDictionary *)oftenAccompanyPerson;
- (NSMutableDictionary *)customerMentality;

-(NSString *)occupationForkey:(NSString *)key;
-(NSString *)oftenEnterOccationDescForkey:(NSString *)key;
-(NSString *)oftenAccompanyPersonDescForkey:(NSString *)key;
-(NSString *)customerMentalityDescForkey:(NSString *)key;

@end
