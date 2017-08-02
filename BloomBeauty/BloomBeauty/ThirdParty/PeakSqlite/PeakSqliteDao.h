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
#import "PeakSqlite.h"
#import "STDbHandle.h"

@interface PeakSqliteDao : NSObject
//创建时间
@property (nonatomic, strong) PeakSqlite *peakSqlite;
@property (nonatomic, strong) Class tableClass;
@property (nonatomic, strong) id dbObj;

-(BOOL)update;
-(int)insert;
-(int)insert:(id)dbObj;
-(int)update:(id)dbObj;

-(int)insertOrUpdate:(id)dbObj;
- (NSString *)sqlForCreateTable;

-(BOOL)deleteByCon:(NSString*)sqlCon parameters:(NSArray *)parameters;
-(void) setAll;

-(NSArray *) parameters;
@end
