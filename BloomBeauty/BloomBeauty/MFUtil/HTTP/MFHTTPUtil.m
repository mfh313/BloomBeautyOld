//
//  MFHTTPUtil.m
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFHTTPUtil.h"
#import "AFNetworking.h"

@implementation MFHTTPUtil
+(id)fixParameters:(id)parameters token:(NSString *)token
{
    NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if ([newdic.allKeys containsObject:@"token"]) {
        newdic[@"token"] = token;
    }
    return newdic;
}

+ (void)fixUnAuthPOST:(NSString *)URLString
     parameters:(id)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    __block id newParameters = parameters;
    [MFApiUtil getNewToken:^(NSString *token) {
        
        newParameters = [[self class] fixParameters:parameters token:token];
        [self POST:URLString
                parameters:newParameters
                   success:success
                   failure:failure];
    }];
    
}

+ (void)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [[AFHTTPSessionManager manager] POST:URLString
                              parameters:parameters
                                progress:^(NSProgress * uploadProgress) {

    } success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        if ([responseObject[@"statusCode"] isKindOfClass:[NSString class]]
            && [responseObject[@"statusCode"] isEqualToString:UnAuthStatus])
        {
            NSLog(@"getNewToken");
            [self fixUnAuthPOST:URLString parameters:parameters success:success failure:failure];
            return;
        }
        
        success(task,responseObject);

    } failure:^(NSURLSessionDataTask * task, NSError *  error) {
        
        failure(task,error);
        
    }];
}

+ (void)POST_ToDict:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failureTips:(void (^)(NSString *tips))failureTips
{
    [self POST:URLString
    parameters:parameters
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
           if ([responseObject[@"statusCode"] isEqualToString:@"200"]) {
               success(operation,responseObject);
           }
           else
           {
               failureTips(responseObject[@"message"]);
           }
           
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureTips([error localizedDescription]);
    }];
}

@end
