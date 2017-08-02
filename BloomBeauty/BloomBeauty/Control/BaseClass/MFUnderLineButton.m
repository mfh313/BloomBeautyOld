//
//  MFUnderLineButton.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUnderLineButton.h"

@interface MFUnderLineButton ()
{
    __weak IBOutlet UILabel *_underLineLabel;
}

@end


@implementation MFUnderLineButton

-(void)awakeFromNib
{
    _underLineLabel.hidden = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}

- (void)setUnderLineText:(NSString *)text
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BBDefaultColor range:(NSRange){0,[text length]}];
    [attributeString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){0,[text length]}];
    [self setAttributedTitle:attributeString forState:UIControlStateNormal];
//    _underLineLabel.attributedText = attributeString;
}

@end
