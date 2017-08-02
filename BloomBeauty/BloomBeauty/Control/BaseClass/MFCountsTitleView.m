//
//  MFCountsTitleView.m
//  BloomBeauty
//
//  Created by EEKA on 16/3/18.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCountsTitleView.h"

@interface MFCountsTitleView ()
{
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet MFUIButton *_brandFilterBtn;
    
    __weak IBOutlet UILabel *_seletedBrandLabel;
    
    
    
}

@end

@implementation MFCountsTitleView
@synthesize delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_brandFilterBtn setHidden:YES];
    _seletedBrandLabel.textColor = [UIColor whiteColor];
    _titleLabel.textColor = [UIColor whiteColor];
}

-(void)setNavTitle:(NSString *)title suffixString:(NSString *)suffixString sufColor:(UIColor *)color
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:title];
    if (suffixString)
    {
        [content appendAttributedString:[[NSMutableAttributedString alloc] initWithString:suffixString]];
        [content addAttribute:NSForegroundColorAttributeName value:color range:(NSRange){title.length,suffixString.length}];
    }
    
    _titleLabel.attributedText = content;
}

-(void)setNavTitle:(NSString *)title
{
    _titleLabel.text = title;
}


-(void)setCanSelectBrand:(BOOL)canSelect
{
    [_brandFilterBtn setHidden:!canSelect];
    
    _titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBrandFilterBtn:)];
    [_titleLabel addGestureRecognizer:tapGes];
}

-(void)setSelectBrandTitle:(NSString *)brandName
{
    _seletedBrandLabel.text = brandName;
}

- (IBAction)onClickBrandFilterBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onClickSelectBrandButton)]) {
        [self.delegate onClickSelectBrandButton];
    }
}

@end
