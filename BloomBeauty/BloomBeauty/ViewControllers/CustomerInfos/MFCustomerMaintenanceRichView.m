//
//  MFCustomerMaintenanceRichView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/4.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceRichView.h"
#import "MFCustomerMaintenanceModel.h"

@interface MFCustomerMaintenanceRichView ()
{
    MFCustomerMaintenanceContentModel *m_contentModel;
    
    NSMutableAttributedString *contentAttString;
    
    CTFrameRef m_frame;
}

@end

@implementation MFCustomerMaintenanceRichView

+ (UIColor *)textNormalColor
{
    return [UIColor hx_colorWithHexString:@"989898"];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupEvents];
    }
    
    return self;
}

- (void)setupEvents {
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(userTapGestureDetected:)];
    tapRecognizer.delaysTouchesBegan = YES;
    [self addGestureRecognizer:tapRecognizer];
    
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    
    CFIndex touchIndex = [[self class] touchContentOffsetInView:self atPoint:point frame:m_frame];
    
    [self touchInViewIndex:touchIndex frame:m_frame];
}

-(void)touchInViewIndex:(CFIndex)touchIndex frame:(CTFrameRef)frame
{
    CFArrayRef lines = CTFrameGetLines(frame);
    if (!lines) {
        return;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    NSRange touchRange = {NSNotFound, NSNotFound};
    
    for (int i = 0; i < count; i++) {
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
        
        for (int j = 0; j < runs.count; j++) {
            CTRunRef run = (__bridge CTRunRef)runs[j];
            
            CFRange range = CTRunGetStringRange(run);
            
            if (range.location <= touchIndex
                && range.location + range.length >= touchIndex)
            {
                NSLog(@"ssssssssssssssss");
                touchRange = NSMakeRange(range.location, range.length);
                break;
            }
            
        }
    }
    
    if (touchRange.location == NSNotFound) {
        return;
    }
    
    [self setSelectedRange:touchRange];

}

-(void)setSelectedRange:(NSRange)selectedRange
{
    NSString *selectedQuestionsMatchContent = nil;
    NSMutableArray *questions = m_contentModel.questions;

    for (int i = 0; i < questions.count; i++) {
        MFCustomerMaintenanceContentQuestionModel *questionModel = questions[i];
        NSRange matchRange = questionModel.questionRange;
        NSString *matchContent = questionModel.matchContent;
        
        if (NSLocationInRange(selectedRange.location, matchRange)) {

            NSLog(@"match=%@",matchContent);
            selectedQuestionsMatchContent = matchContent;
            [self setSelectedQuestionsMatchContent:selectedQuestionsMatchContent];
        }
    }
}

-(void)setSelectedQuestionsMatchContent:(NSString *)sMatchContent
{
    NSMutableArray *selectedQuestions = m_contentModel.selectedQuestions;
    BOOL canMultipleChoice = m_contentModel.canMultipleChoice;
    
    if (!canMultipleChoice) {
        
        if ([selectedQuestions containsObject:sMatchContent]) {
            [selectedQuestions removeAllObjects];
        }
        else
        {
            [selectedQuestions removeAllObjects];
            [selectedQuestions addObject:sMatchContent];
        }
    }
    else
    {
        if ([selectedQuestions containsObject:sMatchContent]) {
            [selectedQuestions removeObject:sMatchContent];
        }
        else
        {
            [selectedQuestions addObject:sMatchContent];
        }
    }
    
    contentAttString = [[self class] contentModelQuestionsAttStr:m_contentModel];
    
    [self drawContentAttString];
}

-(void)setMaintenanceContentModel:(MFCustomerMaintenanceContentModel *)model
{
    m_contentModel = model;
    NSMutableAttributedString *attr = [[self class] contentModelQuestionsAttStr:m_contentModel];
    
    contentAttString = attr;
    
    [self drawContentAttString];
    
}

-(void)drawContentAttString
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentAttString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    m_frame = frame;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!m_frame) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw(m_frame, context);
    
}

+(NSMutableAttributedString *)contentModelQuestionsAttStr:(MFCustomerMaintenanceContentModel *)contentModel
{
    NSMutableArray *questions = contentModel.questions;
    NSMutableArray *selectedQuestions = contentModel.selectedQuestions;
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] init];
    
    NSUInteger lineLoc = 0;
    for (int i = 0; i < questions.count; i++) {
        MFCustomerMaintenanceContentQuestionModel *questionModel = questions[i];
        NSString *contentTitle = questionModel.title;
        
        NSRange range = NSMakeRange(lineLoc, contentTitle.length);
        questionModel.questionRange = range;
        
        lineLoc = lineLoc + contentTitle.length;
        
        NSMutableAttributedString *contentAttStr = [[NSMutableAttributedString alloc] initWithString:contentTitle];
        
        [contentString appendAttributedString:contentAttStr];
        
    }
    
    [contentString setAttributes:[[self class] defaultAttributes] range:NSMakeRange(0, contentString.length)];
    
    for (int i = 0; i < questions.count; i++) {
        MFCustomerMaintenanceContentQuestionModel *questionModel = questions[i];
        
        if (i >= 1 && i <= questions.count - 1) {
            long number = 40;
            CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
            [contentString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:(NSRange){questionModel.questionRange.location-1,1}];
            CFRelease(num);
        }
        
    }
    
    //setSelected arrea
    for (int i = 0; i < questions.count; i++) {
        MFCustomerMaintenanceContentQuestionModel *questionModel = questions[i];
        
        NSString *matchContent = questionModel.matchContent;
        if ([selectedQuestions containsObject:matchContent]) {
            [contentString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:questionModel.questionRange];
            [contentString addAttribute:(NSString *)kCTForegroundColorAttributeName value:BBDefaultColor range:questionModel.questionRange];
        }
        
    }
    
    return contentString;
}

+(CGSize)contentHeight:(NSMutableAttributedString *)attributedString
        availableWidth:(CGFloat)availableWidth
                  font:(UIFont *)font
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributedString);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(availableWidth, CGFLOAT_MAX), NULL);
    CFRelease(framesetter);
    return fitSize;
}

+(CGSize)contentSize:(MFCustomerMaintenanceContentModel *)model availableWidth:(CGFloat)availableWidth
{
    NSMutableAttributedString *attr = [[self class] contentModelQuestionsAttStr:model];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
    CGSize restrictSize = CGSizeMake(availableWidth, CGFLOAT_MAX);
    CGSize availableSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    return availableSize;
}

+ (CTFontRef)ctFontRefFromUIFont:(UIFont *)font {
    CTFontRef ctfont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    return CFAutorelease(ctfont);
}

+ (NSMutableDictionary *)defaultAttributes
{
    CTFontRef fontRef = [self ctFontRefFromUIFont:[UIFont systemFontOfSize:20.0]];
    
    CGFloat lineSpacing = 0;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = [self textNormalColor];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    return dict;
}

+(CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point frame:(CTFrameRef)frame
{
    CFArrayRef lines = CTFrameGetLines(frame);
    if (!lines) {
        return -1;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    //翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        //获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    
    return idx;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

@end
