//
//  MFDiagnosticQuestionDressingSolveView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFDiagnosticQuestionDressingSolveView.h"
#import "MFCustomerBodyMadeModel.h"

static inline NSRegularExpression * RegexExpression() {
    static NSRegularExpression *_regularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\（.*\\）" options:kNilOptions error:NULL];
    });
    
    return _regularExpression;
}

@interface MFDiagnosticQuestionDressingSolveView ()
{
    __weak IBOutlet UILabel *_diagnosticTitleLabel;
    __weak IBOutlet UIImageView *_diagnosticImageTapView;
    
    __weak IBOutlet NSLayoutConstraint *_imageWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *_imageHeightConstraint;
    MFQuestionDressingSolveModel *m_dressingSolveModel;
    MFCustomerBodyMadeUnderWearModel *m_underWearModel;
    NSMutableArray *_imageSubviews;
    NSMutableArray *_imageShowingSubviews;
    
    BOOL _isEditing;
}

@end

@implementation MFDiagnosticQuestionDressingSolveView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _diagnosticTitleLabel.font = [self titleFont];
    _diagnosticImageTapView.userInteractionEnabled = YES;
    _diagnosticImageTapView.contentMode = UIViewContentModeCenter;
    
    _imageSubviews = [NSMutableArray array];
    _imageShowingSubviews = [NSMutableArray array];
    
    [self addLabels:10];
    
    [self setupEvents];
}

- (void)setupEvents {
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(userTapGestureDetected:)];
    tapRecognizer.delaysTouchesBegan = YES;
    [_diagnosticImageTapView addGestureRecognizer:tapRecognizer];
    
    _diagnosticImageTapView.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
    if (!_isEditing) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:_diagnosticImageTapView];
    
    NSInteger touchContentIndex = NSNotFound;
    for (int i = 0; i < _imageShowingSubviews.count; i++) {
        UIView *label = _imageShowingSubviews[i];
        CGRect viewRespondFrame = CGRectInset(label.frame, -20, -20);
        if (CGRectContainsPoint(viewRespondFrame, point)) {
            touchContentIndex = i;
            break;
        }
    }
    
    if (touchContentIndex == NSNotFound) {
        return;
    }
    
    NSMutableArray *contents = m_dressingSolveModel.contents;
    
    MFDiagnosticQuestionDressingSolveContentDataItem *contentItem = contents[touchContentIndex];
    
    NSString *realMatch  = contentItem.realMatch;
    
    NSMutableArray *selectedQuestions = m_underWearModel.selectedQuestions;
    
    if ([selectedQuestions containsObject:realMatch]) {
        [selectedQuestions removeObject:realMatch];
    }
    else
    {
        NSInteger maxSelectedCount = m_dressingSolveModel.maxSelectedCount;
        if (maxSelectedCount <= selectedQuestions.count) {
            NSLog(@"最多只能选择=%@个",@(maxSelectedCount));
            return;
        }
        
        [selectedQuestions addObject:realMatch];
    }
    
    [self setSelectQuestions:selectedQuestions];
    
}

-(void)addLabels:(NSInteger)labelCount
{
    for (int i = 0; i < labelCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [self titleFont];
        [_imageSubviews addObject:label];
    }
}

