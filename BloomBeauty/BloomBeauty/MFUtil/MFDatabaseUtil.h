//
//  MFLoginCenter.h
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"
#import "FMDatabase.h"
#import "PeakSqlite.h"
#import "UserDao.h"
#import "CustomerDao.h"
#import "CustomerFavoriteDao.h"
#define SANBOX_USER_DB_PRE @"user_"
@interface MFDatabaseUtil : MFObject
{
    
}
@property (nonatomic, strong) FMDatabase *database;
+ (MFDatabaseUtil *)sharedManager;
- (void) initDatabase :(NSString *)userId;

@end
