//
//  MFDiagnosticSelectView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/15.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDiagnosticSelectView.h"

@implementation MFDiagnosticSelectView

@synthesize indexPath,delegate;

-(void)setSelected:(BOOL)selected
{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    BOOL shouldSelected = YES;
    if ([self.delegate respondsToSelector:@selector(shouldSelectDiagnosticItemView:indexPath:)]) {
        shouldSelected = [self.delegate shouldSelectDiagnosticItemView:self indexPath:self.indexPath];
    }
    
    if (!shouldSelected)
    {
        if ([self.delegate respondsToSelector:@selector(shouldNotSelectDiagnosticItemView:indexPath:)]) {
            [self.delegate shouldNotSelectDiagnosticItemView:self indexPath:self.indexPath];
        }
        return;
    }
    
    _selected = !_selected;
    [self setSelected:_selected];
    
    if (_selected)
    {
        if ([self.delegate respondsToSelector:@selector(didSelectDiagnosticItemView:indexPath:)
             ])
        {
            [self.delegate didSelectDiagnosticItemView:self indexPath:self.indexPath];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didDeselectDiagnosticItemView:indexPath:)
             ])
        {
            [self.delegate didDeselectDiagnosticItemView:self indexPath:self.indexPath];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

-(NSMutableAttributedString *)_textWithString:(NSString *)text
{
    return [self _textWithString:text WithRemarkColor:MFDiagnostisRemarkColor];
}

-(NSMutableAttributedString *)_textWithString:(NSString *)text WithRemarkColor:(UIColor *)remarkColor
{
    return [self _textWithString:text
                 WithRemarkColor:remarkColor
                     normalColor:[UIColor hx_colorWithHexString:@"888888"]];
}

-(NSMutableAttributedString *)_textWithString:(NSString *)text
                              WithRemarkColor:(UIColor *)remarkColor
                                  normalColor:(UIColor *)normolColor
{
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
    
    [mText addAttribute:NSForegroundColorAttributeName value:normolColor range:NSMakeRange(0, mText.length)];
    
    NSArray *bracketsResults = [[[self class] regexBrackets] matchesInString:mText.string options:kNilOptions range:NSMakeRange(0, mText.length)];
    for (NSTextCheckingResult *brackets in bracketsResults) {
        NSRange bracketsRange = brackets.range;
        [mText addAttribute:NSForegroundColorAttributeName value:remarkColor range:bracketsRange];
    }
    
    return mText;
}

+ (NSRegularExpression *)regexBrackets {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //匹配括号内的内容
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\（.*\\）" options:kNilOptions error:NULL];
    });
    return regex;
}


@end
