//
//  NSString+CustomerDiagnostic.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/19.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "NSString+CustomerDiagnostic.h"

@implementation NSNumber (CustomerDiagnostic)

-(NSString *)customerDiagnosticUrlString
{
    NSString *diaDiagnosticStr = [NSString stringWithFormat:@"%@",self];
    NSURL *url = [diaDiagnosticStr customerDiagnosticUrl];
    return [NSString stringWithFormat:@"%@",url];
}

-(NSURL *)customerDiagnosticUrl
{
    NSString *diaDiagnosticStr = [NSString stringWithFormat:@"%@",self];
    NSURL *url = [diaDiagnosticStr customerDiagnosticUrl];
    return url;
}

@end

@implementation NSString (CustomerDiagnostic)

-(NSURL *)customerDiagnosticUrl
{
    NSString *desStr = [[NSString stringWithFormat:@"%@",self] stringWithStrToDES];
    NSString *reportStr = MFCustomerDiagnosticlUrl(desStr);
    NSURL *reportUrl = [NSURL URLWithString:reportStr];
    return reportUrl;
}

@end
