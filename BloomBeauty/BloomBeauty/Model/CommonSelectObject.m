//
//  LoginUserInfo.m
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "CommonSelectObject.h"

@implementation CommonSelectObject

-(id) initInfo
{
    self = [super init] ;
    if ( self ) {
        self.name = @"";
        self.value = @"";
        self.name = @"";
    }
    return self ;
}
-(id) initInfo:(NSString*)name value:(NSString*)value
{
    self = [super init] ;
    if ( self ) {
        self.name = name;
        self.value = value;
    }
    return self ;
}
@end
