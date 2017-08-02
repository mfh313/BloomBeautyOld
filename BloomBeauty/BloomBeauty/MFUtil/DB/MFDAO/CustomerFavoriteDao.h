//
//  PeakSqlite.h
//  PeakSqlite-Samples
//
//  Created by conis on 8/21/13.
//  Copyright (c) 2013 conis. All rights reserved.
//
/*
 Entity实体的示例，供参考用，不必复制此类
 */

#import <Foundation/Foundation.h>
#import "PeakSqliteDao.h"
#import "CustomerFavorite.h"
@interface CustomerFavoriteDao  : PeakSqliteDao

@property (nonatomic, strong) CustomerFavorite *entity;

+ (CustomerFavoriteDao *)sharedManager;
-(NSArray *) findAllObjWithOrderBy: (NSString *) orderBy;
-(CustomerFavorite*) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy;
-(CustomerFavorite*) findOneWithPrimaryId:(NSString *)dbId;

-(NSArray *)findAllCodeByCon: (NSString *) sqlCon;
@end
