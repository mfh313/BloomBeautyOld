//
//  SandboxFile.h
//  SKY
//
//  Author LiuXiaoBin   Created by mac  on 12-9-19.
//  Copyright (c) 2012年 SKY. All rights reserved.
//  Sand Box foundation Class


#import <Foundation/Foundation.h>

#define SANBOX_DIR_USER_PRE @"user_"

@interface MFFileUtil : NSObject

+ (NSString*)getSanboxPath:(NSString*)userDir fileName:(NSString*)fileName;
@end
