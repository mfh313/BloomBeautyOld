//
//  MFSalingProdouctQueryApi.h
//  BloomBeauty
//
//  Created by EEKA on 2016/11/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFSalingProdouctQueryApi : MFNetworkRequest

@property (nonatomic,copy) NSString *entityId;
@property (nonatomic,copy) NSString *occasions;
@property (nonatomic,copy) NSString *categoryCode;

@end
