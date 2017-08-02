//
//  MFGetCitiesApi.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFGetCitiesApi : MFNetworkRequest

@property (nonatomic,strong) NSString *regionCode;

@end
