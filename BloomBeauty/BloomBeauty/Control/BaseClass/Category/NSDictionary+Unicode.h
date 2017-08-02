//
//  NSDictionary+Unicode.h
//  BloomBeauty
//
//  Created by EEKA on 2016/11/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NSLog打印 NSDictionary 时会自动进行如下操作,方便数组在线校验及格式化
 //1.自动补全缺失""
 //2.自动转换数组()转换为[]
 //3.自动转换unicode编码为中文
 */

@interface NSDictionary (Unicode)

@end
