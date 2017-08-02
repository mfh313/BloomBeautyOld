//
//  MFCountsTitleView.h
//  BloomBeauty
//
//  Created by EEKA on 16/3/18.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFCountsTitleViewDelegate <NSObject>

-(void)onClickSelectBrandButton;

@end


@interface MFCountsTitleView : MFUIButton

@property (nonatomic,weak) id<MFCountsTitleViewDelegate> delegate;

-(void)setNavTitle:(NSString *)title suffixString:(NSString *)suffixString sufColor:(UIColor *)color;
-(void)setNavTitle:(NSString *)title;

-(void)setCanSelectBrand:(BOOL)canSelect;
-(void)setSelectBrandTitle:(NSString *)brandName;

@end
