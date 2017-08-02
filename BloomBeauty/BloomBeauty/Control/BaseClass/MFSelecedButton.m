//
//  MFSelecedButton.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/12.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSelecedButton.h"

@interface MFSelecedButton ()
{
   __weak UILabel *_textlabel;
}

@end


@implementation MFSelecedButton
@synthesize normalBackgroundImage,normalTextColor,selectedBackgroundImage,selectedTextColor;
@synthesize normalImage,selectedImage;
@synthesize textlabel = _textlabel;

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initCommon];
    [self addTarget:self action:@selector(onClickBtnSelf:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initCommon
{
    self.normalTextColor = MFDarkGrayColor;
    self.selectedTextColor = BBDefaultColor;
    [self setSelected:NO];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    
    return self;
}

-(void)setText:(NSString *)text
{
    _textlabel.text = text;
}

-(void)setTextEdgeInsets:(UIEdgeInsets)inset
{
    
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        [self setBackgroundImage:self.selectedBackgroundImage forState:UIControlStateNormal];
        if (self.selectedImage) {
            [self setImage:self.selectedImage forState:UIControlStateNormal];
        }
        _textlabel.textColor = self.selectedTextColor;
    }
    else
    {
        if (self.normalImage) {
            [self setImage:self.normalImage forState:UIControlStateNormal];
        }
        [self setBackgroundImage:self.normalBackgroundImage forState:UIControlStateNormal];
        _textlabel.textColor = self.normalTextColor;
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    //http://www.jianshu.com/p/57b2c41448bf
}

-(void)onClickBtnSelf:(id)sender
{
    if ([self.touchDelegate respondsToSelector:@selector(OnTouchDown:)]) {
        [self.touchDelegate OnTouchDown:self];
    }
}

@end
