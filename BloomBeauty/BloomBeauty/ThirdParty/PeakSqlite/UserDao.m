//
//  PeakSqlite.m
//  PeakSqlite-Samples
//
//  Created by conis on 8/21/13.
//  Copyright (c) 2013 conis. All rights reserved.
//


#import "UserDao.h"

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
    
    //给表名赋值
    self.peakSqlite.tableName = @"t_loginUserInfo";
    
    //字段列表
    self.peakSqlite.fields = @[ @"userId", @"entityBrandCode", @"entityBrandId", @"entityId", @"entitySubBrandId"
                     , @"entityName", @"userFullName", @"regionCode", @"cityCode"
                     ];
    //主键的ID
    self.peakSqlite.primaryField = @"userId";
    self.peakSqlite.database = [MFDatabaseUtil sharedManager].database;
    [self.peakSqlite.database open];
//    [self.peakSqlite.database executeUpdate:@"drop table todolist"];
    [self.peakSqlite.database executeUpdate: [self sqlForCreateTable]];
    [self.peakSqlite.database close];
}

//获取所有字段存到数据库的值
-(NSArray *) parameters{
    return @[
             [PeakSqlite nilFilter: self.entity.entityBrandCode],
             self.entity.entityBrandId,
             [PeakSqlite nilFilter:self.entity.entityId],
             self.entity.entitySubBrandId,
             [PeakSqlite nilFilter: self.entity.entityName],
             [PeakSqlite nilFilter: self.entity.userFullName],
             [PeakSqlite nilFilter: self.entity.regionCode],
             [PeakSqlite nilFilter: self.entity.cityCode],
             self.entity.userId,
             ];

}

-(int)insert:(LoginUserInfo*)entity
{
    self.entity = entity;
    return [super insert];
}
-(int)update:(LoginUserInfo*)entity
{
    self.entity = entity;
    return [super update];
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

-(LoginUserInfo*) findOneWithPrimaryId:(NSInteger )dbId
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
//创建数据库的sql语句
- (NSString *) sqlForCreateTable{
    //注意，日期类型在sqlite中不支持，所以日期类型会被转换为float类型
    NSMutableString *str =[[NSMutableString alloc]init];
    [str appendString:@"CREATE TABLE if not exists %@("];
    [str appendString:@"userId INTEGER NOT NULL PRIMARY KEY ,"];
    [str appendString:@"entityBrandCode TEXT ,"];
    [str appendString:@"entityBrandId INTEGER ,"];
    [str appendString:@"entityId INTEGER ,"];
    [str appendString:@"entitySubBrandId INTEGER ,"];
    [str appendString:@"entityName TEXT ,"];
    [str appendString:@"userFullName TEXT ,"];
    [str appendString:@"regionCode TEXT ,"];
    [str appendString:@"cityCode TEXT "];
    [str appendString:@" )"];
    NSString *last = [NSString stringWithFormat:str,self.peakSqlite.tableName];
    return last;
}
@end
