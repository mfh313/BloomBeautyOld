//
//  MFQueryAvailableSizeApi.h
//  BloomBeauty
//
//  Created by EEKA on 2016/11/14.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFQueryAvailableSizeApi : MFNetworkRequest

@property (nonatomic,strong) NSString *entityId;
@property (nonatomic,strong) NSString *commodityCode;


@end
