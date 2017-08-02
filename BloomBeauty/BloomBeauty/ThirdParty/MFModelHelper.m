//
//  MFModelHelper.m
//  YJCustom
//
//  Created by EEKA on 16/9/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFModelHelper.h"

@implementation NSObject (MFModelHelper)

+ (instancetype)MM_modelWithJSON:(id)json {
    return [self yy_modelWithJSON:json];
}

+ (instancetype)MM_modelWithDictionary:(NSDictionary *)dictionary {
    return [self yy_modelWithDictionary:dictionary];
}



@end
