//
//  MFDateUtil.m
//  装扮灵
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDateUtil.h"

@implementation MFDateUtil

+ (NSString *)getYYYY_MM_DD_HH_mm_ss_SSS:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
    
}


+ (NSString *)getYYYY_MM_DD:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
    
}


+ (NSDate *)getDateYYYY_MM_DD:(NSString *)strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateTime = [formatter dateFromString:strDate];
    return dateTime;
    
}

@end
