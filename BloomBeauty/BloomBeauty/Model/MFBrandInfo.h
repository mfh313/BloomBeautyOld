//
//  MFBrandInfo.h
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFBrandInfo : MFObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *enName;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *imageName;
//接口关联
@property (nonatomic,strong) NSString *brandCode;
@property (nonatomic,strong) NSNumber *brandId;
@property (nonatomic,strong) NSString *brandName;
@property (nonatomic,strong) NSNumber *parentBrandId;

@end
