//
//  PeakSqlite.m
//  PeakSqlite-Samples
//
//  Created by conis on 8/21/13.
//  Copyright (c) 2013 conis. All rights reserved.
//


#import "PeakSqliteDao.h"

@implementation PeakSqliteDao

-(id) init{
    self = [super init];
    if(self){
        self.peakSqlite = [[PeakSqlite alloc]init];
    }
    return self;
}

-(void) setAll{
    //给表名赋值
    self.peakSqlite.tableName = NSStringFromClass(self.tableClass);//@"t_loginUserInfo";
    self.peakSqlite.database = [MFDatabaseUtil sharedManager].database;
    [self.peakSqlite.database open];
    [self.peakSqlite.database executeUpdate:  [self sqlForCreateTable]];
    [self.peakSqlite.database close];
    NSMutableArray *propertyKeyList = [NSMutableArray array];
    [STDbHandle class:self.tableClass getPropertyKeyList:propertyKeyList];
    //字段列表
    self.peakSqlite.fields = propertyKeyList;
}

-(NSString*)getInsertFields
{
    NSString *lastRet = @"";
    NSMutableString *fieldKeys = [[NSMutableString alloc]init];
    for (NSString *field in self.peakSqlite.fields) {
        if([field isEqualToString:self.peakSqlite.primaryField])//忽略主建
        {
            continue;
        }else
        {
            [fieldKeys appendFormat:@",%@",field];
        }
    }
    if(fieldKeys.length > 0)
    {
        lastRet = [fieldKeys substringFromIndex:1];
    }
    return lastRet;
}

-(NSString*)getInsertValues
{
    NSString *lastRet = @"";
    NSMutableString *fieldKeys = [[NSMutableString alloc]init];
    for (NSString *field in self.peakSqlite.fields) {
        if([field isEqualToString:self.peakSqlite.primaryField])//忽略主建
        {
            continue;
        }else
        {
            [fieldKeys appendFormat:@",?"];
        }
    }
    if(fieldKeys.length > 0)
    {
        lastRet = [fieldKeys substringFromIndex:1];
    }
    return lastRet;
} 

//插入数据
-(int)insert{
  NSString *insertFields =  [self getInsertFields];
  NSString *insertValues =  [self getInsertValues];
  //没有指定ID
    if(self.peakSqlite.isAutoIncrement)
    {
    
    }else
    {
        insertFields = [insertFields stringByAppendingFormat:@", %@", self.peakSqlite.primaryField];
        insertValues = [insertValues stringByAppendingString: @", ?"];
    }
  NSString *sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (%@)",self.peakSqlite.tableName, insertFields, insertValues];
  return [self.peakSqlite insertWithSql:sql parameters: [self parameters]];
}

-(int)insert:(id)dbObj
{
    self.dbObj = dbObj;
    return [self insert];
}
-(int)update:(id)dbObj
{
    self.dbObj = dbObj;
    return [self update];
}


-(int)insertOrUpdate:(id)dbObj
{
    self.dbObj = dbObj;
    NSString *numberId =  (NSString*)[dbObj valueForKey:self.peakSqlite.primaryField];
//    int objId = [numberId integerValue];
    BOOL bol =  [self.peakSqlite findOneWithPrimaryId:numberId];
    if(bol > 0)
    {
        return [self update:dbObj];
    }else
    {
        return [self insert:dbObj];
    }
} 

-(NSString*)getUpdateInfoSql
{
    NSString *lastRet = @"";
    NSMutableString *fieldKeys = [[NSMutableString alloc]init];
    for (NSString *field in self.peakSqlite.fields) {
        if([field isEqualToString:self.peakSqlite.primaryField])//忽略主建
        {
            continue;
        }else
        {
            [fieldKeys appendFormat:@",%@ = ? ",field];
        }
    }
    if(fieldKeys.length > 0)
    {
        lastRet = [fieldKeys substringFromIndex:1];
    }
    return lastRet;
}
//更新数据
-(BOOL)update{
    NSString *updateInfoSql =  [self getUpdateInfoSql];//@"todo, timestamp, done, testVal";
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET  %@ WHERE %@ = ?",self.peakSqlite.tableName,updateInfoSql,self.peakSqlite.primaryField];
//  NSString *sql = @"UPDATE todolist SET todo = ?, timestamp = ?, done = ?, testVal = ? WHERE id = ?";
  [self.peakSqlite.database open];
  BOOL result = [self.peakSqlite.database executeUpdate:updateSql withArgumentsInArray: [self parameters]];
  [self.peakSqlite.database close];
  return result;
}
//删除数据
-(BOOL)deleteByCon:(NSString*)sqlCon parameters:(NSArray *)parameters{
    return [self.peakSqlite deleteWithCondition:sqlCon parameters:parameters];
}


//创建数据库的sql语句
- (NSString *)sqlForCreateTable{
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"create table "];
    [sql appendString:NSStringFromClass(self.tableClass)];
    [sql appendString:@"("];
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    [STDbHandle class:self.tableClass getPropertyNameList:propertyArr primaryKey:self.peakSqlite.primaryField primaryIdType:self.peakSqlite.primaryIdType isAutoIncrement:self.peakSqlite.isAutoIncrement];
    NSString *propertyStr = [propertyArr componentsJoinedByString:@","];
    [sql appendString:propertyStr];
    [sql appendString:@");"];
    return sql;
}

-(NSArray *) parameters{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in  self.peakSqlite.fields ) {
        id obj =   [self.dbObj valueForKey:key ];
        if([key isEqualToString:self.peakSqlite.primaryField])//忽略主建
        {
            continue;
        }else
        {
            if(obj != nil)
            {
                [array addObject:obj];
            }else
            {
                [array addObject:[NSNull null]];
            }
        }
    }
    
    //最后再添加 id
    id objKey =   [self.dbObj valueForKey:self.peakSqlite.primaryField ];
    if(objKey != nil)
    {
        [array addObject:objKey];
    }else
    {
        [array addObject:[NSNull null]];
    }
    return array;
}

@end
