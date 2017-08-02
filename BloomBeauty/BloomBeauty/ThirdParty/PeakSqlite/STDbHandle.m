//
//  STDbHandle.m
//  STQuickKit
//
//  Created by yls on 13-11-21.
//
// Version 1.0.4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "STDbHandle.h"
#import <objc/runtime.h>

#define DBName @"stdb.sqlite"

#ifdef DEBUG
#ifdef STDBBUG
#define STDBLog(fmt, ...) NSLog((@"%s [Line %d]\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define STDBLog(...)
#endif
#else
#define STDBLog(...)
#endif

enum {
    DBObjAttrInt,
    DBObjAttrFloat,
    DBObjAttrString,
    DBObjAttrData,
    DBObjAttrDate,
    DBObjAttrArray,
    DBObjAttrDictionary,
};

#define DBText  @"text"
#define DBInt   @"integer"
#define DBFloat @"real"
#define DBData  @"blob"

@interface NSDate (STDbDate)

+ (NSDate *)dateWithString:(NSString *)s;
+ (NSString *)stringWithDate:(NSDate *)date;

@end

@implementation NSDate (STDbDate)

+ (NSDate *)dateWithString:(NSString *)s;
{
    if (!s || (NSNull *)s == [NSNull null] || [s isEqual:@""]) {
        return nil;
    }
//    NSTimeInterval t = [s doubleValue];
//    return [NSDate dateWithTimeIntervalSince1970:t];
    
    return [[self dateFormatter] dateFromString:s];
}

+ (NSString *)stringWithDate:(NSDate *)date;
{
    if (!date || (NSNull *)date == [NSNull null] || [date isEqual:@""]) {
        return nil;
    }
//    NSTimeInterval t = [date timeIntervalSince1970];
//    return [NSString stringWithFormat:@"%lf", t];
    return [[self dateFormatter] stringFromDate:date];
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

@end

@interface NSObject (STDbObject)

+ (id)objectWithString:(NSString *)s;
+ (NSString *)stringWithObject:(NSObject *)obj;

@end

@implementation NSObject (STDbObject)

+ (id)objectWithString:(NSString *)s;
{
    if (!s || (NSNull *)s == [NSNull null] || [s isEqual:@""]) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}
+ (NSString *)stringWithObject:(NSObject *)obj;
{
    if (!obj || (NSNull *)obj == [NSNull null] || [obj isEqual:@""]) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@interface STDbHandle()

@property (nonatomic) sqlite3 *sqlite3DB;
@property (nonatomic, assign) BOOL isOpened;

@end

@implementation STDbHandle

/**
 *	@brief	单例数据库
 *
 *	@return	单例
 */
+ (instancetype)shareDb
{
    static STDbHandle *stdb;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stdb = [[STDbHandle alloc] init];
    });
    return stdb;
}

#pragma mark - other method


/*
 * 判断一个表是否存在；
 */
+ (BOOL)sqlite_tableExist:(Class)aClass {
    NSArray *tableArray = [self sqlite_tablename];
    NSString *tableName = NSStringFromClass(aClass);
    for (NSString *tablename in tableArray) {
        if ([tablename isEqualToString:tableName]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)dbTypeConvertFromObjc_property_t:(objc_property_t)property
{
//    NSString * attr = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        case 'd' : //double
        {
            return DBFloat;
        }
            break;
        
        case 'c':   // char
        case 's' : //short
        case 'i':   // int
        case 'l':   // long
        {
            return DBInt;
        }
            break;

        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return DBInt;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSData class]]) {
                return DBData;
            }
        }
            break;
    }

    return DBText;
}

