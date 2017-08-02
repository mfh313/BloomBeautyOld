//
//  MFDiagnosticModel.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/14.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

#define MFDiagnosticTypeKeyString @"string"
#define MFDiagnosticTypeKeyImage @"image"

#define MFDiagnosticTitleFont [UIFont systemFontOfSize:18.0]
#define MFDiagnosticRemarkFont [UIFont systemFontOfSize:20.0]
#define MFDiagnosticFont [UIFont systemFontOfSize:16.0]
#define MFDiagnosticStrItemHeight 50

#define MFDiagnostisRemarkColor MFRGB(241, 92, 57)

#define DiagnostisImageBundlePath [[NSBundle mainBundle] pathForResource:@"diagnostisImage" ofType:@"bundle"]

#pragma mark - MFDiagnosticQuestionDataItem
@class MFDiagnosticQuestionDressingSolveModel;

@interface MFDiagnosticQuestionDataItem : MFObject

@property (nonatomic,strong) NSString *questionsNumber;
@property (nonatomic,strong) NSMutableAttributedString *showingTitleDescription;
@property (nonatomic,strong) NSString *titleDescription;
@property (nonatomic,strong) NSString *itemType;
@property (nonatomic,assign) NSInteger columnCount;
@property (nonatomic,assign) NSUInteger maxSelectedCount;
@property (nonatomic,assign) NSUInteger minSelectedCount;
@property (nonatomic,assign) NSUInteger contentImageWidth;
@property (nonatomic,assign) NSUInteger contentImageHeight;
@property (nonatomic,assign) NSUInteger contentDescriptionMaxWidth;

@property (nonatomic,assign) NSInteger itemWidth;
@property (nonatomic,assign) NSInteger itemHeight;
@property (nonatomic,assign) NSInteger itemHorizontalSpace;
@property (nonatomic,assign) NSInteger itemVerticalSpace;
@property (nonatomic,strong) MFDiagnosticQuestionDressingSolveModel *dressingSolveModel;

@property (nonatomic,strong) NSMutableArray *diagnosticContentArray;
@property (nonatomic,strong) NSMutableArray *diagnosticResultSelectedArray;
@property (nonatomic,strong) NSString *diagnosisResultString;

@end

#pragma mark - MFDiagnosticQuestionContentDataItem
@interface MFDiagnosticQuestionContentDataItem : MFObject

@property (nonatomic,strong) NSString *realMatch;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *contentDescription;
@property (nonatomic,strong) NSString *desNormalHexColor;
@property (nonatomic,strong) NSString *desSelectedHexColor;
@property (nonatomic,strong) NSMutableAttributedString *contentAttributedDescription;
@property (nonatomic,assign) BOOL isSelected;

@end

