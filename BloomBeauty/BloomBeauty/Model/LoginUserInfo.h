//
//  LoginUserInfo.h
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"


@interface LoginUserInfo : MFObject

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *entityBrandCode;
@property (nonatomic,strong) NSString *brandPictureUrl;
@property (nonatomic,strong) NSNumber *entityBrandId;
@property (nonatomic,strong) NSNumber *entityId;
@property (nonatomic,strong) NSNumber *entitySubBrandId;
@property (nonatomic,strong) NSString *entityName;
@property (nonatomic,strong) NSString *userFullName;
@property (nonatomic,strong) NSArray *collectionEntitys;
@property (nonatomic,strong) NSString *regionCode;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *zoneCode;
@property (nonatomic,strong) NSNumber *userId;

@end

#pragma mark - EntityBrandInfo
@interface EntityBrandItemInfo : MFObject
@property (nonatomic,strong) NSNumber *entityId;
@property (nonatomic,strong) NSNumber *entityBrandId;
@property (nonatomic,copy)   NSString *entityBrandName;
@property (nonatomic,copy)   NSString *brandChineseName;
@property (nonatomic,copy)   NSString *brandEnglishName;
@end


