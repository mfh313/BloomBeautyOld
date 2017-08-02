//
//  MMUINavigationBar.m
//  BloomBeauty
//
//  Created by EEKA on 16/8/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MMUINavigationBar.h"

@implementation MMUINavigationBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _barBackShadowView = [UIView new];
        _barBackShadowView.frame = CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20);
        _barBackShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _barBackShadowView.backgroundColor = [UIColor hx_colorWithHexString:@"242834"];
        [self addSubview:_barBackShadowView];
        
        [self bringSubviewToFront:_barBackShadowView];
        
        _navBarLine = [UIView new];
        _navBarLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - MFOnePixHeigtht, CGRectGetWidth(self.bounds), MFOnePixHeigtht);
        _navBarLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _navBarLine.backgroundColor = [UIColor hx_colorWithHexString:@"3d4049" alpha:0.5];
        [self addSubview:_navBarLine];
        
        _roundView = [[UIImageView alloc] initWithImage:MFImage(@"yuanjiao")];
        _roundView.frame = CGRectMake(0, 0, 5, 5);
        _roundView.backgroundColor = [UIColor hx_colorWithHexString:@"242834"];
        [self addSubview:_roundView];
        
        [_roundView setHidden:YES];
    }
    
    return self;
}

-(void)setRoundCornerShow:(BOOL)show
{
    [_roundView setHidden:!show];
}

@end
