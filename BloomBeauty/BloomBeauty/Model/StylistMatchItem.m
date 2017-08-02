//
//  StylistMatchItem.m
//  BloomBeauty
//
//  Created by EEKA on 16/6/12.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "StylistMatchItem.h"

NSString * const stylistMatchItemName = @"stylistMatchItemName";
NSString * const stylistMatchItemCode = @"stylistMatchItemCode";

@implementation StylistMatchItem

-(void)makeCodesInfo
{
    NSMutableArray *array = [NSMutableArray array];
    if ([CommonUtil isNotNull:self.codeA]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[stylistMatchItemCode] = self.codeA;
        dic[stylistMatchItemName] = self.nameA;
        [array addObject:dic];
    }
    
    if ([CommonUtil isNotNull:self.codeB]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[stylistMatchItemCode] = self.codeB;
        dic[stylistMatchItemName] = self.nameB;
        [array addObject:dic];
    }
    
    if ([CommonUtil isNotNull:self.codeC]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[stylistMatchItemCode] = self.codeC;
        dic[stylistMatchItemName] = self.nameC;
        [array addObject:dic];
    }
    
    self.codesInfo = array;
}

@end
