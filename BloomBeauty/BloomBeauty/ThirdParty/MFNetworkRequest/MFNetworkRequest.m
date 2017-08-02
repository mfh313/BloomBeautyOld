//
//  MFNetworkRequest.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"
#import "AFNetworking.h"

#ifdef DEBUG
#define MFAppLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define MFAppLog(s, ... )
#endif

@implementation MFNetworkRequest

-(void)requestCompleteFilter
{
#ifdef DEBUG
    NSString *url = [self toPrintUrl];
    
    [[self class] logWithSuccessResponse:self.responseData url:url params:self.requestArgument];
    
#else
    
#endif
    
}

-(NSString *)toPrintUrl
{
    if (![self.baseUrl isEqualToString:@""]) {
        return self.baseUrl;
    }
    else if (![self.requestUrl isEqualToString:@""])
    {
        return self.requestUrl;
    }
    
    return self.cdnUrl;
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    MFAppLog(@"\n");
    MFAppLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
             [self generateGETAbsoluteURL:url params:params],
             params,
             [self tryToParseData:response]);
}

+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}


// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

-(void)requestFailedFilter
{
#ifdef DEBUG
    NSString *url = [self toPrintUrl];
    
    [[self class] logWithFailError:self.error url:url params:self.requestArgument];
    
#else
    
#endif
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    MFAppLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        MFAppLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
                 [self generateGETAbsoluteURL:url params:params],
                 format,
                 params);
    } else {
        MFAppLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
                 [self generateGETAbsoluteURL:url params:params],
                 format,
                 params,
                 [error localizedDescription]);
    }
}

+(void)startNetworkMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+(void)stopNetworkMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+(BOOL)networkReachable
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

@end
