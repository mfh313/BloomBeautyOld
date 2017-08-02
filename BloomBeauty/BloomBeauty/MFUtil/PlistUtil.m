//
//  SOXMapUtil.m
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import "PlistUtil.h"
#import "FileManager.h"
@implementation PlistUtil


+ (NSString*)loadStr:(NSString*)userDir fileName:(NSString*)fileName key:(NSString*)key
{
    NSMutableDictionary *data = [self find:userDir fileName:fileName];
    NSString *val = [data objectForKey:key];
    return val;
}

+ (double)loadDouble:(NSString*)userDir fileName:(NSString*)fileName key:(NSString*)key
{
    NSString *val = [self loadStr:userDir fileName:fileName key:key];
    double retVal = 0;
    retVal = [CommonUtil strToDouble:val];
    return retVal;
}
+ (NSMutableDictionary*)find:(NSString*)userDir fileName:(NSString*)fileName
{
    NSString *sanboxPath = [self getSanboxPath:userDir fileName:fileName];
    //输入写入
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:sanboxPath];
    if(data == nil)
    {
        NSMutableDictionary *dataNew = [self initFileBySystemTemp:userDir fileName:fileName];
        data = dataNew;
    }
    return data;
}

+ (NSString*)getSanboxPath:(NSString*)userDir fileName:(NSString*)fileName
{
    NSString *nameSanbox = [NSString stringWithFormat:@"%@.plist",fileName];
    NSString *sanboxPath = [MFFileUtil getSanboxPath:userDir fileName:nameSanbox];
    return sanboxPath;
}

+ (NSMutableDictionary*)initFileBySystemTemp:(NSString*)userDir fileName:(NSString*)fileName{
    NSString *plistPathSystem = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *dataSystem = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPathSystem];
    //获取应用程序沙盒的Documents目录
    NSString *sanboxPath = [self getSanboxPath:userDir fileName:fileName];
    if(dataSystem != nil)
    {
        [dataSystem writeToFile:sanboxPath atomically:YES];
    }
    return dataSystem;
} 
+ (BOOL)update:(NSString*)userDir fileName:(NSString*)fileName dict:(NSMutableDictionary*)dict{
    
    [self find:userDir fileName:fileName];
    NSString *sanboxPath = [self getSanboxPath:userDir fileName:fileName];
    [dict writeToFile:sanboxPath atomically:YES];
    return true;
}


+ (BOOL)delete:(NSString*)userDir fileName:(NSString*)fileName{
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *sanboxPath = [self getSanboxPath :userDir fileName:fileName];
    //如果文件路径存在的话
    BOOL bRet = [fileMger fileExistsAtPath:sanboxPath];
    if (bRet) {
        NSError *err;
        [fileMger removeItemAtPath:sanboxPath error:&err];
    }
    return true;
}

@end
