//
//  MFSalingProdouctItemView.m
//  BloomBeauty
//
//  Created by EEKA on 16/7/21.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFSalingProdouctItemView.h"
#import "MFCommodityDetailModel.h"


@interface MFSalingProdouctItemView ()
{
    __weak IBOutlet UIButton *_bgBtn;
    __weak IBOutlet MFFavoriteButton *_favBtn;
    
    MFInStoreGoodsModel *_goodsModel;
}

@end

@implementation MFSalingProdouctItemView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_bgBtn setBackgroundImage:MFImageStretchCenter(@"zbl39") forState:UIControlStateNormal];
    [_bgBtn setAdjustsImageWhenHighlighted:NO];
}

- (IBAction)onClickSaleProdouctBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectSalingProdouctItemView:)]) {
        [self.delegate didSelectSalingProdouctItemView:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectSalingProdouct:)]) {
        [self.delegate didSelectSalingProdouct:_goodsModel];
    }
}

-(void)setInStoreGoodsModel:(MFInStoreGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    [self setItemStyleColor:_goodsModel.itemStyleColor];
}

-(void)setItemStyleColor:(NSString *)itemStyleColor
{
    [_favBtn setItemStyleColor:itemStyleColor];
}

-(void)setClickBlock:(onClickFavoriteBlock)clickBlock
{
    _favBtn.clickBlock = clickBlock;
}


@end
