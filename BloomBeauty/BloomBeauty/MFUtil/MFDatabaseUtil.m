//
//  MFLoginCenter.m
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDatabaseUtil.h"
#import "FileManager.h"
@implementation MFDatabaseUtil

+ (MFDatabaseUtil *)sharedManager
{
    static MFDatabaseUtil *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}


//初始化数据库
- (void) initDatabase :(NSString *)userId{
    NSString *newFileName = [NSString stringWithFormat:@"%@%@.sqlite",SANBOX_USER_DB_PRE,userId];
    NSString *dbSanBoxUrl = [MFFileUtil getSanboxPath:userId fileName:newFileName]; 
    //删除现有的文件
//    NSFileManager *fm = [NSFileManager defaultManager];
//    [fm removeItemAtPath: path error: nil];
    self.database = [[FMDatabase alloc] initWithPath:dbSanBoxUrl];
    self.database.traceExecution = YES;
}
 
@end
