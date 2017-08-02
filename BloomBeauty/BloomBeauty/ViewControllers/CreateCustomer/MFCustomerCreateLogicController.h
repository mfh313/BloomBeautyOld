//
//  MFCustomerCreateLogicController.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/4.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFObject.h"

typedef enum
{
    CustomerInfoTypeDefault = 0,
    CustomerInfoTypeBirthDay = 1,
    CustomerInfoTypeProvincesCities = 2,
    CustomerInfoTypeCoverSelect = 3,
} MFCustomerInfoShowType;

@interface MFCustomerInfoShowObject : NSObject

@property (nonatomic,strong) NSString *valueKey;
@property (nonatomic,strong) NSString *showingTitle;
@property (nonatomic,strong) NSString *showingPlaceHolder;
@property (nonatomic,strong) NSString *showingContentString;
@property (nonatomic,assign) BOOL canEdit;
@property (nonatomic,assign) MFCustomerInfoShowType type;

@property (nonatomic,strong) NSMutableDictionary *valueInfo;

+(instancetype)objectWithValueKey:(NSString *)valueKey
                     showingTitle:(NSString *)showingTitle
                   showingContent:(NSString *)showingContentString
                          canEdit:(BOOL)canEdit
                         showType:(MFCustomerInfoShowType)type;


@end

#pragma mark - MFCustomerCreateLogicController
@interface MFCustomerCreateLogicController : MFObject

+(NSInteger)maxOftenEnterOccation;

-(NSMutableArray *)editRequiredCustomerInfoModel;
-(NSMutableArray *)editOptionalCustomerInfoModel;
-(NSMutableArray *)customerInfoShowObjects:(NSMutableArray *)array info:(CustomerInfo *)customerInfo;
+(NSTimeZone *)timeZone;
+(BOOL)isLunar:(NSString *)isLunar;
+(NSString *)lunarDesc:(NSString *)isLunar;
+(NSString *)dateDescYob:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob;
+(NSDate *)dateWithYob:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob;
+(NSString *)dateDescYob:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob isLunar:(NSString *)isLunar;


@end
