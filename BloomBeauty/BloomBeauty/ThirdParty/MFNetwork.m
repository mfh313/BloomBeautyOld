//
//  MFNetwork.m
//  YJCustom
//
//  Created by EEKA on 16/9/21.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetwork.h"
#import "HYBNetworking.h"
#import "MFNetworkRequest.h"

@implementation MFNetwork

+(BOOL)useHYBNetworking
{
    return YES;
}

+(void)makeConfigNetwork
{
    if (![[self class] useHYBNetworking]) {
        return;
    }
    
//    [HYBNetworking updateBaseUrl:@"http://apistore.baidu.com"];
    [HYBNetworking enableInterfaceDebug:YES];
    
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [HYBNetworking configRequestType:kHYBRequestTypePlainText
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    
    /*
     [HYBNetworking.m：in line: 189]-->[message:
     absoluteUrl: http://apistore.baidu.com/microservice/cityinfo?cityname=%E5%8C%97%E4%BA%AC
     params:(null)
     response:{
     errNum = 0;
     retData =     {
     cityCode = 101010100;
     cityName = "\U5317\U4eac";
     provinceName = "\U5317\U4eac";
     telAreaCode = 010;
     zipCode = 100000;
     };
     retMsg = success;
     }
     ]
     */
    
    // 设置GET、POST请求都缓存
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
}

+ (MFURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(MFResponseSuccess)success
                             fail:(MFResponseFail)fail
{
    return [[self class] postWithUrl:url
                        refreshCache:YES
                              params:params
                             success:success
                                fail:fail];
}

+ (MFURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                           success:(MFResponseSuccess)success
                              fail:(MFResponseFail)fail
{
    return [HYBNetworking postWithUrl:url
                         refreshCache:refreshCache
                               params:params
                              success:success
                                 fail:fail];
}

//用法1
//    NSString *loginUrl = @"http://120.76.242.182/dekora_api/o2o/joylaa/login/memberLogin";
//
//    NSDictionary *parameters = @{@"isCode":@"joylaa",
//                                 @"userKey":@"joylaa",
//                                 @"userPswd":@"111111"};
//
//    __weak typeof(self) weakSelf = self;
//    [MFNetwork postWithUrl:loginUrl params:parameters success:^(id response) {
//
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf onFisrtLoginSuccess];
//
//    } fail:^(NSError *error) {
//
//    }];

//用法2
//    [[AFHTTPSessionManager manager] POST:loginUrl
//                              parameters:parameters
//                                progress:^(NSProgress * uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * task, id  responseObject) {
//        NSLog(@"responseObject=%@",responseObject);
//        [self onFisrtLoginSuccess];
//
//    } failure:^(NSURLSessionDataTask * task, NSError *  error) {
//        NSLog(@"error=%@",error.localizedDescription);
//    }];

//用法3
//    NSString *loginUrl = @"http://120.76.242.182/dekora_api/o2o/joylaa/login/memberLogin";
//
//    NSDictionary *parameters = @{@"isCode":@"joylaa",
//                                 @"userKey":@"joylaa",
//                                 @"userPswd":@"111111"};
//
//    __weak typeof(self) weakSelf = self;
//    [MFNetwork postWithUrl:loginUrl params:parameters success:^(id response) {
//
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf onFisrtLoginSuccess];
//
//    } fail:^(NSError *error) {
//
//    }];
//    return;

@end
