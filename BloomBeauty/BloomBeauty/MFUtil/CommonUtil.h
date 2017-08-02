//
//  SOXMapUtil.h
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import <Foundation/Foundation.h> 

@interface CommonUtil : NSObject

+ (NSString*)floatToString:(float)f;
+ (NSString*)doubleToString:(double)d;
+ (NSString*) intToString:(int)i;

+ (int)floatToInt:(float)f;
+ (float)intToFloat:(int)i;
+ (double)intToDouble:(int)i;

+ (double)strToDouble:(NSString*)str;

+ (NSString *)getFormatTimeStr:(int)time;
+ (NSString *)getFormatAllTimeStr:(float)time;
+ (NSString *)getFormatAllDistanceStr:(float)time;
+ (BOOL)isNull:(NSString *)str;
+ (BOOL)isNotNull:(NSString *)str;
+ (int)getRandomByDict  :(NSMutableDictionary*)dict;
+ (NSString*)createRandomCharList :(NSString*)strChar :(int)createCnt;

+ (NSString *)notRounding:(double)price afterPoint:(int)position;

 

+(void)showAlert:(NSString *)title message:(NSString *)message ;


+ (NSString *)getNowBundleVersion;


+ (NSString *)ecodeString:(NSString*)encodedString;
+ (NSString *)decodeString:(NSString*)encodedString;

+ (BOOL)checkTel:(NSString *)str;

+ (BOOL)checkNumber:(NSString *)str;
+ (BOOL)checkHanzhi:(NSString *)str;

+ (BOOL)validateEmail:(NSString *)email;

+ (NSString*)getAddZeroNum:(NSNumber *)number;

+ (NSString*)getRandomNumber:(NSNumber *)number;


-(NSString*)listToIds:(NSArray*)array;
@end
