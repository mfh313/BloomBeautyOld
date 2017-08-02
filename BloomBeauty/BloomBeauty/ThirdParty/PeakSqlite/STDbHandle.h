//
//  STDbHandle.h
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

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class STDbObject;

@interface STDbHandle : NSObject

/**
 *	@brief	单例数据库
 *
 *	@return	单例
 */
+ (instancetype)shareDb;

/*
 * 查看所有表名
 */
+ (NSArray *)sqlite_tablename;
+ (BOOL)sqlite_tableExist:(Class)aClass ;
+ (NSString *)dbTypeConvertFromObjc_property_t:(objc_property_t)property ;
+ (id)valueForObjc_property_t:(objc_property_t)property dbValue:(id)dbValue;
+ (id)valueForDbObjc_property_t:(objc_property_t)property dbValue:(id)dbValue;
//+ (void)class:(Class)aClass getPropertyNameList:(NSMutableArray *)proName;
+ (void)class:(Class)aClass getPropertyKeyList:(NSMutableArray *)proName;
+ (void)class:(Class)aClass getPropertyTypeList:(NSMutableArray *)proName;

+ (void)class:(Class)aClass getPropertyNameList:(NSMutableArray *)proName primaryKey:(NSString *)primaryKey  primaryIdType:(NSString *)primaryIdType  isAutoIncrement:(BOOL)isAutoIncrement;



@end
