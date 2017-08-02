//
//  MFUICollectionReusableView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/17.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUICollectionReusableView.h"

@implementation MFUICollectionReusableView
@synthesize m_subContentView;

-(void)setM_subContentView:(UIView *)subContentView
{
    m_subContentView = subContentView;
    m_subContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:m_subContentView];
}

@end
