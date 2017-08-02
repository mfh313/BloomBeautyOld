//
//  MFInstoreGoodsCollectionCell.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFInstoreGoodsItemView.h"

@interface MFInstoreGoodsCollectionCell : MFCollectionViewCell

@property (weak, nonatomic) IBOutlet MFInstoreGoodsItemView *itemView;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end
