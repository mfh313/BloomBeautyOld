//
//  MFDateUtil.h
//  装扮灵
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFDateUtil : MFObject

+ (NSString *)getYYYY_MM_DD_HH_mm_ss_SSS:(NSDate *)date;

+ (NSString *)getYYYY_MM_DD:(NSDate *)date;


+ (NSDate *)getDateYYYY_MM_DD:(NSString *)strDate;
@end
