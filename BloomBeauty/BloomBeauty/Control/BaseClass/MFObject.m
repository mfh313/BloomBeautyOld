//
//  MFObject.m
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

@implementation MFObject

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
