//
//  MFCommodityAvailableSizeView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@interface MFCommodityAvailableSizeView : MFUIView

-(void)setCommodityCode:(NSString *)commodityCode;
-(void)setListPrice:(NSString *)listPrice;
-(void)setSizeMap:(NSMutableDictionary *)sizeMap;

@end
