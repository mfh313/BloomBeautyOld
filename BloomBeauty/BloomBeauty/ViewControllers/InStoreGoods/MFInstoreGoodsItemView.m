//
//  MFInstoreGoodsItemView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFInstoreGoodsItemView.h"
#import "MFCommodityDetailModel.h"

@interface MFInstoreGoodsItemView ()<MFLongPressImageViewDelegate>
{
    NSIndexPath *_itemIndexPath;
    __weak IBOutlet MFFavoriteButton *_favoriteBtn;
    
    __weak IBOutlet MFUILongPressImageView *_imageView;
    __weak id<MFInstoreGoodsItemViewDelegate> _delegate;
    __weak IBOutlet UIImageView *_borderImageView;
}

@end

@implementation MFInstoreGoodsItemView
@synthesize delegate = _delegate,itemIndexPath = _itemIndexPath;


-(void)awakeFromNib
{
    [super awakeFromNib];
    [_favoriteBtn setContentImageEdgeInsets:UIEdgeInsetsMake(10, 10, 0, 0)];
    _borderImageView.image = MFImageStretchCenter(@"zbl39");
    _imageView.delegate = self;
}

-(void)setItemIndexPath:(NSIndexPath *)itemIndexPaths
{
    _itemIndexPath = itemIndexPaths;
    _favoriteBtn.indexPath = itemIndexPaths;
}

-(void)setFavorite:(BOOL)favorite
{
    [_favoriteBtn setSelected:favorite];
}

-(void)setBorder:(BOOL)hasBorder
{
    _borderImageView.hidden = !hasBorder;
}

-(void)setImageSize:(CGRect)rect
{
    _imageView.frame = rect;
}

-(void)setDelegate:(id<MFInstoreGoodsItemViewDelegate,MFFavoriteButtonDelegate>)delegate
{
    _delegate = delegate;
    _favoriteBtn.delegate = delegate;
}

- (void)setCommodityDetailModel:(MFCommodityDetailModel *)model
{
    self.model = model;
    NSURL *imageUrl = [NSURL URLWithString:model.commodityThumbNailUrl];
    [_imageView sd_setImageWithURL:imageUrl placeholderImage:MFImage(@"zbl55") options:SDWebImageRefreshCached];
    
    _favoriteBtn.itemStyleColor = model.commodityCode;
}

-(void)setClickBlock:(onClickFavoriteBlock)clickBlock
{
    _favoriteBtn.clickBlock = clickBlock;
}

- (IBAction)onClickCommodityBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectInstoreGoodsItemView:indexPath:)]) {
        [self.delegate didSelectInstoreGoodsItemView:self indexPath:self.itemIndexPath];
    }
}

- (void)OnTouchDown:(MFUILongPressImageView*)imgView
{
    
}


@end
