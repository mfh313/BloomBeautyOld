//
//  MFGoodsFilter.h
//  BloomBeauty
//
//  Created by EEKA on 2017/4/9.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFGoodsFilterDelegate <NSObject>

@optional
-(void)onClickFilterDoneCommodityCodeStr:(NSString *)filterStrForCommodityCode
                               occasions:(NSString *)filterStrForOccasions;
-(void)onClickFilterDoneCommodityCodeDescription:(NSString *)filterStrForCommodityCodeDesc
                                   occasionsDesc:(NSString *)filterStrForOccasionsDesc;

@end

@interface MFGoodsFilter : MFUIView

@property (nonatomic,weak) id<MFGoodsFilterDelegate> m_delegate;

@end
