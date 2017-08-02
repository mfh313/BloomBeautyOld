//
//  MFImageGridView.m
//  BloomBeauty
//
//  Created by EEKA on 1/11/16.
//  Copyright © 2016 EEKA. All rights reserved.
//

#import "MFImageGridView.h"

@implementation MFImageGridView
@synthesize m_startRect,m_stepX,m_stepY,m_columnCount,m_arrOfViews;

+(float)getLayoutHeightForViews:(int)viewsCount columms:(int)columms unitHeight:(float)height
{
    if (viewsCount == 0) {
        return 0;
    }
    
    int row = viewsCount / columms;
    int exRow = viewsCount % columms;
    if (exRow != 0) {
        row = viewsCount / columms + 1;
    }
    return row * height;
}

-(void)layoutSubviews
{
    for (int i = 0; i < m_arrOfViews.count; i++) {
        UIView *itemView = (UIView *)m_arrOfViews[i];
        CGFloat itemWidth = CGRectGetWidth(itemView.frame);
        CGFloat itemHeight = CGRectGetHeight(itemView.frame);
        int rowIndex = i / m_columnCount;
        int columIndex = i % m_columnCount;
        NSInteger oringnX = m_startRect.origin.x + columIndex * itemWidth + columIndex * m_stepX;
        NSInteger oringnY = m_startRect.origin.y + rowIndex * itemHeight + rowIndex * m_stepY;
        CGRect itemFrame = CGRectMake(oringnX, oringnY, CGRectGetWidth(itemView.frame), CGRectGetHeight(itemView.frame));
        itemView.frame = itemFrame;
    }
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        m_stepX = 10;
        m_stepY = 10;
    }
    
    return self;
}


@end
