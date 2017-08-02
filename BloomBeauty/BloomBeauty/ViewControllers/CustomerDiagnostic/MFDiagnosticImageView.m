//
//  MFDiagnosticImageView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/15.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDiagnosticImageView.h"
#import "MFDiagnosticImageSelectCoverView.h"


@interface MFDiagnosticImageView ()
{
    
    __weak IBOutlet MFUILongPressImageView *_imageView;
    
    __weak IBOutlet MFDiagnosticImageSelectCoverView *_coverView;
    
    __weak IBOutlet UILabel *_remarkLabel;
    
    __weak IBOutlet NSLayoutConstraint *_imageWidthLayout;
    
    __weak IBOutlet NSLayoutConstraint *_imageHeightConstraint;
}

@end


@implementation MFDiagnosticImageView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setSelected:NO];
    _remarkLabel.font = MFDiagnosticFont;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _imageView.userInteractionEnabled = NO;
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    [_coverView setHidden:!_selected];
    [self setTextSelected:_selected];
}

-(void)setTextSelected:(BOOL)selected
{
    UIColor *textColor = [UIColor hx_colorWithHexString:@"888888"];
    UIColor *remarkColor = BBDefaultColor;
    if (selected) {
        textColor = BBDefaultColor;
        remarkColor = MFDarkGrayColor;
    }
    
    NSString *string = _remarkLabel.attributedText.string;
    _remarkLabel.attributedText = [self _textWithString:string
                                      WithRemarkColor:remarkColor
                                          normalColor:textColor];
}

-(void)setImageWidthLayout:(CGFloat)widthConstant height:(CGFloat)heightConstant
{
    _imageWidthLayout.constant = widthConstant;
    _imageHeightConstraint.constant = heightConstant;
}

-(void)setImage:(UIImage *)image remark:(NSMutableAttributedString *)remark
{
    _imageView.image = image;
    _remarkLabel.attributedText = remark;
}

-(void)setImageUrl:(NSString *)imageUrl remark:(NSMutableAttributedString *)remark
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:MFImage(@"questionBlank")];
    _remarkLabel.attributedText = remark;
}

-(void)setImageUrl:(NSString *)imageUrl contentDescription:(NSString *)contentDescription
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:MFImage(@"questionBlank")];
    _remarkLabel.attributedText = [self _textWithString:contentDescription];
    [self setTextSelected:_selected];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(_imageView.frame, point)
        || CGRectContainsPoint(_remarkLabel.frame, point)) {
        return YES;
    }

    return NO;
}

@end
