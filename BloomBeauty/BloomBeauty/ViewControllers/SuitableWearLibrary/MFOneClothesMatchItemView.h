//
//  MFOneClothesMatchItemView.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFOneClothesMatchDataItem;

@protocol MFOneClothesMatchItemViewDelegate <NSObject>

@optional
- (void)didTapMatchDataItem:(MFOneClothesMatchDataItem *)dataItem;

@end


@interface MFOneClothesMatchItemView : MFUIButton
{
    NSMutableArray *_matchsArray;
    NSMutableArray *_matchsViewArray;
    NSMutableArray *_showingViews;
}

@property (nonatomic,weak) id<MFOneClothesMatchItemViewDelegate> m_delegate;

-(void)setClothesMatchInfo:(NSArray *)infoArray;

@end
