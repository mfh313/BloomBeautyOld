//
//  NSDictionary+Unicode.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "NSDictionary+Unicode.h"

@implementation NSDictionary (Unicode)

- (NSString *)descriptionWithLocale:(nullable id)locale{
    
    NSString *logString;
    @try {
//注释也是一种方法
//        logString=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        NSString *desc = [self description];
        logString = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
        
    } @catch (NSException *exception) {
        
        NSString *reason = [NSString stringWithFormat:@"reason:%@",exception.reason];
        logString = [NSString stringWithFormat:@"转换失败:\n%@,\n转换终止,输出如下:\n%@",reason,self.description];
        
    } @finally {
        
    }
    return logString;
}

@end
