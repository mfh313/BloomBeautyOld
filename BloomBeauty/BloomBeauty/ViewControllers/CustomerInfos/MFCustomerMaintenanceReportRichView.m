//
//  MFCustomerMaintenanceReportRichView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/5.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceReportRichView.h"
#import "MFCustomerMaintenanceModel.h"
#import "MFCustomerMaintenanceReportRichContentView.h"

@interface MFCustomerMaintenanceReportRichView ()
{
    NSMutableArray *_maintenanceTemplates;
    NSMutableDictionary *_maintenanceResults;
    
    NSMutableAttributedString *_contentString;
    MFCustomerMaintenanceReportRichContentView *_contentView;
}

@end

@implementation MFCustomerMaintenanceReportRichView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        self.contentInset = UIEdgeInsetsMake(30, 0, 100, 0);
        
        _contentView = [[MFCustomerMaintenanceReportRichContentView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    
    return self;
}


-(void)setMaintenanceTemplates:(NSMutableArray *)templates results:(NSMutableDictionary *)results
{
    _maintenanceTemplates = templates;
    _maintenanceResults = results;
    
    [self makeRichAttString];
}

-(void)makeRichAttString
{
    //TODO:此处逻辑太混乱，需要重新写
    NSMutableArray *sectionAttArray = [NSMutableArray array];
    
    NSDictionary *sectionTitleAttributes = [[self class] sectionTitleDefaultAttributes];
    NSDictionary *titleAttributes = [[self class] titleDefaultAttributes];
    NSDictionary *questionsResultAttributes = [[self class] questionsResultStringDefaultAttributes];
    
    NSMutableAttributedString *tabAttr = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
    
    for (int i = 0; i < _maintenanceTemplates.count; i++) {
        MFCustomerMaintenanceModel *model = _maintenanceTemplates[i];
        
        if (model.boolMultiContents) {
            NSString *sectionTitleDesc = model.titleDesc;
            
            NSMutableAttributedString *string = [NSMutableAttributedString new];
            
            NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] initWithString:sectionTitleDesc attributes:sectionTitleAttributes];
            
            
            [string appendAttributedString:titleAttStr];
            [string appendAttributedString:tabAttr];
            
            BOOL hasTheSection = NO;
            
            NSInteger titleIndex = 1;
            NSMutableArray *contentArray = model.contentArray;
            for (int j = 0; j < contentArray.count; j++) {
                MFCustomerMaintenanceContentModel *contentModel = contentArray[j];
                NSString *key = contentModel.questionNumber;
                NSArray *questions = contentModel.questions;
                
                NSString *selectedQuestionsString = _maintenanceResults[key];
                NSArray *selectedQuestions = [selectedQuestionsString componentsSeparatedByString:@","];
                
                if (selectedQuestions.count == 0) {
                    continue;
                }
                
                hasTheSection = YES;
                
                NSString *titleDesc = [NSString stringWithFormat:@"%@、%@",@(titleIndex),contentModel.titleDesc];
                NSString *questionsResultString = [self questionsResultString:questions selectedQuestions:selectedQuestions];
                NSLog(@"titleDesc=%@,questionsResultString=%@",titleDesc,questionsResultString);
                
                NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] initWithString:titleDesc attributes:titleAttributes];
                NSMutableAttributedString *questionsResultAttStr = [[NSMutableAttributedString alloc] initWithString:questionsResultString attributes:questionsResultAttributes];
                
                NSMutableAttributedString *subString = [NSMutableAttributedString new];
                [subString appendAttributedString:titleAttStr];
                [subString appendAttributedString:questionsResultAttStr];
                
                long number = 30;
                CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
                [subString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:(NSRange){titleAttStr.string.length-1,1}];
                CFRelease(num);
                
                [string appendAttributedString:subString];
                
                [string appendAttributedString:tabAttr];
                
                titleIndex++;
                
            }
            
            if (hasTheSection) {
                [sectionAttArray addObject:string];
            }
            
        }
        else
        {
            NSMutableArray *contentArray = model.contentArray;
            for (int j = 0; j < contentArray.count; j++) {
                MFCustomerMaintenanceContentModel *contentModel = contentArray[j];
                NSString *key = contentModel.questionNumber;
                NSArray *questions = contentModel.questions;
                
                NSString *selectedQuestionsString = _maintenanceResults[key];
                NSArray *selectedQuestions = [selectedQuestionsString componentsSeparatedByString:@","];
                
                if (selectedQuestions.count == 0) {
                    continue;
                }
                
                NSString *sectionTitleDesc = model.titleDesc;
                NSString *questionsResultString = [self questionsResultString:questions selectedQuestions:selectedQuestions];
                
                NSLog(@"sectionTitleDesc=%@,questionsResultString=%@",sectionTitleDesc,questionsResultString);
                
                NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] initWithString:sectionTitleDesc attributes:sectionTitleAttributes];
                NSMutableAttributedString *questionsResultAttStr = [[NSMutableAttributedString alloc] initWithString:questionsResultString attributes:questionsResultAttributes];
                
                NSMutableAttributedString *string = [NSMutableAttributedString new];
                [string appendAttributedString:titleAttStr];
                [string appendAttributedString:questionsResultAttStr];
                
                long number = 30;
                CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
                [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:(NSRange){titleAttStr.string.length - 1,1}];
                CFRelease(num);
                
                [string appendAttributedString:tabAttr];
                
                [sectionAttArray addObject:string];
            }
        }

    }
    
    _contentString = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < sectionAttArray.count; i++) {
        [_contentString appendAttributedString:sectionAttArray[i]];
    }
    
    NSMutableParagraphStyle *titleParagraphStyle = [NSMutableParagraphStyle new];
    titleParagraphStyle.firstLineHeadIndent = 50.0f;  //首行缩进
    titleParagraphStyle.headIndent = 0.0f;          //每行缩进
    titleParagraphStyle.lineSpacing = 5.0f;    //行距
    titleParagraphStyle.paragraphSpacing = 10.0f;    //段前间隔,段与段之间的距离
    titleParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [_contentString addAttribute:NSParagraphStyleAttributeName value:titleParagraphStyle range:NSMakeRange(0, _contentString.length)];
    
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
    
    _contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), textSize.height);
    _contentView.ctFrame = frame;
    [_contentView setNeedsDisplay];
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), textSize.height);
}

-(NSString *)questionsResultString:(NSArray *)questions selectedQuestions:(NSArray *)array
{
    NSString *string = nil;
    NSMutableArray *stringArray = [NSMutableArray array];
    
    for (int i = 0; i < questions.count; i++) {
        MFCustomerMaintenanceContentQuestionModel *questionModel = questions[i];
        NSString *match = questionModel.matchContent;
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


+ (NSMutableDictionary *)sectionTitleDefaultAttributes
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
    
    UIColor * textColor = [UIColor blackColor];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    return dict;
}

+ (NSMutableDictionary *)titleDefaultAttributes
{
    CTFontRef fontRef = [self ctFontRefFromUIFont:[UIFont systemFontOfSize:16.0]];
    
    CGFloat lineSpacing = 0;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = [UIColor hx_colorWithHexString:@"2d2c2c"];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    return dict;
}

+ (NSMutableDictionary *)questionsResultStringDefaultAttributes
{
    CTFontRef fontRef = [self ctFontRefFromUIFont:[UIFont systemFontOfSize:16.0]];
    
    CGFloat lineSpacing = 0;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = BBDefaultColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    return dict;
}

@end
