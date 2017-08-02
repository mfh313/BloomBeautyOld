//
//  MFUpdateCustomerApi.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/15.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFUpdateCustomerApi : MFNetworkRequest

@property (nonatomic,strong) NSString *individualNo;
@property (nonatomic,strong) NSMutableDictionary *editingInfoValues;

@end
