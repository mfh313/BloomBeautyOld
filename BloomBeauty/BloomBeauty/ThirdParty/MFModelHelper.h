//
//  MFModelHelper.h
//  YJCustom
//
//  Created by EEKA on 16/9/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface NSObject (MFModelHelper)

+ (instancetype)MM_modelWithJSON:(id)json;

+ (instancetype)MM_modelWithDictionary:(NSDictionary *)dictionary;

@end
