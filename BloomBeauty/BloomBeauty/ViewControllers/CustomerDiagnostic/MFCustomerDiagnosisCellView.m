//
//  MFCustomerDiagnosisCellView.m
//  BloomBeauty
//
//  Created by EEKA on 16/1/15.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosisCellView.h"
#import "MFDiagnosticModel.h"
#import "MFDiagnosticContentViewTemplateView.h"

@interface MFCustomerDiagnosisCellView () <MFDiagnosticSelectViewDelegate>
{
    __weak IBOutlet UILabel *_diagnosisTitleLabel;
    __weak IBOutlet UIView *_diagnosisContentView;
    
    __weak IBOutlet NSLayoutConstraint *_diagnosisContentHeightLayout;
    
    MFDiagnosticContentViewTemplateView *_contentSelectGridView;
}

@end

@implementation MFCustomerDiagnosisCellView
@synthesize dataItem = _dataItem;
@synthesize delegate;
@synthesize indexPath;

-(void)awakeFromNib
{
    [super awakeFromNib];
    _contentSelectGridView = [[MFDiagnosticContentViewTemplateView alloc] initWithDiagnosticDataItem:nil];
    _contentSelectGridView.diagnosticSelectViewDelegate = self;
    _contentSelectGridView.frame = _diagnosisContentView.frame;
    _contentSelectGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_diagnosisContentView addSubview:_contentSelectGridView];
}

+(NSMutableAttributedString *)_textWithString:(NSMutableAttributedString *)text withRemarkColor:(UIColor *)remarkColor
{
    NSMutableAttributedString *mText = text;
    
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

-(void)setDiagnosisTitleContent:(NSMutableAttributedString *)content
{
    _diagnosisTitleLabel.font = MFDiagnosticTitleFont;
    _diagnosisTitleLabel.attributedText = [[self class] _textWithString:content
                                                        withRemarkColor:BBDefaultColor];
}

- (void)setQuestionDataItem:(MFDiagnosticQuestionDataItem *)aDiagnosisDataItem
{
    _dataItem = aDiagnosisDataItem;

    [self setDiagnosisTitleContent:_dataItem.showingTitleDescription];
    CGFloat contentViewHeight = [[self class] diagnosisContentHeightForQuestionDataItem:_dataItem];
    _diagnosisContentHeightLayout.constant = contentViewHeight;
    [self layoutIfNeeded];
    [_contentSelectGridView initViewsWithQuestionDataItem:_dataItem];
}

#pragma mark - MFDiagnosticSelectViewDelegate
-(BOOL)shouldSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
{
    if ([self.delegate respondsToSelector:@selector(customerDiagnosisCellView:shouldSelectDiagnosticItem:subIndexPath:)]) {
        return [self.delegate customerDiagnosisCellView:self shouldSelectDiagnosticItem:self.indexPath subIndexPath:subIndexPath];
    }
    return YES;
}

-(void)shouldNotSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
{
    if ([self.delegate respondsToSelector:@selector(customerDiagnosisCellView:shouldNotSelectDiagnosticItem:subIndexPath:)]) {
        [self.delegate customerDiagnosisCellView:self shouldNotSelectDiagnosticItem:self.indexPath subIndexPath:subIndexPath];
    }
}

-(void)didSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
{
    if ([self.delegate respondsToSelector:@selector(customerDiagnosisCellView:didSelectDiagnosticItem:subIndexPath:)]) {
        [self.delegate customerDiagnosisCellView:self didSelectDiagnosticItem:self.indexPath subIndexPath:subIndexPath];
    }
}

-(void)didDeselectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
{
    if ([self.delegate respondsToSelector:@selector(customerDiagnosisCellView:didDeselectDiagnosticItem:subIndexPath:)]) {
        [self.delegate customerDiagnosisCellView:self didDeselectDiagnosticItem:self.indexPath subIndexPath:subIndexPath];
    }
}

#pragma mark - height

+ (float)heightForDiagnosticQuestionDataItem:(MFDiagnosticQuestionDataItem *)dataItem
{
    CGFloat diagnosisContentViewHeight = [[self class] diagnosisContentHeightForQuestionDataItem:dataItem];
    
    return 60 + diagnosisContentViewHeight + 5;
}

+(float)diagnosisContentHeightForQuestionDataItem:(MFDiagnosticQuestionDataItem *)dataItem
{
    CGFloat diagnosisContentViewHeight = [MFDiagnosticContentViewTemplateView heightForQuestionDataItem:dataItem];
    
    return diagnosisContentViewHeight;
}

@end
