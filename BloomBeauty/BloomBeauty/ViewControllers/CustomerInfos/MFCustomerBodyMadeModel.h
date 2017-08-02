//
//  MFCustomerBodyMadeModel.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/6.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@class MFQuestionDressingSolveModel;

@interface MFCustomerBodyMadeUnderWearModel : MFObject
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *titleDescription;
@property (nonatomic,copy) NSString *titleResultDescription;
@property (nonatomic,strong) NSMutableAttributedString *showingTitleDescription;
@property (nonatomic,strong) NSMutableAttributedString *resultTitleDescription;
@property (nonatomic,copy) NSString *titleDesc;
@property (nonatomic,strong) NSMutableArray *selectedQuestions;
@property (nonatomic,strong) NSMutableArray *questions;
@property (nonatomic,strong) MFQuestionDressingSolveModel *dressingSolveModel;

@end

#pragma mark - MFCustomerBodyMadeUnderWearQuestionModel
@interface MFCustomerBodyMadeUnderWearQuestionModel : MFObject

@property (nonatomic,assign) NSRange questionRange;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titleDescription;
@property (nonatomic,copy) NSString *match;

@end

#pragma mark - MFQuestionDressingSolveModel
@interface MFQuestionDressingSolveModel : MFObject

@property (nonatomic,assign) NSUInteger maxSelectedCount;
@property (nonatomic,assign) NSUInteger minSelectedCount;
@property (nonatomic,assign) NSUInteger contentImageWidth;
@property (nonatomic,assign) NSUInteger contentImageHeight;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,assign) NSUInteger contentDescriptionMaxWidth;
@property (nonatomic,strong) NSMutableAttributedString *contentAttributedDescription;
@property (nonatomic,strong) NSMutableArray *contents;

@end

#pragma mark - MFDiagnosticQuestionDressingSolveContentDataItem
@interface MFDiagnosticQuestionDressingSolveContentDataItem : MFObject

@property (nonatomic,strong) NSString *pointType;
@property (nonatomic,strong) NSString *pointX;
@property (nonatomic,strong) NSString *pointY;
@property (nonatomic,strong) NSString *realMatch;
@property (nonatomic,strong) NSString *contentDescription;


@end

#pragma mark - MFCustomerBodyMadeModel
@interface MFCustomerBodyMadeModel : MFObject
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *unitDesc;
@property (nonatomic,copy) NSString *titleDescription;
@property (nonatomic,copy) NSString *descriptionImageName;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,strong) NSString *bodyMadeValue;

@end


#pragma mark - MFCustomerBodyMadeHelper
@interface MFCustomerBodyMadeHelper : MFObject

+(NSString *)makeBodyMadeValueJsonString:(MFCustomerBodyMadeModel *)bodyModel value:(NSString *)value;
+(NSDictionary *)bodyMadeValueDic:(NSString *)bodyMadeValue;
+(NSString *)bodyMadeValueShowString:(NSString *)bodyMadeValue;
+(NSString *)bodyMadeValueShowStringWithOutUnit:(NSString *)bodyMadeValue;

@end
