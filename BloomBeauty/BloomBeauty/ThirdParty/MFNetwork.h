//
//  MFNetwork.h
//  YJCustom
//
//  Created by EEKA on 16/9/21.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>


//使用HYBNetworking
//仿YTKNetwork
typedef NSURLSessionTask MFURLSessionTask;
typedef void(^MFResponseSuccess)(id response);
typedef void(^MFResponseFail)(NSError *error);

@interface MFNetwork : NSObject

+(void)makeConfigNetwork;

+ (MFURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(MFResponseSuccess)success
                             fail:(MFResponseFail)fail;

@end