-(void)setUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel editing:(BOOL)editing
{
    m_underWearModel = underWearModel;
    m_dressingSolveModel = underWearModel.dressingSolveModel;
    _isEditing = editing;
    
    NSMutableAttributedString *showingAttString = [[NSMutableAttributedString alloc] initWithAttributedString:underWearModel.showingTitleDescription];
    
    if (!editing) {
        showingAttString = [[NSMutableAttributedString alloc] initWithAttributedString:underWearModel.resultTitleDescription];
    }
    
    NSRange range = NSMakeRange(0, [showingAttString length]);
    UIColor *titleColor = [UIColor hx_colorWithHexString:@"2d2c2c"];
    if (!editing) {
        titleColor = [UIColor hx_colorWithHexString:@"989898"];
    }
    [showingAttString addAttribute:(NSString *)NSForegroundColorAttributeName value:titleColor range:range];
    
    NSRegularExpression *regexp = RegexExpression();
    NSArray *bracketsResults = [regexp matchesInString:showingAttString.string options:kNilOptions range:NSMakeRange(0, [showingAttString length])];
    for (NSTextCheckingResult *brackets in bracketsResults) {
        NSRange bracketsRange = brackets.range;
        [showingAttString removeAttribute:(NSString *)NSForegroundColorAttributeName range:bracketsRange];
        [showingAttString addAttribute:(NSString *)NSForegroundColorAttributeName value:BBDefaultColor range:bracketsRange];
    }
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (boldFont) {
        
        [showingAttString removeAttribute:(NSString *)kCTFontAttributeName range:range];
        [showingAttString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:range];
        
        CFRelease(boldFont);
    }
    
    _diagnosticTitleLabel.attributedText = showingAttString;
    
    _imageWidthConstraint.constant = m_dressingSolveModel.contentImageWidth;
    _imageHeightConstraint.constant = m_dressingSolveModel.contentImageHeight;
    [_diagnosticImageTapView sd_setImageWithURL:[NSURL URLWithString:m_dressingSolveModel.imageUrl] placeholderImage:MFImage(@"questionBlank")];
    
    NSMutableArray *selectedQuestions = m_underWearModel.selectedQuestions;
    [self setSelectQuestions:selectedQuestions];
}

-(void)setSelectQuestions:(NSMutableArray *)resultSelectedArray
{
    NSMutableArray *contents = m_dressingSolveModel.contents;
    if (contents.count > _imageSubviews.count)
    {
        [self addLabels:contents.count - _imageSubviews.count];
    }
    
    [_diagnosticImageTapView removeAllSubViews];
    [_imageShowingSubviews removeAllObjects];
    
    for (int i = 0; i < contents.count; i++) {
        [_imageShowingSubviews addObject:_imageSubviews[i]];
    }
    
    for (int i = 0; i < contents.count; i++) {
        
        MFDiagnosticQuestionDressingSolveContentDataItem *contentItem = contents[i];
        
        NSString *pointType = contentItem.pointType;
        NSString *pointX  = contentItem.pointX;
        NSString *pointY  = contentItem.pointY;
        NSString *realMatch  = contentItem.realMatch;
        NSString *contentDescription  = contentItem.contentDescription;
        
        CGPoint point = CGPointMake(pointX.floatValue, pointY.floatValue);
        CGSize contentSize = [contentDescription MFSizeWithFont:[self titleFont] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGRect contentFrame = CGRectZero;
        if ([pointType isEqualToString:@"left"])
        {
            contentFrame = CGRectMake(point.x - contentSize.width, point.y - contentSize.height/2, contentSize.width, contentSize.height);
        }
        else if ([pointType isEqualToString:@"right"])
        {
            contentFrame = CGRectMake(point.x + contentSize.width, point.y - contentSize.height/2, contentSize.width, contentSize.height);
        }
        
        UILabel *showingLabel = _imageShowingSubviews[i];
        showingLabel.frame = contentFrame;
        showingLabel.text = contentDescription;
        showingLabel.backgroundColor = [UIColor whiteColor];
        [_diagnosticImageTapView addSubview:showingLabel];
        
        
        if ([resultSelectedArray containsObject:realMatch]) {
            showingLabel.textColor = [self highlightColor];
        }
        else
        {
            showingLabel.textColor = [self normalColor];
        }
    }
    
    
}

-(UIFont *)titleFont
{
    return [UIFont systemFontOfSize:15.0];
}

-(UIColor *)normalColor
{
    return [UIColor hx_colorWithHexString:@"2d2c2c"];
}

-(UIColor *)highlightColor
{
    return BBDefaultColor;
}

+(CGSize)sizeForUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel availableWidth:(CGFloat)availableWidth editing:(BOOL)editing
{
    MFQuestionDressingSolveModel *dressingSolveModel = underWearModel.dressingSolveModel;
    return CGSizeMake(availableWidth, 55 + dressingSolveModel.contentImageHeight + 5);
}


@end
