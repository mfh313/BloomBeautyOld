//
//  MFCustomerCreateLogicController.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/4.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerCreateLogicController.h"
#import "MFCustomerInfoManager.h"

@implementation MFCustomerInfoShowObject

+(instancetype)objectWithValueKey:(NSString *)valueKey
                     showingTitle:(NSString *)showingTitle
                   showingContent:(NSString *)showingContentString
                          canEdit:(BOOL)canEdit
                         showType:(MFCustomerInfoShowType)type
{
    MFCustomerInfoShowObject *object = [MFCustomerInfoShowObject new];
    
    object.valueKey = valueKey;
    object.showingTitle = showingTitle;
    object.showingContentString = showingContentString;
    object.canEdit = canEdit;
    object.type = type;
    object.valueInfo = [NSMutableDictionary dictionary];
    
    return object;
}


@end

#pragma mark - MFCustomerCreateLogicController
@implementation MFCustomerCreateLogicController

-(NSMutableArray *)editRequiredCustomerInfoModel
{
    MFCustomerInfoShowObject *lastName = [MFCustomerInfoShowObject objectWithValueKey:@"lastName"
                                                                         showingTitle:@"姓"
                                                                       showingContent:nil
                                                                              canEdit:YES
                                                                             showType:CustomerInfoTypeDefault];
    
    MFCustomerInfoShowObject *firstName = [MFCustomerInfoShowObject objectWithValueKey:@"firstName"
                                                                         showingTitle:@"名"
                                                                       showingContent:nil
                                                                              canEdit:YES
                                                                             showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *phoneNumber = [MFCustomerInfoShowObject objectWithValueKey:@"phoneNumber"
                                                                          showingTitle:@"手机号"
                                                                        showingContent:nil
                                                                               canEdit:YES
                                                                              showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *sex = [MFCustomerInfoShowObject objectWithValueKey:@"sex"
                                                                            showingTitle:@"性别"
                                                                          showingContent:@"女"
                                                                                 canEdit:NO
                                                                                showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *birthDay = [MFCustomerInfoShowObject objectWithValueKey:@"birthDay"
                                                                    showingTitle:@"生日"
                                                                  showingContent:nil
                                                                         canEdit:YES
                                                                        showType:CustomerInfoTypeBirthDay];
    MFCustomerInfoShowObject *regionCity = [MFCustomerInfoShowObject objectWithValueKey:@"regionCity"
                                                                         showingTitle:@"常住地区"
                                                                       showingContent:nil
                                                                              canEdit:YES
                                                                             showType:CustomerInfoTypeProvincesCities];
    MFCustomerInfoShowObject *brandId = [MFCustomerInfoShowObject objectWithValueKey:@"brandId"
                                                                           showingTitle:@"品牌"
                                                                         showingContent:nil
                                                                                canEdit:NO
                                                                               showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *individualGroupDesc = [MFCustomerInfoShowObject objectWithValueKey:@"individualGroupDesc"
                                                                        showingTitle:@"会员等级"
                                                                      showingContent:nil
                                                                             canEdit:NO
                                                                            showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *maintainEntity = [MFCustomerInfoShowObject objectWithValueKey:@"maintainEntityId"
                                                                                    showingTitle:@"维护专柜"
                                                                                  showingContent:nil
                                                                                         canEdit:NO
                                                                                        showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *maintainEmployee = [MFCustomerInfoShowObject objectWithValueKey:@"maintainEmployeeId"
                                                                               showingTitle:@"服务导购"
                                                                             showingContent:nil
                                                                                    canEdit:NO
                                                                                   showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *occupation = [MFCustomerInfoShowObject objectWithValueKey:@"occupationType"
                                                                                 showingTitle:@"职业"
                                                                               showingContent:nil
                                                                                      canEdit:YES
                                                                                     showType:CustomerInfoTypeCoverSelect];
    MFCustomerInfoShowObject *oftenEnterOccation = [MFCustomerInfoShowObject objectWithValueKey:@"oftenEnterOccation"
                                                                                   showingTitle:@"常出入场合"
                                                                                 showingContent:nil
                                                                                        canEdit:YES
                                                                                       showType:CustomerInfoTypeCoverSelect];
    MFCustomerInfoShowObject *oftenAccompanyPerson = [MFCustomerInfoShowObject objectWithValueKey:@"oftenAccompanyPerson"
                                                                                     showingTitle:@"常购物同伴"
                                                                                   showingContent:nil
                                                                                          canEdit:YES
                                                                                         showType:CustomerInfoTypeCoverSelect];
    MFCustomerInfoShowObject *customerMentality = [MFCustomerInfoShowObject objectWithValueKey:@"customerMentality"
                                                                                  showingTitle:@"购买心理"
                                                                                showingContent:nil
                                                                                       canEdit:YES
                                                                                      showType:CustomerInfoTypeCoverSelect];
    
    NSMutableArray *requiredArray = [NSMutableArray array];
    [requiredArray addObject:lastName];
    [requiredArray addObject:firstName];
    [requiredArray addObject:phoneNumber];
    [requiredArray addObject:sex];
    [requiredArray addObject:birthDay];
    [requiredArray addObject:regionCity];
    [requiredArray addObject:occupation];
    [requiredArray addObject:oftenEnterOccation];
    [requiredArray addObject:oftenAccompanyPerson];
    [requiredArray addObject:customerMentality];
    [requiredArray addObject:individualGroupDesc];
    [requiredArray addObject:brandId];
    [requiredArray addObject:maintainEntity];
    [requiredArray addObject:maintainEmployee];
    
    [self initInfoShowObject:requiredArray];
    [self initDefaultShowObject:requiredArray];
    
    return requiredArray;
}

-(NSMutableArray *)editOptionalCustomerInfoModel
{
    MFCustomerInfoShowObject *weChat = [MFCustomerInfoShowObject objectWithValueKey:@"weChat"
                                                                         showingTitle:@"微信"
                                                                       showingContent:nil
                                                                              canEdit:YES
                                                                             showType:CustomerInfoTypeDefault];
    MFCustomerInfoShowObject *email = [MFCustomerInfoShowObject objectWithValueKey:@"email"
                                                                       showingTitle:@"邮箱"
                                                                     showingContent:nil
                                                                            canEdit:YES
                                                                           showType:CustomerInfoTypeDefault];
    
    MFCustomerInfoShowObject *address = [MFCustomerInfoShowObject objectWithValueKey:@"address"
                                                                                  showingTitle:@"详细地址"
                                                                                showingContent:nil
                                                                                       canEdit:YES
                                                                                      showType:CustomerInfoTypeDefault];
    
    
    NSMutableArray *optionalArray = [NSMutableArray array];
    [optionalArray addObject:weChat];
    [optionalArray addObject:email];
    [optionalArray addObject:address];
    
    [self initInfoShowObject:optionalArray];
    
    return optionalArray;
}

-(void)initInfoShowObject:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i++) {
        MFCustomerInfoShowObject *object = (MFCustomerInfoShowObject *)array[i];
        NSString *valueKey = object.valueKey;
        
        if ([valueKey isEqualToString:@"lastName"])
        {
            object.showingPlaceHolder = @"请输入姓";
        }
        else if ([valueKey isEqualToString:@"firstName"])
        {
            object.showingPlaceHolder = @"请输入名";
        }
        else if ([valueKey isEqualToString:@"phoneNumber"])
        {
            object.showingPlaceHolder = @"请输入手机号码";
        }
        else if ([valueKey isEqualToString:@"regionCity"])
        {
            object.showingPlaceHolder = @"请选择常住地区";
        }
        else if ([valueKey isEqualToString:@"occupationType"])
        {
            object.showingPlaceHolder = @"请选择职业";
        }
        else if ([valueKey isEqualToString:@"weChat"])
        {
            object.showingPlaceHolder = @"请输入微信";
        }
        else if ([valueKey isEqualToString:@"email"])
        {
            object.showingPlaceHolder = @"请输入邮箱";
        }
        else if ([valueKey isEqualToString:@"oftenEnterOccation"])
        {
            object.showingPlaceHolder = [NSString stringWithFormat:@"最多选%@项",@([MFCustomerCreateLogicController maxOftenEnterOccation])];
        }
        else if ([valueKey isEqualToString:@"address"])
        {
            object.showingPlaceHolder = @"请输入详细地址";
        }
        else if ([valueKey isEqualToString:@"oftenAccompanyPerson"])
        {
            object.showingPlaceHolder = @"多选";
        }
        else if ([valueKey isEqualToString:@"customerMentality"])
        {
            object.showingPlaceHolder = @"单选";
        }
    }
}

-(void)initDefaultShowObject:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i++) {
        MFCustomerInfoShowObject *object = (MFCustomerInfoShowObject *)array[i];
        NSString *valueKey = object.valueKey;
        
        if ([valueKey isEqualToString:@"sex"]) {
            //性别
            object.showingContentString = @"女";
            [object.valueInfo setObject:@"女" forKey:@"sex"];
        }
        else if ([valueKey isEqualToString:@"birthDay"])
        {
            //生日
            NSString *isLunar = @"Y";
            [object.valueInfo setObject:isLunar forKey:@"isLunar"];
            
            object.showingContentString = @"请录入生日";
        }
        else if ([valueKey isEqualToString:@"brandId"])
        {
            //品牌
            NSNumber *entityBrandId = [MFLoginCenter sharedCenter].loginInfo.entityBrandId;
            MFBrandInfo *brand =  [[MFLoginCenter sharedCenter].brandDict objectForKey:entityBrandId];
            object.showingContentString = brand.brandName;
            
            [object.valueInfo setObject:[entityBrandId stringValue] forKey:@"brandId"];
        }
        else if ([valueKey isEqualToString:@"individualGroupDesc"])
        {
            //会员等级
            NSNumber *entityBrandId = [MFLoginCenter sharedCenter].loginInfo.entityBrandId;
            MFBrandInfo *brand =  [[MFLoginCenter sharedCenter].brandDict objectForKey:entityBrandId];
            
            object.showingContentString = [NSString stringWithFormat:@"新顾客（%@）",brand.brandCode];
        }
        else if ([valueKey isEqualToString:@"maintainEntityId"])
        {
            //维护专柜
            object.showingContentString = [MFLoginCenter sharedCenter].loginInfo.entityName;
            [object.valueInfo setObject:[MFLoginCenter sharedCenter].loginInfo.entityId.stringValue forKey:@"maintainEntityId"];
        }
        else if ([valueKey isEqualToString:@"maintainEmployeeId"])
        {
            //服务导购
            object.showingContentString = [MFLoginCenter sharedCenter].currentShopingGuideInfo.employeeName;
            [object.valueInfo setObject:[MFLoginCenter sharedCenter].currentShopingGuideInfo.employeeId forKey:@"maintainEmployeeId"];
        }
    }
}

+(NSInteger)maxOftenEnterOccation
{
    return 3;
}

+(BOOL)isLunar:(NSString *)isLunar
{
    if ([isLunar isEqualToString:@"Y"]) {
        return YES;
    }
    
    return NO;
}

+(NSString *)lunarDesc:(NSString *)isLunar
{
    if ([isLunar isEqualToString:@"Y"]) {
        return @"公历";
    }
    
    return @"农历";
}

+(NSString *)dateDescYob:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob
{
    NSString *dateDesc = [NSString stringWithFormat:@"%@-%@-%@",yob,mob,dob];
    if (!yob || [yob isEqualToString:@""]
        || !mob || [mob isEqualToString:@""]
        || !dob || [dob isEqualToString:@""])
    {
        dateDesc = @"请录入生日";
    }
    return dateDesc;
}

+(NSDate *)dateWithYob:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob
{
    NSString *dateStr = [MFCustomerCreateLogicController dateDescYob:yob mob:mob dob:dob];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[self timeZone]];
    NSDate *date = [formatter dateFromString:dateStr];
    
    if (date == nil) {
        NSString *defaultDateString = [formatter stringFromDate:[NSDate date]];
        date = [formatter dateFromString:defaultDateString];
    }
    
    return date;
}

+(NSTimeZone *)timeZone
{
    return [NSTimeZone timeZoneWithName:@"GMT"];
}


+(NSString *)dateDescYob:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob isLunar:(NSString *)isLunar
{
    NSString *dateDesc = [[self class] dateDescYob:yob mob:mob dob:dob];
    NSString *lunarDesc = [[self class] lunarDesc:isLunar];
    return [NSString stringWithFormat:@"%@ %@",dateDesc,lunarDesc];;
}

-(NSMutableArray *)customerInfoShowObjects:(NSMutableArray *)array info:(CustomerInfo *)customerInfo
{
    for (int i = 0; i < array.count; i++) {
        MFCustomerInfoShowObject *object = (MFCustomerInfoShowObject *)array[i];
        NSString *valueKey = object.valueKey;
        
        if ([valueKey isEqualToString:@"lastName"]) {
            object.valueInfo[valueKey] = customerInfo.lastName;
            object.showingContentString = customerInfo.lastName;
        }
        else if ([valueKey isEqualToString:@"firstName"])
        {
            object.valueInfo[valueKey] = customerInfo.firstName;
            object.showingContentString = customerInfo.firstName;
        }
        else if ([valueKey isEqualToString:@"phoneNumber"])
        {
            object.canEdit = NO;
            object.valueInfo[valueKey] = customerInfo.searchKey;
            object.showingContentString = customerInfo.searchKey;
        }
        else if ([valueKey isEqualToString:@"sex"])
        {
            object.valueInfo[valueKey] = @"女";
            object.showingContentString = @"女";
        }
        else if ([valueKey isEqualToString:@"birthDay"])
        {
            object.valueInfo[@"yob"] = [NSString stringWithFormat:@"%@",customerInfo.yob];
            object.valueInfo[@"mob"] = [NSString stringWithFormat:@"%@",customerInfo.mob];
            object.valueInfo[@"dob"] = [NSString stringWithFormat:@"%@",customerInfo.dob];
            object.valueInfo[@"isLunar"] = customerInfo.isLunar;
            object.showingContentString = [[self class] dateDescYob:object.valueInfo[@"yob"]
                                                                mob:object.valueInfo[@"mob"]
                                                                dob:object.valueInfo[@"isLunar"]
                                                            isLunar:customerInfo.isLunar];
        }
        else if ([valueKey isEqualToString:@"regionCity"])
        {
            NSString *regionCode = customerInfo.regionCode;
            NSString *cityCode = customerInfo.cityCode;
            NSString *zoneCode = customerInfo.zoneCode;
            if (regionCode) {
                object.valueInfo[@"regionCode"] = regionCode;
            }
            
            if (cityCode) {
                object.valueInfo[@"cityCode"] = cityCode;
            }
            
            if (zoneCode) {
                object.valueInfo[@"zoneCode"] = zoneCode;
            }
            
            object.showingContentString = [MFCustomerInfoManager regionDescWithRegionCode:regionCode cityCode:cityCode zoneCode:zoneCode];
        }
        else if ([valueKey isEqualToString:@"occupationType"])
        {
            NSString *occupationTypeString = [[MFCustomerInfoManager sharedManager] occupationForkey:customerInfo.occupationType];
            if (occupationTypeString) {
                object.valueInfo[valueKey] = customerInfo.occupationType;
                object.showingContentString = occupationTypeString;
            }
        }
        else if ([valueKey isEqualToString:@"individualGroupDesc"])
        {
            object.valueInfo[valueKey] = customerInfo.individualGroupDesc;
            object.showingContentString = customerInfo.individualGroupDesc;
        }
        else if ([valueKey isEqualToString:@"brandId"])
        {
            object.valueInfo[valueKey] = customerInfo.brandId;
            MFBrandInfo *brand =  [[MFLoginCenter sharedCenter].brandDict objectForKey:customerInfo.brandId];
            object.showingContentString = brand.brandName;
        }
        else if ([valueKey isEqualToString:@"maintainEntityId"])
        {
            object.showingContentString = customerInfo.maintainEntityName;
        }
        else if ([valueKey isEqualToString:@"maintainEmployeeName"])
        {
            object.showingContentString = customerInfo.maintainEmployeeName;
        }
        else if ([valueKey isEqualToString:@"weChat"])
        {
            object.valueInfo[valueKey] = customerInfo.weChat;
            object.showingContentString = customerInfo.weChat;
        }
        else if ([valueKey isEqualToString:@"email"])
        {
            object.valueInfo[valueKey] = customerInfo.email;
            object.showingContentString = customerInfo.email;
        }
        else if ([valueKey isEqualToString:@"oftenEnterOccation"])
        {
            object.valueInfo[valueKey] = customerInfo.oftenEnterOccation;
            object.showingContentString = [[MFCustomerInfoManager sharedManager] oftenEnterOccationDescForkey:customerInfo.oftenEnterOccation];
        }
        else if ([valueKey isEqualToString:@"address"])
        {
            object.valueInfo[valueKey] = customerInfo.address;
            object.showingContentString = customerInfo.address;
        }
        else if ([valueKey isEqualToString:@"oftenAccompanyPerson"])
        {
            object.valueInfo[valueKey] = customerInfo.oftenAccompanyPerson;
            object.showingContentString = [[MFCustomerInfoManager sharedManager] oftenAccompanyPersonDescForkey:customerInfo.oftenAccompanyPerson];
        }
        else if ([valueKey isEqualToString:@"customerMentality"])
        {
            object.valueInfo[valueKey] = customerInfo.customerMentality;
            object.showingContentString = [[MFCustomerInfoManager sharedManager] customerMentalityDescForkey:customerInfo.customerMentality];
        }
    }
    
    return array;
}


@end
