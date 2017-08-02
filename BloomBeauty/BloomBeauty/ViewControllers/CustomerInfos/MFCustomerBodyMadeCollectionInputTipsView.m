//
//  MFCustomerBodyMadeCollectionInputTipsView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeCollectionInputTipsView.h"

@interface MFCustomerBodyMadeCollectionInputTipsView ()
{
    __weak IBOutlet UIButton *_borderBtn;
    __weak IBOutlet UIImageView *_contentImage;
    __weak IBOutlet UILabel *_descLabel;
    __weak IBOutlet UILabel *_remarkLabel;
}

@end

@implementation MFCustomerBodyMadeCollectionInputTipsView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_borderBtn setBackgroundImage:MFImageStretchCenter(@"zbl39") forState:UIControlStateNormal];
    [_borderBtn setAdjustsImageWhenHighlighted:NO];
}

-(void)setTipsInfo:(NSDictionary *)info
{
    NSString *imageName = info[@"descriptionImageName"];
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"bodyMade" withExtension:@"bundle"]];
    NSString *imagePath = [bundle pathForResource:imageName ofType:nil];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [_contentImage setImage:image];
    
    _descLabel.text = info[@"description"];
    
    NSString *preix = @"量体第一步";
    NSString *remarkText = [NSString stringWithFormat:@"%@：%@",preix,info[@"name"]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:remarkText];
    [attString addAttribute:NSForegroundColorAttributeName value:BBDefaultColor range:NSMakeRange(0, preix.length)];
    _remarkLabel.attributedText = attString;
}

+(CGSize)sizeForTipsInfo:(NSDictionary *)info
{
    CGFloat height = 0;
    NSString *titleDesc = info[@"description"];
    CGFloat titleDecHeight = [self titleDecHeight:titleDesc];;
    height = 241 + 10 + titleDecHeight + 20 + 40;
    
    return CGSizeMake(241, height);
}

+(CGFloat)titleDecHeight:(NSString *)titleDesc
{
    return [titleDesc MFSizeWithFont:[self titleDescFont] maxSize:CGSizeMake(240.0, CGFLOAT_MAX)].height + 20;
}

+(UIFont *)titleDescFont
{
    return [UIFont systemFontOfSize:16.0f];
}

@end
