//
//  MFCustomerBodyMadeUnderwearItemResultView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeUnderwearItemResultView.h"
#import "MFCustomerBodyMadeModel.h"

@interface MFCustomerBodyMadeUnderwearItemResultView ()
{
    NSMutableAttributedString *_contentString;
    
    CTFrameRef m_frame;
}

@end

@implementation MFCustomerBodyMadeUnderwearItemResultView

+(CGSize)contentSize:(MFCustomerBodyMadeUnderWearModel *)model availableWidth:(CGFloat)availableWidth
{
    NSMutableAttributedString *contentAttString = [self contentResultAttStringForUnderWearModel:model];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentAttString);
    CGSize restrictSize = CGSizeMake(availableWidth, CGFLOAT_MAX);
    CGSize availableSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    
    return CGSizeMake(availableWidth, availableSize.height);
}

-(void)setUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)model
{
    _contentString = [[self class] contentResultAttStringForUnderWearModel:model];
    
    [self drawContentView];
}

-(void)drawContentView
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_contentString);
    CGSize restrictSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    
    CGRect textFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), textSize.height);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textFrame);
    
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


+(NSMutableAttributedString *)contentResultAttStringForUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)model
{
    
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] init];
    
    NSMutableArray *questions = model.questions;
    NSMutableArray *selectedQuestions = model.selectedQuestions;
    
    NSString *title = model.showingTitleDescription.string;
    NSString *resultString = [[self class] questionsResultString:questions selectedQuestions:selectedQuestions];
    
    NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] initWithString:title attributes:[self titleDefaultAttributes]];
    NSMutableAttributedString *questionsResultAttStr = [[NSMutableAttributedString alloc] initWithString:resultString attributes:[self questionsResultStringDefaultAttributes]];
    
    if (selectedQuestions.count == 0) {
        UIColor *color = [UIColor hx_colorWithHexString:@"989898"];
        questionsResultAttStr = [[NSMutableAttributedString alloc] initWithString:@"(未提交数据)" attributes:[self questionsResultStringDefaultAttributes:color]];
    }
    
    [contentString appendAttributedString:titleAttStr];
    [contentString appendAttributedString:questionsResultAttStr];
    
    long number = 30;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [contentString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:(NSRange){titleAttStr.string.length - 1,1}];
    CFRelease(num);
    
    NSMutableParagraphStyle *titleParagraphStyle = [NSMutableParagraphStyle new];
    titleParagraphStyle.firstLineHeadIndent = 56.0f;  //首行缩进
    titleParagraphStyle.headIndent = 0.0f;          //每行缩进
    titleParagraphStyle.lineSpacing = 5.0f;    //行距
    titleParagraphStyle.paragraphSpacing = 10.0f;    //段前间隔,段与段之间的距离
    titleParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [contentString addAttribute:NSParagraphStyleAttributeName value:titleParagraphStyle range:NSMakeRange(0, contentString.length)];
    
    
    return contentString;
}

+(NSString *)questionsResultString:(NSArray *)questions selectedQuestions:(NSArray *)array
{
    NSString *string = nil;
    NSMutableArray *stringArray = [NSMutableArray array];
    
    for (int i = 0; i < questions.count; i++) {
        MFCustomerBodyMadeUnderWearQuestionModel *questionModel = questions[i];
        NSString *match = questionModel.match;
        NSString *desc = questionModel.titleDescription;
        
        if ([array containsObject:match])
        {
            [stringArray addObject:desc];
        }
    }
    
    string = [stringArray componentsJoinedByString:@"、"];
    
    return string;
}

+ (CTFontRef)ctFontRefFromUIFont:(UIFont *)font {
    CTFontRef ctfont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    return CFAutorelease(ctfont);
}


+ (NSMutableDictionary *)titleDefaultAttributes
{
    CTFontRef fontRef = [self ctFontRefFromUIFont:[UIFont systemFontOfSize:15.0]];
    
    CGFloat lineSpacing = 0;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = [UIColor hx_colorWithHexString:@"989898"];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    return dict;
}

+ (NSMutableDictionary *)questionsResultStringDefaultAttributes
{
    return [self questionsResultStringDefaultAttributes:[UIColor hx_colorWithHexString:@"2d2c2c"]];
}

+ (NSMutableDictionary *)questionsResultStringDefaultAttributes:(UIColor *)textColor
{
    CTFontRef fontRef = [self ctFontRefFromUIFont:[UIFont systemFontOfSize:15.0]];
    
    CGFloat lineSpacing = 0;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    
    return dict;
}

@end
