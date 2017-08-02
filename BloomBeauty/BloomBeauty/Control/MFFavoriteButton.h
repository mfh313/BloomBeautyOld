//
//  MFFavoriteButton.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/23.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFFavoriteButton;

@protocol MFFavoriteButtonDelegate <NSObject>

@optional
-(void)MFFavoriteButton:(MFFavoriteButton *)button didSelectedIndex:(NSIndexPath *)indexPath;
-(void)MFFavoriteButton:(MFFavoriteButton *)button didDeSelectedIndex:(NSIndexPath *)indexPath;

@end

typedef void(^onClickFavoriteBlock)(BOOL didSelected,NSString *itemStyleColor,NSString *tips);

@interface MFFavoriteButton : MFUIView
{
    BOOL _selected;
}

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<MFFavoriteButtonDelegate> delegate;
@property (nonatomic,assign) BOOL selected;

@property (nonatomic,strong) NSString *itemStyleColor;
@property (nonatomic,copy) onClickFavoriteBlock clickBlock;

-(void)setContentImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

-(void)setSelected:(BOOL)isSelected;
@end
