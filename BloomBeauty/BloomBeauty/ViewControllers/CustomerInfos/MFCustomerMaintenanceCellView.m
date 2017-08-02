//
//  MFCustomerMaintenanceCellView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/28.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceCellView.h"
#import "MFCustomerMaintenanceModel.h"
#import "TTTAttributedLabel.h"
#import "MFCustomerMaintenanceRichView.h"


#define TitlePading 50
#define TitleTopPading 10
#define TitleFont 18.0
#define FootPading 10

static inline NSRegularExpression * RegexExpression() {
    static NSRegularExpression *_regularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\（.*\\）" options:kNilOptions error:NULL];
    });
    
    return _regularExpression;
}

@interface MFCustomerMaintenanceCellView ()<TTTAttributedLabelDelegate>
{
    TTTAttributedLabel *_titleLabel;
    MFCustomerMaintenanceRichView *_contentsRichView;
    
    MFCustomerMaintenanceModel *m_model;
    MFCustomerMaintenanceContentModel *m_contentModel;
}

@end

@implementation MFCustomerMaintenanceCellView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:TitleFont];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        _contentsRichView = [[MFCustomerMaintenanceRichView alloc] initWithFrame:CGRectZero];
        _contentsRichView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentsRichView];
    }
    
    return self;
}

-(void)setMaintenanceModel:(MFCustomerMaintenanceModel *)model
         contentModelIndex:(NSInteger)index
{
    m_model = model;
    m_contentModel = model.contentArray[index];
    BOOL multiContents = model.boolMultiContents;
    
    NSString *title = m_contentModel.title;
    
    [_titleLabel setHidden:YES];
    if (multiContents) {
        [_titleLabel setHidden:NO];
        
        NSString *titleString = title;
        if (m_contentModel.titleRemark) {
            titleString = [titleString stringByAppendingString:m_contentModel.titleRemark];
        }
        
        CGSize titleSize = [[self class] titleHeight:titleString
                                      availableWidth:CGRectGetWidth(self.frame) - 2 *TitlePading
                                                font:_titleLabel.font];
        
        [_titleLabel setFrame:CGRectMake(TitlePading, TitleTopPading, titleSize.width, titleSize.height)];
        
        NSMutableAttributedString * (^configureBlock) (NSMutableAttributedString *) = ^NSMutableAttributedString *(NSMutableAttributedString *inheritedString)
        {
            NSRegularExpression *regexp = RegexExpression();
            NSArray *bracketsResults = [regexp matchesInString:inheritedString.string options:kNilOptions range:NSMakeRange(0, [inheritedString length])];
            for (NSTextCheckingResult *brackets in bracketsResults) {
                NSRange bracketsRange = brackets.range;
                [inheritedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:bracketsRange];
                [inheritedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:BBDefaultColor range:bracketsRange];
            }
            
            return inheritedString;
        };
        
        [_titleLabel setText:titleString afterInheritingLabelAttributesAndConfiguringWithBlock:configureBlock];
    }
    
    CGFloat contentMaxWidth = CGRectGetWidth(self.frame) - 2 *TitlePading - 30;
    CGSize contentSize = [MFCustomerMaintenanceRichView contentSize:m_contentModel availableWidth:contentMaxWidth];
    [_contentsRichView setFrame:CGRectMake(TitlePading + 30, CGRectGetMaxY(_titleLabel.frame)+TitleTopPading, contentSize.width, contentSize.height)];
    [_contentsRichView setMaintenanceContentModel:m_contentModel];

}

+(CGFloat)cellHeightForMaintenanceModel:(MFCustomerMaintenanceModel *)model
                      contentModelIndex:(NSInteger)index
                        availableWidth:(CGFloat)availableWidth
{
    BOOL hasTitle = model.boolMultiContents;
    
    MFCustomerMaintenanceContentModel *contentModel = model.contentArray[index];
    NSString *title = contentModel.title;
    
    CGFloat titleHeight = 0;
    if (hasTitle) {
        CGSize titleSize = [self titleHeight:title
                              availableWidth:availableWidth
                                        font:[UIFont systemFontOfSize:TitleFont]];
        titleHeight = titleSize.height;
    }
    
    CGFloat contentHeight = [MFCustomerMaintenanceRichView contentSize:contentModel availableWidth:availableWidth - 30].height;
    return TitleTopPading + titleHeight + TitleTopPading + contentHeight + FootPading;
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
