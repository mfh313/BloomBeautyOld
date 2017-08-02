//
//  MFQueryCustomerApi.h
//  BloomBeauty
//
//  Created by EEKA on 16/10/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFQueryCustomerApi : MFNetworkRequest

@property(nonatomic,strong) NSNumber *brandId;
@property(nonatomic,strong) NSString *searchKey;

@end
