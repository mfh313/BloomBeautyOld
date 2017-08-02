//
//  MFGoodsFilterItemCellView.h
//  BloomBeauty
//
//  Created by EEKA on 16/3/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFGoodsFilterItemCellViewDelegate <NSObject>

@optional
-(void)onDidSelectedFilterItem:(NSIndexPath *)indexPath;

@end

@interface MFGoodsFilterItemCellView : MFUIView
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *checkBox;
    
    __weak IBOutlet MFOnePixLine *_bottomLine;
    
}

@property (nonatomic,weak) id<MFGoodsFilterItemCellViewDelegate> m_delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)setTitle:(NSString *)title selected:(BOOL)isSelected;

@end
