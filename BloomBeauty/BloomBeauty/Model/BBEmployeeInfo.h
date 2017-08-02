//
//  BBEmployeeInfo.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/7.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface BBEmployeeInfo : MFObject

@property (nonatomic,strong) NSNumber *employState;
@property (nonatomic,strong) NSString *employeeCode;
@property (nonatomic,strong) NSString *employeeId;
@property (nonatomic,strong) NSString *employeeName;
@property (nonatomic,strong) NSString *entityId;
@property (nonatomic,strong) NSString *entryDate;
@property (nonatomic,strong) NSString *jobTitleCode;

@end
