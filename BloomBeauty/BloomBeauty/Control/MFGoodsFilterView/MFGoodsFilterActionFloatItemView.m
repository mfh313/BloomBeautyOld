//
//  MFGoodsFilterActionFloatItemView.m
//  BloomBeauty
//
//  Created by EEKA on 16/7/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFGoodsFilterActionFloatItemView.h"

@interface MFGoodsFilterActionFloatItemView ()
{
    __weak IBOutlet UIButton *_contentBtn;
}

@end

@implementation MFGoodsFilterActionFloatItemView
@synthesize normalImage,normalTitle,highlightImage,highlightTitleColor;
@synthesize touchDelegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.normalTitleColor = [UIColor hx_colorWithHexString:@"2d2c2c"];
    self.highlightTitleColor = [UIColor whiteColor];
    self.normalImage = MFImage(@"plus");
    self.highlightImage = MFImage(@"check3");
    
    [_contentBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setSelected:NO];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setBtnSelected:selected];
}

-(void)setHighlighted:(BOOL)highlighted
{
    if (self.isTouchHighlighted == NO) {
        return;
    }
    
    [super setHighlighted:highlighted];
    [self setBtnSelected:highlighted];
}

-(void)setBtnSelected:(BOOL)selected
{
    if (selected) {
        
        [_contentBtn setImage:self.highlightImage forState:UIControlStateNormal];
        [_contentBtn setBackgroundImage:MFImageStretchCenter(@"color") forState:UIControlStateNormal];
        [_contentBtn setTitle:self.normalTitle forState:UIControlStateNormal];
        [_contentBtn setTitleColor:self.highlightTitleColor forState:UIControlStateNormal];
        
    }
    else
    {
        [_contentBtn setImage:self.normalImage forState:UIControlStateNormal];
        [_contentBtn setBackgroundImage:MFImageStretchCenter(@"border_btn") forState:UIControlStateNormal];
        [_contentBtn setTitle:self.highlightTitle forState:UIControlStateNormal];
        [_contentBtn setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
    }
}

-(void)onClickBtn:(id)sender
{
    if ([self.touchDelegate respondsToSelector:@selector(onClickActionFloatItemView:)]) {
        [self.touchDelegate onClickActionFloatItemView:self];
    }
}

@end
