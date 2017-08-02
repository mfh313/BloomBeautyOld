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
#import "LoginUserInfo.h"
@interface UserDao  : PeakSqliteDao

@property (nonatomic, strong) LoginUserInfo *entity;

+ (UserDao *)sharedManager;
-(NSArray *) findAllObjWithOrderBy: (NSString *) orderBy;
-(LoginUserInfo*) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy;
-(LoginUserInfo*) findOneWithPrimaryId:(NSString *)dbId;
@end
