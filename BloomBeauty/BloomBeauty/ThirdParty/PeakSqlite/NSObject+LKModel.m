//
//  NSObject+LKModel.m
//  LKDBHelper
//
//  Created by LJH on 13-4-15.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import "NSObject+LKModel.h"
@implementation NSObject (LKModel)

#pragma mark - log all property
- (NSMutableString*)getAllPropertysString
{
    Class clazz = [self class];
    NSMutableString* sb = [NSMutableString stringWithFormat:@"\n <%@> :\n", NSStringFromClass(clazz)];
    [self mutableString:sb appendPropertyStringWithClass:clazz containParent:YES];
    return sb;
}
- (NSString*)printAllPropertys
{
    return [self printAllPropertysIsContainParent:NO];
}
- (NSString*)printAllPropertysIsContainParent:(BOOL)containParent
{
#ifdef DEBUG
    Class clazz = [self class];
    NSMutableString* sb = [NSMutableString stringWithFormat:@"\n <%@> :\n", NSStringFromClass(clazz)];
    [self mutableString:sb appendPropertyStringWithClass:clazz containParent:containParent];
    NSLog(@"%@", sb);
    return sb;
#else
    return @"";
#endif
}
- (void)mutableString:(NSMutableString*)sb appendPropertyStringWithClass:(Class)clazz containParent:(BOOL)containParent
{
    if (clazz == [NSObject class]) {
        return;
    }
    unsigned int outCount = 0, i = 0;
    objc_property_t* properties = class_copyPropertyList(clazz, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString* propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [sb appendFormat:@" %@ : %@ \n", propertyName, [self valueForKey:propertyName]];
    }
    free(properties);
    if (containParent) {
        [self mutableString:sb appendPropertyStringWithClass:clazz.superclass containParent:containParent];
    }
}

@end