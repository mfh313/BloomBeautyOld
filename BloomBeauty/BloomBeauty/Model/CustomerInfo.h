//
//  LoginUserInfo.h
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

typedef NS_ENUM(NSInteger, MFCustomerStatus) {
    MFCustomerStatusAdd = 0,
    MFCustomerStatusEdit = 1,
    MFCustomerStatusView = 2
};

extern NSString *const MFNotifiCurrentCustomerInfoChange;

@interface CustomerInfo : MFObject

@property (nonatomic,strong) NSNumber* brandId;//	品牌ID
@property (nonatomic,strong) NSString* phoneNumber;//	 手机号码
@property (nonatomic,strong) NSString* lastName;//	顾客姓
@property (nonatomic,strong) NSString* firstName;//	顾客名
@property (nonatomic,strong) NSNumber* yob;//	顾客生日年份
@property (nonatomic,strong) NSNumber* mob;//	顾客生日月份
@property (nonatomic,strong) NSNumber* dob;//	顾客生日天
@property (nonatomic,strong) NSNumber* maintainEmployeeId;//	维护员工ID
@property (nonatomic,strong) NSNumber* maintainEntityId;//	当前门店ID
@property (nonatomic,strong) NSString* isLunar;//	是否为农历，传Y/N
@property (nonatomic,strong) NSString* email;//	Email地址
@property (nonatomic,strong) NSString* weChat;//	微信号
@property (nonatomic,strong) NSString* address;//	详细地址
@property (nonatomic,strong) NSString* imageStreams;//	头像图片的二进制流
@property (nonatomic,strong) NSString* occupationType;//	职业
@property (nonatomic,strong) NSNumber* userId;//	门店登录返回的userId
@property (nonatomic,strong) NSString* regionCode;//	省份，门店登录时返回
@property (nonatomic,strong) NSString* cityCode;//	城市，门店登录时返回
@property (nonatomic,strong) NSString* zoneCode;//	城市，门店登录时返回
@property (nonatomic,strong) NSString* oftenEnterOccation;
@property (nonatomic,strong) NSString* oftenAccompanyPerson;
@property (nonatomic,strong) NSString* customerMentality;
@property (nonatomic,strong) NSString* searchKey;//	 手机号码
@property (nonatomic,strong) NSString* individualNo;//唯一id
@property (nonatomic,strong) NSString* individualName;//
@property (nonatomic,strong) NSString* company;//
@property (nonatomic,strong) NSString* diagnosisDate;//
@property (nonatomic,strong) NSString* individualGroupDesc;//
@property (nonatomic,strong) NSString* isDiagnosis;//
@property (nonatomic,strong) NSString* maintainEmployeeName;//
@property (nonatomic,strong) NSString* maintainEntityName;//
@property (nonatomic,strong) NSString* portraitUrl;//
@property (nonatomic,strong) NSString* sizeCode;//
@property (nonatomic,strong) NSString* portraitUpdateDate;//
@property (nonatomic,strong) NSNumber* lastDiagnosisResultId;//最后一次诊断的记录

//不关联接口 只关联界面
@property (nonatomic,strong) NSString* sex;//
@property (nonatomic,strong) NSString* brithday;//
@property (nonatomic,strong) NSMutableArray* favoriteArray;//

-(NSString*)getImgNameByDate:(NSString*)date;
-(NSString*)getImgNameByPortraitUpdateDate;
-(NSString*)getStrIsDiagnosis;
-(void)getLastOneDiagnosticRecord;
-(id)initInfo;
-(id)getFullName;
-(void)queryFavorites;
-(void)addFavoriteItemStyleColor:(NSString *)itemStyleColor;
-(void)removeFavoriteItemStyleColor:(NSString *)itemStyleColor;

@end

#pragma mark - MF_isDiagnosis
@interface NSString (MF_isDiagnosis)

-(BOOL)MF_isDiagnosis;

@end


#pragma mark - CustomerFavoriteCommodityItem
@interface CustomerFavoriteCommodityItem : MFObject

@property (nonatomic,strong) NSString *itemStyleColor;
@property (nonatomic,strong) NSString *smallItemUrl;
@property (nonatomic,strong) NSString *originalItemUrl;

@end

