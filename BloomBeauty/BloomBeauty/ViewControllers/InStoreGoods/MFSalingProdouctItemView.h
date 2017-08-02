//
//  MFSalingProdouctItemView.h
//  BloomBeauty
//
//  Created by EEKA on 16/7/21.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFFavoriteButton.h"

@class MFSalingProdouctItemView,MFInStoreGoodsModel;
@protocol MFSalingProdouctItemViewDelegate <NSObject>
@optional
-(void)didSelectSalingProdouctItemView:(MFSalingProdouctItemView *)itemView;
-(void)didSelectSalingProdouct:(MFInStoreGoodsModel *)goodsModel;

@end

@interface MFSalingProdouctItemView : MFUIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) id<MFSalingProdouctItemViewDelegate> delegate;

-(void)setInStoreGoodsModel:(MFInStoreGoodsModel *)goodsModel;
-(void)setItemStyleColor:(NSString *)itemStyleColor;
-(void)setClickBlock:(onClickFavoriteBlock)clickBlock;

@end
