//
//  MFCustomerBodyMadeUnderwearItemInputView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeUnderwearItemInputView.h"
#import "MFCustomerBodyMadeModel.h"
#import "TTTAttributedLabel.h"
#import "MFCustomerBodyMadeUnderwearContentRichView.h"

#define TitleTopPading 15
#define TitleFont [UIFont systemFontOfSize:15.0]

@interface MFCustomerBodyMadeUnderwearItemInputView ()
{
    MFCustomerBodyMadeUnderWearModel *m_underWearModel;
    TTTAttributedLabel *_titleLabel;
    MFCustomerBodyMadeUnderwearContentRichView *_contentRichView;
}

@end

@implementation MFCustomerBodyMadeUnderwearItemInputView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = TitleFont;
        _titleLabel.textColor = [UIColor hx_colorWithHexString:@"2d2c2c"];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        _contentRichView = [[MFCustomerBodyMadeUnderwearContentRichView alloc] initWithFrame:CGRectZero];
        _contentRichView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentRichView];
        
    }
    
    return self;
}

-(void)setBodyMadeUnderWearModel:(MFCustomerBodyMadeUnderWearModel*)underWearModel
{
    m_underWearModel = underWearModel;
    
    NSString *title = m_underWearModel.showingTitleDescription.string;
    
    CGSize titleSize = [[self class] titleHeight:title availableWidth:CGRectGetWidth(self.bounds) - 120 font:_titleLabel.font];
    
    [_titleLabel setFrame:CGRectMake(56, 0, titleSize.width, titleSize.height)];
    
    NSMutableAttributedString * (^configureBlock) (NSMutableAttributedString *) = ^NSMutableAttributedString *(NSMutableAttributedString *inheritedString)
    {
        return inheritedString;
    };
    
    [_titleLabel setText:title afterInheritingLabelAttributesAndConfiguringWithBlock:configureBlock];
    
    
    //setContent
    CGFloat contentMaxWidth = CGRectGetWidth(self.frame) - 120;
    CGSize contentSize = [MFCustomerBodyMadeUnderwearContentRichView contentSize:m_underWearModel availableWidth:contentMaxWidth];
    [_contentRichView setFrame:CGRectMake(86, CGRectGetMaxY(_titleLabel.frame) + TitleTopPading, contentSize.width, contentSize.height)];
    [_contentRichView setUnderWearModel:m_underWearModel];
    
}

+(CGSize)cellSizeForBodyMadeUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)model
                               availableWidth:(CGFloat)availableWidth
{
    NSString *title = model.titleDescription;
    
    CGSize titleSize = [self  titleHeight:title availableWidth:availableWidth font:TitleFont];
    
    CGSize contentSize = [MFCustomerBodyMadeUnderwearContentRichView contentSize:model availableWidth:availableWidth-120];
    
    CGFloat height = titleSize.height + TitleTopPading + contentSize.height + 15;
    
    CGSize size = CGSizeMake(availableWidth, height);

    return size;
}

+(CGSize)titleHeight:(NSString *)title
      availableWidth:(CGFloat)availableWidth
                font:(UIFont *)font
{
    UIFont *systemFont = font;
    CGSize textSize = CGSizeMake(availableWidth, CGFLOAT_MAX);
    NSDictionary *attributes = @{
                                 NSFontAttributeName : systemFont,
                                 };
    CGSize sizeWithFont = [title boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return sizeWithFont;
}

@end
