//
//  SandboxFile.m
//  SKY
//
//  Created by mac  on 12-9-19.
//  Copyright (c) 2012年 SKY. All rights reserved.
//

#import "MFFileUtil.h"
#import "FileManager.h"
@implementation MFFileUtil

//统一管理 根目录的信息
+ (NSString*)getSanboxPath:(NSString*)userDir fileName:(NSString*)fileName
{
    NSString *userPath = @"";
    //SANBOX_DIR_USER_PRE
    if(userDir != nil && ![userDir isEqualToString:PLIST_SYSTEM_DIR])
    {
        NSString *newUserDir = [NSString stringWithFormat:@"%@%@",SANBOX_DIR_USER_PRE,userDir];
        userPath = [FileManager findUserDir:newUserDir];
    }else
    {
        //没有 默认取系统 根路径
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        userPath = [paths objectAtIndex:0];
    }
    NSString *sanboxPath=[userPath stringByAppendingPathComponent:fileName];
    return sanboxPath;
}
@end
