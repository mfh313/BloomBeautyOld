//
//  MFSalingProdouctCellView.m
//  BloomBeauty
//
//  Created by EEKA on 16/7/21.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFSalingProdouctCellView.h"
#import "MFCommodityDetailModel.h"

@implementation MFSalingProdouctCellView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MFRGB(239, 235, 235);
        
        _showingView = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            MFSalingProdouctItemView *itemView = [MFSalingProdouctItemView viewWithNibName:@"MFSalingProdouctItemView"];
            itemView.delegate = self;
            [self addSubview:itemView];
            [_showingView addObject:itemView];
        }
    }
    
    return self;
}

-(void)setClickFavBlock:(void (^)(BOOL didSelected,NSString *itemStyleColor,NSString *tips))clickBlock
{
    for (int i = 0; i < 4; i++) {
        MFSalingProdouctItemView *itemView = _showingView[i];
        [itemView setClickBlock:clickBlock];
    }
}

-(void)didSelectSalingProdouctItemView:(MFSalingProdouctItemView *)itemView
{
    NSInteger selectIndex= [_showingView indexOfObject:itemView];
    
    MFInStoreGoodsModel *goodsModel = _dataArray[selectIndex];
    if ([self.delegate respondsToSelector:@selector(didSelectSalingProdouct:)]) {
        [self.delegate didSelectSalingProdouct:goodsModel];
    }
}

-(void)layoutSubviews
{
    CGFloat hSpace = 15;
    CGFloat leftMargin = 20;
    NSUInteger counts = 4;
    CGFloat width = (CGRectGetWidth(self.bounds) - (counts - 1) * hSpace - 2 * leftMargin) / counts;
    CGFloat height = CGRectGetHeight(self.bounds) - hSpace;
    
    CGFloat orignX = leftMargin;
    for (int i = 0; i < 4; i++) {
        MFSalingProdouctItemView *itemView = _showingView[i];
        
        itemView.frame = CGRectMake(orignX, hSpace, width, height);
        
        orignX = CGRectGetMaxX(itemView.frame) + hSpace;
    }
}

-(void)setDataArray:(NSMutableArray *)array
{
    _dataArray = array;
    
    for (int i = 0; i < array.count; i++) {
        MFSalingProdouctItemView *itemView = _showingView[i];
        
        MFInStoreGoodsModel *goodsModel = array[i];
        itemView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [itemView.imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.smallItemUrl] placeholderImage:MFImage(@"zbl55")];
        
        [itemView setItemStyleColor:goodsModel.itemStyleColor];
    }
    
    for (int i = 0; i < 4; i++) {
        MFSalingProdouctItemView *itemView = _showingView[i];
        if (i < array.count) {
            [itemView setHidden:NO];
        }
        else
        {
            [itemView setHidden:YES];
        }
    }
    
    
    [self layoutSubviews];
}


@end
