//
//  PeakSqlite.m
//  PeakSqlite-Samples
//
//  Created by conis on 8/21/13.
//  Copyright (c) 2013 conis. All rights reserved.
//


#import "CustomerDao.h"
#import "STDbHandle.h"
#import "CustomerInfo.h"


@implementation CustomerDao

+ (CustomerDao *)sharedManager
{
    static CustomerDao *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        [sharedObject setAll];
    });
    
    return sharedObject;
}

-(void) setAll{
    self.tableClass = CustomerInfo.class;
    //主键的ID
    self.peakSqlite.primaryField = @"individualNo";
    self.peakSqlite.primaryIdType = @"text";//DBText 
    self.peakSqlite.isAutoIncrement = NO;
    [super setAll];
    
}
-(NSArray *) findAllObjWithOrderBy: (NSString *) orderBy
{
    NSArray *result = [self.peakSqlite findAllWithOrderBy:orderBy];
    NSMutableArray *arry = [[NSMutableArray alloc]init];
    for (id obj in result) {
        CustomerInfo *entity = [CustomerInfo objectWithKeyValues:obj];
        [arry addObject:entity];
    }
    return arry;
}

-(CustomerInfo*) findOneWithPrimaryId:(NSString *)dbId
{
    BOOL result = [ self.peakSqlite findOneWithPrimaryId:dbId];
    if(result)
    {
        CustomerInfo *entity = [CustomerInfo objectWithKeyValues:self.peakSqlite.data];
        return entity;
    }
    return nil;
}

-(CustomerInfo*) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy{
    
    BOOL result = [ self.peakSqlite findOneWithCondition:cond parameters:params orderBy:orderBy];
    if(result)
    {
        CustomerInfo *entity = [CustomerInfo objectWithKeyValues:self.peakSqlite.data];
        return entity;
    }
    return nil;
}


//更新数据
-(BOOL)updatePortrait:(CustomerInfo *)dbObj{
     NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET  imageStreams = '%@' WHERE %@ = ?",self.peakSqlite.tableName,dbObj.imageStreams,self.peakSqlite.primaryField];
    //  NSString *sql = @"UPDATE todolist SET todo = ?, timestamp = ?, done = ?, testVal = ? WHERE id = ?";
    [self.peakSqlite.database open];
    NSMutableArray *arry =   [[NSMutableArray alloc]init];
    [arry addObject:dbObj.individualNo];
    BOOL result = [self.peakSqlite.database executeUpdate:updateSql withArgumentsInArray:arry];
    [self.peakSqlite.database close];
    return result;
}

@end
