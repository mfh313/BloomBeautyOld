//
//  MFImageGridView.h
//  BloomBeauty
//
//  Created by EEKA on 1/11/16.
//  Copyright © 2016 EEKA. All rights reserved.
//

#import "MFUIView.h"

@interface MFImageGridView : MFUIView
{
    CGRect m_startRect;
    float m_stepX;
    float m_stepY;
    int m_columnCount;
    NSMutableArray *m_arrOfViews;
}

@property(retain, nonatomic) NSMutableArray* m_arrOfViews;
@property(assign, nonatomic) int m_columnCount;
@property(assign, nonatomic) float m_stepY;
@property(assign, nonatomic) float m_stepX;
@property(assign, nonatomic) CGRect m_startRect;

+(float)getLayoutHeightForViews:(int)viewsCount columms:(int)columms unitHeight:(float)height;
-(CGSize)getLayoutSize;
-(void)layoutSubviews;

@end
