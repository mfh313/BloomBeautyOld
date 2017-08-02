//
//  MFInstoreGoodsItemView.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFFavoriteButton.h"

@class MFInstoreGoodsItemView;

@protocol MFInstoreGoodsItemViewDelegate <NSObject>

-(void)didSelectInstoreGoodsItemView:(MFInstoreGoodsItemView *)itemView indexPath:(NSIndexPath *)indexPath;

@end

@class MFCommodityDetailModel;
@interface MFInstoreGoodsItemView : MFUIView

@property (nonatomic,weak) id<MFInstoreGoodsItemViewDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *itemIndexPath;
@property (nonatomic,strong) MFCommodityDetailModel *model;

- (void)setClickBlock:(onClickFavoriteBlock)clickBlock;
- (void)setBorder:(BOOL)hasBorder;
- (void)setCommodityDetailModel:(MFCommodityDetailModel *)model;
- (void)setFavorite:(BOOL)favorite;
- (void)setImageSize:(CGRect)rect;
@end
