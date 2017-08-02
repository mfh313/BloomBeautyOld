//
//  MFHTTPUtil.h
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

#define UnAuthStatus @"999"

typedef NSURLSessionDataTask AFHTTPRequestOperation;

@interface MFHTTPUtil : MFObject

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)POST_ToDict:(NSString *)URLString
         parameters:(id)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failureTips:(void (^)(NSString *tips))failureTips;


@end
