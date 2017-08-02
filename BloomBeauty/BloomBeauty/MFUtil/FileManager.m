//
//  GOHeadManagerFile.m
//  golo
//
//  Created by launch03 on 13-11-14.
//  Copyright (c) 2013年 LAUNCH. All rights reserved.
//

#import "FileManager.h"
#import "FileManager.h"
#import <UIKit/UIKit.h>



#define kRemoveDataDayInterval      2592000     // (3600 * 24 * 30.0)
#define kDocFileName                @".userDir" 

#define IM_HEAD_DIR     ([NSString stringWithFormat:@"%@/Documents/abc/HeadImage",NSHomeDirectory()])
#define PATH_IN_USER    ([NSString stringWithFormat:@"%@/Documents/abc", NSHomeDirectory()])
#define PATH_IN_IM_HEAD_DIR(f)      ([NSString stringWithFormat:@"%@/Documents/abc/HeadImage/%@",NSHomeDirectory(),f])


@interface FileManager ()
{
    NSFileManager *fileManager_;
}

@end

@implementation FileManager


static FileManager *FileManager_;


+ (FileManager *)sharedManager
{
    if (FileManager_ == nil) {
        FileManager_ = [[FileManager alloc] init];
    }
    return FileManager_;
}


- (id)init
{
    self = [super init];
    if (self) {
        fileManager_ = [NSFileManager defaultManager];
        
        /*
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString* lujing = IM_HEAD_DIR;
        NSString *path = PATH_IN_USER;
        if (![fm fileExistsAtPath:path isDirectory:NULL])
        {
            [fm createDirectoryAtPath:path
          withIntermediateDirectories:YES
                           attributes:nil
                                error:nil];
        }
        
        if (![fm fileExistsAtPath:lujing isDirectory:NULL])
        {
            [fm createDirectoryAtPath:lujing
          withIntermediateDirectories:NO
                           attributes:nil
                                error:nil];
        }
        */
    }
    return self;
}


//查找用户 自己的文件夹
+ (NSString *)findUserDir:(NSString *)fileName
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *userPath = [docPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:userPath] == NO) {
        [fileManager createDirectoryAtPath:userPath
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }
    return userPath;
}


+ (NSString *)atDocPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *atDocPath = [docPath stringByAppendingPathComponent:kDocFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:atDocPath] == NO) {
        [fileManager createDirectoryAtPath:atDocPath
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }
    return atDocPath;
}

- (BOOL)isFileExistWithUrl:(NSString *)url
{
    NSString *filePath = [[FileManager atDocPath] stringByAppendingPathComponent:url];
    return [fileManager_ fileExistsAtPath:filePath];
}

- (void)writeImage:(UIImage *)image url:(NSString *)url
{
    NSString *filePath = [[FileManager atDocPath] stringByAppendingPathComponent:url];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

- (void)writeImageData:(NSData *)imageData url:(NSString *)url
{
    NSString *filePath = [[FileManager atDocPath] stringByAppendingPathComponent:url];
    [imageData writeToFile:filePath atomically:YES];
}

- (NSString *)filePathWithUrl:(NSString *)url
{
    return [[FileManager atDocPath] stringByAppendingPathComponent:url];
}

-(UIImage *)readImage:(NSString *)fileName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *str = PATH_IN_USER;
    if (![fm fileExistsAtPath:str isDirectory:NULL])
    {
        [fm createDirectoryAtPath:str
      withIntermediateDirectories:NO
                       attributes:nil
                            error:nil];
    }
    NSString *path = PATH_IN_IM_HEAD_DIR(fileName);
    NSData *reader = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:reader];
}

- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *str = PATH_IN_USER;
    if (![fm fileExistsAtPath:str isDirectory:NULL])
    {
        [fm createDirectoryAtPath:str
      withIntermediateDirectories:NO
                       attributes:nil
                            error:nil];
    }
    
    NSString *path = PATH_IN_IM_HEAD_DIR(fileName);
    
    if ([fm fileExistsAtPath:path isDirectory:NULL]) {
        [fm removeItemAtPath:path error:NULL];
    }
}


@end