+ (id)valueForObjc_property_t:(objc_property_t)property dbValue:(id)dbValue
{
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        {
            return [NSNumber numberWithDouble:[dbValue floatValue]];
        }
            break;
        case 'd' : //double
        {
            return [NSNumber numberWithDouble:[dbValue doubleValue]];
        }
            break;
            
        case 'c':   // char
        {
            return [NSNumber numberWithDouble:[dbValue charValue]];
        }
            break;
        case 's' : //short
        {
            return [NSNumber numberWithDouble:[dbValue shortValue]];
        }
            break;
        case 'i':   // int
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
        case 'l':   // long
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
            
        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                return [NSString  stringWithFormat:@"%@", dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return [NSNumber numberWithDouble:[dbValue doubleValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                return [NSDictionary objectWithString:[NSString stringWithFormat:@"%@", dbValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                return [NSArray objectWithString:[NSString stringWithFormat:@"%@", dbValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                return [NSDate dateWithString:[NSString stringWithFormat:@"%@", dbValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSValue class]]) {
                return [NSData dataWithData:dbValue];
            }
        }
            break;
    }
    
    return dbValue;
}

+ (id)valueForDbObjc_property_t:(objc_property_t)property dbValue:(id)dbValue
{
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        {
            return [NSNumber numberWithDouble:[dbValue floatValue]];
        }
            break;
        case 'd' : //double
        {
            return [NSNumber numberWithDouble:[dbValue doubleValue]];
        }
            break;
            
        case 'c':   // char
        {
            return [NSNumber numberWithDouble:[dbValue charValue]];
        }
            break;
        case 's' : //short
        {
            return [NSNumber numberWithDouble:[dbValue shortValue]];
        }
            break;
        case 'i':   // int
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
        case 'l':   // long
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
            
        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                return [NSString  stringWithFormat:@"%@", dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return [NSNumber numberWithDouble:[dbValue doubleValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                return [NSDictionary stringWithObject:dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                return [NSDictionary stringWithObject:dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                if ([dbValue isKindOfClass:[NSDate class]]) {
                    return [NSString stringWithFormat:@"%@", [NSDate stringWithDate:dbValue]];
                } else {
                    return @"";
                }
                
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSValue class]]) {
                return [NSData dataWithData:dbValue];
            }
        }
            break;
    }
    
    return dbValue;
}

+ (BOOL)isOpened
{
    return [[self shareDb] isOpened];
}
+ (void)class:(Class)aClass getPropertyNameList:(NSMutableArray *)proName primaryKey:(NSString *)primaryKey  primaryIdType:(NSString *)primaryIdType isAutoIncrement:(BOOL)isAutoIncrement
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        NSString *type = [STDbHandle dbTypeConvertFromObjc_property_t:property];
        
        NSString *proStr;
        if ([key isEqualToString:primaryKey]) {
            if([primaryIdType isEqualToString:@"text"])
            {
                proStr = [NSString stringWithFormat:@"%@ %@  not null primary key ", key, DBText];
            }else
            {
                proStr = [NSString stringWithFormat:@"%@ %@ not null primary key", key, DBInt];
            }
            if(isAutoIncrement){
                proStr = [NSString stringWithFormat:@"%@ autoincrement ", proStr];
            }
            //id INTEGER NOT NULL PRIMARY KEY
        } else {
            proStr = [NSString stringWithFormat:@"%@ %@", key, type];
        } 
        
        [proName addObject:proStr];
    }
    
//    if (aClass == [STDbObject class]) {
//        return;
//    }
//    [STDbHandle class:[aClass superclass] getPropertyNameList:proName];
}

+ (void)class:(Class)aClass getPropertyKeyList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        [proName addObject:key];
    }
    
//    if (aClass == [STDbObject class]) {
//        return;
//    }
//    [STDbHandle class:[aClass superclass] getPropertyKeyList:proName];
}

+ (void)class:(Class)aClass getPropertyTypeList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *type = [STDbHandle dbTypeConvertFromObjc_property_t:property];
        [proName addObject:type];
    }
    
//    if (aClass == [STDbObject class]) {
//        return;
//    }
//    [STDbHandle class:[aClass superclass] getPropertyTypeList:proName];
}

@end




