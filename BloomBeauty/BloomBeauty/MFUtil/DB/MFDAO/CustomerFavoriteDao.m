//
//  PeakSqlite.m
//  PeakSqlite-Samples
//
//  Created by conis on 8/21/13.
//  Copyright (c) 2013 conis. All rights reserved.
//


#import "CustomerFavoriteDao.h"
#import "STDbHandle.h"
#import "CustomerFavorite.h"


@implementation CustomerFavoriteDao

+ (CustomerFavoriteDao *)sharedManager
{
    static CustomerFavoriteDao *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        [sharedObject setAll];
    });
    
    return sharedObject;
}

-(void) setAll{
    self.tableClass = CustomerFavorite.class;
    //主键的ID
    self.peakSqlite.primaryField = @"ID";
    self.peakSqlite.primaryIdType = @"integer";
    self.peakSqlite.isAutoIncrement = YES;
    [super setAll];
    
} 
-(NSArray *) findAllObjWithOrderBy: (NSString *) orderBy
{
    NSArray *result = [self.peakSqlite findAllWithOrderBy:orderBy];
    NSMutableArray *arry = [[NSMutableArray alloc]init];
    for (id obj in result) {
        CustomerFavorite *entity = [CustomerFavorite objectWithKeyValues:obj];
        [arry addObject:entity];
    }
    return arry;
}


-(NSArray *)findAllCodeByCon: (NSString *) sqlCon
{
    NSArray *result = [self.peakSqlite findWithCondition:sqlCon parameters:nil orderBy:nil];
    NSMutableArray *arry = [[NSMutableArray alloc]init];
    for (id obj in result) {
        CustomerFavorite *entity = [CustomerFavorite objectWithKeyValues:obj];
        [arry addObject:entity.favoriteCommodity];
    }
    return arry;
}

-(CustomerFavorite*) findOneWithPrimaryId:(NSString *)dbId
{
    BOOL result = [ self.peakSqlite findOneWithPrimaryId:dbId];
    if(result)
    {
        CustomerFavorite *entity = [CustomerFavorite objectWithKeyValues:self.peakSqlite.data];
        return entity;
    }
    return nil;
}

-(CustomerFavorite*) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy{
    
    BOOL result = [ self.peakSqlite findOneWithCondition:cond parameters:params orderBy:orderBy];
    if(result)
    {
        CustomerFavorite *entity = [CustomerFavorite objectWithKeyValues:self.peakSqlite.data];
        return entity;
    }
    return nil;
}

@end
