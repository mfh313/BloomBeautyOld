//
//  NSObject+LKModel.h
//  LKDBHelper
//
//  Created by LJH on 13-4-15.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h> 
#pragma mark - 表结构
@interface NSObject (LKTabelStructure)

/**
 *	@brief log all property 	打印所有的属性名称和数据
 */
- (NSString*)printAllPropertys;
- (NSString*)printAllPropertysIsContainParent:(BOOL)containParent;

- (NSMutableString*)getAllPropertysString;
@end