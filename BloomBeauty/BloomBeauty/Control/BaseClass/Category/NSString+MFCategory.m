//
//  NSString+MFCategory.m
//  BloomBeauty
//
//  Created by EEKA on 12/31/15.
//  Copyright © 2015 EEKA. All rights reserved.
//

#import "NSString+MFCategory.h"

@implementation NSString (MFCategory)

-(BOOL)MF_isNull
{
    return [CommonUtil isNull:self];
}

-(BOOL)MF_isNotNull
{
    return [CommonUtil isNotNull:self];
}

@end
