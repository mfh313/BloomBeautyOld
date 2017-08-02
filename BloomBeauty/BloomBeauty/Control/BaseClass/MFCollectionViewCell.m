//
//  MFCollectionViewCell.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/12.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCollectionViewCell.h"

@implementation MFCollectionViewCell
@synthesize m_subContentView;

-(void)setM_subContentView:(UIView *)subContentView
{
    m_subContentView = subContentView;
    m_subContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:m_subContentView];
}

@end
