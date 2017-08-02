//
//  MFRegionCitySelectView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFRegionCitySelectViewDelegate <NSObject>

@optional

-(void)onClickSelectRegionCity;
-(void)onCancelSelectRegionCity;
-(void)onClickSelectRegionCode:(NSString *)regionCode
                      cityCode:(NSString *)cityCode
                      zoneCode:(NSString *)zoneCode
            regionCityZoneName:(NSString *)reginDesc;



@end

@interface MFRegionCitySelectView : MFUIView

@property (nonatomic,weak) id<MFRegionCitySelectViewDelegate> m_delegate;

-(void)setSelectViewRegionCode:(NSString *)regionCode
                      cityCode:(NSString *)cityCode
                      zoneCode:(NSString *)zoneCode;

@end
