//
//  MFLoginCenter.h
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"
#import "LoginUserInfo.h"
#import "BBEmployeeInfo.h"
#import "CustomerInfo.h"

#define LoginNamekey @"BB_UserName"

typedef void(^loginBlock)(NSString *statusCode,NSString *message,BOOL success);

@interface MFLoginCenter : MFObject
{
    CustomerInfo *_currentCustomerInfo;
}

@property (nonatomic,strong) LoginUserInfo *loginInfo;

//记录系统 品牌信息
@property (nonatomic,strong) NSMutableDictionary *brandDict;

@property (nonatomic,strong) BBEmployeeInfo *currentShopingGuideInfo;

@property (nonatomic,strong) CustomerInfo *currentCustomerInfo;

+ (MFLoginCenter *)sharedCenter;

- (void)loginWith:(NSString *)name password:(NSString *)password Block:(loginBlock)block;

- (void)logout;

- (void)switchUser;


@end
