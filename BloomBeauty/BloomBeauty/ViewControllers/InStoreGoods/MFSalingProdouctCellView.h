//
//  MFSalingProdouctCellView.h
//  BloomBeauty
//
//  Created by EEKA on 16/7/21.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFSalingProdouctItemView.h"

@class MFInStoreGoodsModel;

@protocol MFSalingProdouctCellViewDelegate <NSObject>
@optional
-(void)didSelectSalingProdouct:(MFInStoreGoodsModel *)goodsModel;

@end

@interface MFSalingProdouctCellView : MFUIView <MFSalingProdouctItemViewDelegate>
{
    NSMutableArray *_showingView;
    NSMutableArray *_dataArray;
}

@property (nonatomic,weak) id<MFSalingProdouctCellViewDelegate> delegate;

-(void)setDataArray:(NSMutableArray *)array;
-(void)setClickFavBlock:(void (^)(BOOL didSelected,NSString *itemStyleColor,NSString *tips))clickBlock;

@end
