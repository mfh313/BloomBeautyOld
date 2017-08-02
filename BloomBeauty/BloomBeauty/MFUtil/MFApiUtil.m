//
//  MFApiUtil.m
//  BloomBeauty
//
//  Created by Administrator on 15/11/6.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#define TestMFWebUrL @"http://115.159.94.69:6080/BloomBeautyAPI/"  //测试地址
#define TestMFCustomerDiagnosticlUrl(reportID) \
                                                [NSString stringWithFormat:@"http://bloombeautyreport.eeka.info:6180/BloomBeauty/report/customerRpt_sendRtp?customerRptID=%@",reportID]

#define MFCloudWebUrL @"http://115.159.94.69:8080/BloomBeautyAPI/"   //云服务地址
#define MFCloudCustomerDiagnosticlUrl(reportID) \
                                                [NSString stringWithFormat:@"http://bloombeautyreport.eeka.info:7080/BloomBeauty/report/customerRpt_sendRtp?customerRptID=%@",reportID]

#import "MFApiUtil.h"
#import "MFNetworkRequest.h"
#import "AFNetworking.h"

@interface MFApiUtil ()
{
    MFApiUtilTokenGetBlock _tokenBlock;
}

@end

@implementation MFApiUtil
@synthesize token;

+(NSString*)getPackageDesc
{
    if ([self packageTest]) {
        return @"测试环境";
    }
    
    return @"正式环境";
}

+(NSString*)getMFURL
{
    if ([self packageTest]) {
        return TestMFWebUrL;
    }
    
    return MFCloudWebUrL;
}

+(BOOL)packageTest
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *value = infoDictionary[@"BloomBeautyMakePackageTest"];
    
    if (value.boolValue) {
        return YES;
    }
    
    return NO;
}

+(NSString*)customerDiagnosticlUrl:(NSString *)reportID
{
    if ([self packageTest]) {
        return TestMFCustomerDiagnosticlUrl(reportID);
    }
    
    return MFCloudCustomerDiagnosticlUrl(reportID);
}

+ (MFApiUtil *)sharedUtil
{
    static MFApiUtil *sharedObject = nil;
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
        [MFNetwork makeConfigNetwork];
        [MFNetworkRequest startNetworkMonitoring];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status != AFNetworkReachabilityStatusNotReachable)
            {
                if (!token)
                {
                    NSLog(@"网络已连接,重新获取token");
                    [self token];
                }
            }
        }];
    }
    
    return self;
}

-(NSString *)token
{
    if (token) {
        return token;
    }
    
    NSString *name = @"testUser";
    NSString *ePassWord = @"kU+2XYV9Dc6FN/ehZIX8yQ==";
    NSString *loginTime = [MFDateUtil getYYYY_MM_DD_HH_mm_ss_SSS:[NSDate date]];
    NSString *loginKey = [[NSString stringWithFormat:@"%@&%@&%@",name,ePassWord,loginTime] stringWithStrToDES];
    
    NSDictionary *parameters = @{@"name": name,
                                 @"password": ePassWord,
                                 @"loginTime": loginTime,
                                 @"loginKey": loginKey
                                 };
    [MFHTTPUtil POST:MFApiLoginURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         token = [responseObject objectForKey:@"token"];
         if (token && _tokenBlock) {
             _tokenBlock(token);
             _tokenBlock = nil;
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if ([MFNetworkRequest networkReachable])
         {
             NSLog(@"networkReachable getToken");
             [self token];
         }
     }];
    
    return token;
}

+(void)getNewToken:(MFApiUtilTokenGetBlock)tokenBlock
{
    [[self sharedUtil] getNewToken:tokenBlock];
}

-(void)getNewToken:(MFApiUtilTokenGetBlock)tokenBlock
{
    if (token) {
        token = nil;
    }
    
    _tokenBlock = [tokenBlock copy];
    [self token];
}

@end
