//
//  LoginUserInfo.m
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "LoginUserInfo.h"

@implementation LoginUserInfo

-(NSString *)description
{
    return [NSString stringWithFormat:@"entityBrandCode=%@,\nentityBrandId=%@,\nentityId=%@,\nentityName=%@,\nentitySubBrandId=%@,\nuserFullName=%@",self.entityBrandCode,self.entityBrandId,self.entityId,self.entityName,self.entitySubBrandId,self.userFullName];
}

@end


@implementation EntityBrandItemInfo



@end