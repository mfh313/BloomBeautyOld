//
//  SOXMapUtil.h
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import <Foundation/Foundation.h> 

@interface PlistUtil : NSObject

#define PLIST_SYSTEM_DIR @"systemDir"
#define PLIST_SYSTEM_FILE_NAME @"system"
#define PLIST_SYSTEM_KEY_VERSION @"version"
 


#define PLIST_DICTIONARY_KEY_BRAND @"brandList"

#define PLIST_DICTIONARY_KEY_OCCUPA @"occupationTypeList"

+ (double)loadDouble:(NSString*)userDir fileName:(NSString*)fileName key:(NSString*)key;

+ (NSString*)loadStr:(NSString*)userDir fileName:(NSString*)fileName key:(NSString*)key;
+ (NSMutableDictionary*)find:(NSString*)userDir fileName:(NSString*)fileName;
+ (BOOL)update:(NSString*)userDir fileName:(NSString*)fileName dict:(NSDictionary*)dict ;
+ (BOOL)delete:(NSString*)userDir fileName:(NSString*)fileName;



@end
