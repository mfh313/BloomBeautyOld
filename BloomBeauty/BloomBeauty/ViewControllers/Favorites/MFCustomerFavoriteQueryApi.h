//
//  MFCustomerFavoriteQueryApi.h
//  BloomBeauty
//
//  Created by EEKA on 16/10/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFCustomerFavoriteQueryApi : MFNetworkRequest

@property (nonatomic,strong) NSString* individualNo;
@property (nonatomic,strong) NSString* commodityCode;

@end
