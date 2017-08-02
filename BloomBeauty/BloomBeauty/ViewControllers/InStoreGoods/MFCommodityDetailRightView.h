//
//  MFCommodityDetailRightView.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/23.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@interface MFCommodityDetailRightView : MFUIView

-(void)setCommodityCode:(NSString *)commodityCode Price:(NSString *)priceStr;
-(void)setSizeMapDic:(NSMutableDictionary *)dic;

@end
