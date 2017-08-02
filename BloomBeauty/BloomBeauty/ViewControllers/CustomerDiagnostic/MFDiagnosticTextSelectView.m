//
//  MFDiagnosticTextSelectView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/15.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDiagnosticTextSelectView.h"

@interface MFDiagnosticTextSelectView ()
{
    
    __weak IBOutlet UIButton *_checkBox;
    
    __weak IBOutlet UILabel *_textLabel;
}

@end

@implementation MFDiagnosticTextSelectView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setSelected:NO];
    BOOL testBgColor = NO;
    if (testBgColor) {
        [self testBgColor];
    }
    _textLabel.font = MFDiagnosticFont;
}

-(void)testBgColor
{
    self.backgroundColor = [UIColor blueColor];
    _textLabel.backgroundColor = [UIColor redColor];
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (_selected) {
        [_checkBox setImage:MFImage(@"zbl23") forState:UIControlStateNormal];
    }
    else
    {
        [_checkBox setImage:MFImage(@"zbl34") forState:UIControlStateNormal];
    }
    
    [self setTextSelected:_selected];
}

-(void)setTextContent:(NSString *)text
{
    _textLabel.attributedText = [self _textWithString:text];
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
    
    NSString *string = _textLabel.attributedText.string;
    _textLabel.attributedText = [self _textWithString:string
                                      WithRemarkColor:remarkColor
                                          normalColor:textColor];
}

-(void)setTextSelected:(BOOL)selected normalHexColor:(NSString *)desNormalHexColor selectedHexColor:(NSString *)desSelectedHexColor
{
    UIColor *textColor = [UIColor hx_colorWithHexString:@"888888"];
    UIColor *remarkColor = BBDefaultColor;
    if (selected) {
        textColor = BBDefaultColor;
        remarkColor = MFDarkGrayColor;
        if (desSelectedHexColor) {
            textColor = [UIColor hx_colorWithHexString:desSelectedHexColor];
        }
    }
    else
    {
        if (desNormalHexColor) {
            textColor = [UIColor hx_colorWithHexString:desNormalHexColor];
        }
    }
    
    NSString *string = _textLabel.attributedText.string;
    _textLabel.attributedText = [self _textWithString:string
                                      WithRemarkColor:remarkColor
                                          normalColor:textColor];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGFloat touchRespondMaxX = CGRectGetMaxX(_textLabel.frame) + 20;
//    CGPoint touchPoint = [touch previousLocationInView:self];
//    if (touchPoint.x <= touchRespondMaxX) {
//        [super touchesBegan:touches withEvent:event];
//    }
//}
@end
