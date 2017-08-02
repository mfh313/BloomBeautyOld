//
//  PeakSqlite.m
//  PeakSqlite-Samples
//
//  Created by conis on 8/21/13.
//  Copyright (c) 2013 conis. All rights reserved.
//


#import "UserDao.h"
#import "STDbHandle.h"
#import "LoginUserInfo.h"


@implementation UserDao

+ (UserDao *)sharedManager
{
    static UserDao *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        [sharedObject setAll];
    });
    
    return sharedObject;
}

-(void) setAll{
    self.tableClass = LoginUserInfo.class;
    //主键的ID
    self.peakSqlite.primaryField = @"userId";
    self.peakSqlite.primaryIdType = @"integer";
    self.peakSqlite.isAutoIncrement = NO;

    [super setAll];
    
} 
-(NSArray *) findAllObjWithOrderBy: (NSString *) orderBy
{
    NSArray *result = [self.peakSqlite findAllWithOrderBy:orderBy];
    NSMutableArray *arry = [[NSMutableArray alloc]init];
    for (id obj in result) {
        LoginUserInfo *entity = [LoginUserInfo objectWithKeyValues:obj];
        [arry addObject:entity];
    }
    return arry;
}

-(LoginUserInfo*) findOneWithPrimaryId:(NSString *)dbId
{
    BOOL result = [ self.peakSqlite findOneWithPrimaryId:dbId];
    if(result)
    {
        LoginUserInfo *entity = [LoginUserInfo objectWithKeyValues:self.peakSqlite.data];
        return entity;
    }
    return nil;
}

-(LoginUserInfo*) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy{
    
    BOOL result = [ self.peakSqlite findOneWithCondition:cond parameters:params orderBy:orderBy];
    if(result)
    {
        LoginUserInfo *entity = [LoginUserInfo objectWithKeyValues:self.peakSqlite.data];
        return entity;
    }
    return nil;
}

@end
