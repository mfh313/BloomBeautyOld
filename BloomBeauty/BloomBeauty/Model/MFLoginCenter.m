//
//  MFLoginCenter.m
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFLoginCenter.h"
#import "MFBrandInfo.h"
#import "DiagnosisResult.h"
@implementation MFLoginCenter
@synthesize loginInfo;

+ (MFLoginCenter *)sharedCenter
{
    static MFLoginCenter *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(void)setCurrentCustomerInfo:(CustomerInfo *)currentCustomerInfo
{
    _currentCustomerInfo = currentCustomerInfo;
    [currentCustomerInfo getLastOneDiagnosticRecord];//同时查询最后一次诊断的id
    [currentCustomerInfo queryFavorites];//查询当前关联的 收藏信息
    [[NSNotificationCenter defaultCenter] postNotificationName:MFNotifiCurrentCustomerInfoChange object:self userInfo:nil];
}


-(CustomerInfo*)currentCustomerInfo
{
    return  _currentCustomerInfo;
}

-(void)loginWith:(NSString *)name password:(NSString *)password Block:(loginBlock)block
{
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
#ifdef DEBUG
    if ([CommonUtil isNull:name] && [CommonUtil isNull:password]) {
        name = @"P10198";
        password = @"eeka2012";
    }
#else
     
#endif
    NSDictionary *parameters = @{@"userName": name,
                                @"userPasswd": password,
                                @"token": token
                                }; 
    [MFHTTPUtil POST:MFApiCheckUserURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *str = [responseObject objectForKey:@"statusCode"];
         NSString *message = [responseObject objectForKey:@"message"];
         
         self.loginInfo = [LoginUserInfo objectWithKeyValues:responseObject];
         self.loginInfo.userName = name;
         
         NSMutableArray *collectionEntitysArray = [NSMutableArray array];
         
         self.loginInfo.collectionEntitys = collectionEntitysArray;
         if ([responseObject[@"collectionEntitys"] isKindOfClass:[NSArray class]]) {
             NSArray *collectionEntitys = responseObject[@"collectionEntitys"];
             for (int i = 0; i < collectionEntitys.count; i++) {
                 NSDictionary *collectionEntitysItem = collectionEntitys[i];
                 EntityBrandItemInfo *item = [EntityBrandItemInfo objectWithKeyValues:collectionEntitysItem];
                 [collectionEntitysArray addObject:item];
             }
         }
         [self loadBrandDict];
         [[ImageSanBoxUtil sharedUtil] setCurrentUserDir:[self getLoginUserSanboxDir]];
         
         [[NSUserDefaults standardUserDefaults] setValue:name forKey:LoginNamekey];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         if ([str isEqualToString:@"200"]) {
             block(str,message,YES);
         }
         else
         {
             block(str,message,NO);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          block(nil,error.localizedFailureReason,NO);
     }];
}


-(void)loadBrandDict
{
    NSString *token = BloomBeautyToken;
    NSDictionary *parameters = @{
                                 @"token": token
                                 };
    [MFHTTPUtil POST_ToDict:MFApiQueryBrandURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arry = [responseObject objectForKey:@"brandInfo"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (id obj in arry) {
            MFBrandInfo *jsonObj = [MFBrandInfo objectWithKeyValues:obj];
            [dict setObject:jsonObj forKey:jsonObj.brandId];
        }
        self.brandDict = dict;
    } failureTips:^(NSString *tips) {
        
    }];
}



-(NSString*)getLoginUserSanboxDir
{
    if(self.loginInfo!= nil && self.loginInfo.userId != nil)
    {
        NSString *dir = [self.loginInfo.userId stringValue];
        return dir;
    }
    return nil;
}

-(void)logout
{
    self.currentCustomerInfo = nil;
    self.currentShopingGuideInfo = nil;
    self.brandDict = nil;
}

-(void)switchUser
{
    self.currentCustomerInfo = nil;
    self.currentShopingGuideInfo = nil;
}

@end
