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
#import "CustomerInfo.h"
@interface CustomerDao  : PeakSqliteDao

@property (nonatomic, strong) CustomerInfo *entity;

+ (CustomerDao *)sharedManager;
-(NSArray *) findAllObjWithOrderBy: (NSString *) orderBy;
-(CustomerInfo*) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy;
-(CustomerInfo*) findOneWithPrimaryId:(NSString *)dbId;


-(BOOL)updatePortrait:(CustomerInfo *)dbObj;
@end
