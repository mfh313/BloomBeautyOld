//
//  MFNetworkRequest.h
//  BloomBeauty
//
//  Created by EEKA on 16/10/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "YTKRequest.h"
#import "YTKBatchRequest.h"

@interface MFNetworkRequest : YTKRequest

+(void)startNetworkMonitoring;
+(void)stopNetworkMonitoring;
+(BOOL)networkReachable;

@end
