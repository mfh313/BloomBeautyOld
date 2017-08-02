//
//  MFTabItemButton.m
//  BloomBeauty
//
//  Created by EEKA on 16/7/7.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFTabItemButton.h"


@implementation MFTabItemDataItem

@end


#pragma mark - MFTabItemButton
@interface MFTabItemButton ()
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_titleLabel;
    
    
}

@end

@implementation MFTabItemButton
@synthesize normalImage;
@synthesize normalTitle;
@synthesize highlightImage;
@synthesize highlightTitle;
@synthesize normalTitleColor;
@synthesize highlightTitleColor;
@synthesize isTouchHighlighted;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.normalTitleColor = [UIColor hx_colorWithHexString:@"777a81"];
    self.highlightTitleColor = BBDefaultColor;
    
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
        _imageView.image = self.highlightImage;
        _titleLabel.text = self.highlightTitle;
        _titleLabel.textColor = self.highlightTitleColor;
    }
    else
    {
        _imageView.image = self.normalImage;
        _titleLabel.text = self.normalTitle;
        _titleLabel.textColor = self.normalTitleColor;
    }
}


@end
