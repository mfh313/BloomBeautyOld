//
//  MFCustomerBodyMadeUpdateApi.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFCustomerBodyMadeUpdateApi : MFNetworkRequest

@property (nonatomic,strong) NSString *individualNo;
@property (nonatomic,strong) NSDictionary *updateKeyValues;

@end
