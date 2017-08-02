//
//  MFGoodsFilterActionFloatItemView.h
//  BloomBeauty
//
//  Created by EEKA on 16/7/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFGoodsFilterActionFloatItemView;
@protocol MFGoodsFilterActionFloatItemViewDelegate <NSObject>

@optional
-(void)onClickActionFloatItemView:(MFGoodsFilterActionFloatItemView *)btn;

@end

@interface MFGoodsFilterActionFloatItemView : MFUIButton

@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highlightImage;
@property (nonatomic,strong) NSString *normalTitle;
@property (nonatomic,strong) UIColor *normalTitleColor;
@property (nonatomic,strong) NSString *highlightTitle;
@property (nonatomic,strong) UIColor *highlightTitleColor;
@property (nonatomic,assign) BOOL isTouchHighlighted;
@property (nonatomic,weak) id<MFGoodsFilterActionFloatItemViewDelegate> touchDelegate;

@end
