//
//  NSString+commodityCodeFavorite.m
//  BloomBeauty
//
//  Created by EEKA on 1/6/16.
//  Copyright © 2016 EEKA. All rights reserved.
//

#import "NSString+commodityCodeFavorite.h"

@implementation NSString (commodityCodeFavorite)

-(BOOL)MF_isFavorite
{
    __block BOOL isFavorite = NO;
    NSMutableArray *favoriteArray = [MFLoginCenter sharedCenter].currentCustomerInfo.favoriteArray;
    [favoriteArray enumerateObjectsUsingBlock:^(CustomerFavoriteCommodityItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.itemStyleColor isEqualToString:self]) {
            isFavorite = YES;
            *stop = YES;
        }
    }];
    
    return isFavorite;
}

@end
