//
//  NSString+CustomerDiagnostic.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/19.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CustomerDiagnostic)

-(NSString *)customerDiagnosticUrlString;
-(NSURL *)customerDiagnosticUrl;

@end


@interface NSString (CustomerDiagnostic)

-(NSURL *)customerDiagnosticUrl;

@end
