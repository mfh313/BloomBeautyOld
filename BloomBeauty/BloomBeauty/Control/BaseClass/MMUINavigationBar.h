//
//  MMUINavigationBar.h
//  BloomBeauty
//
//  Created by EEKA on 16/8/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMUINavigationBar : UINavigationBar
{
    UIView *_barBackShadowView;
    CAGradientLayer *_shadowLayer;
    
    UIView *_navBarLine;
    UIImageView *_roundView;
}

-(void)setRoundCornerShow:(BOOL)show;

@end
