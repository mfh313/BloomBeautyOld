//
//  MFCustomerMaintenanceModel.h
//  BloomBeauty
//
//  Created by EEKA on 2016/11/30.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFCustomerMaintenanceModel : MFObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titleDesc;
@property (nonatomic,copy) NSString *titleRemark;
@property (nonatomic,copy) NSString *multiContents;
@property (nonatomic,assign) BOOL boolMultiContents;
@property (nonatomic,strong) NSMutableArray *contentArray;

@end

#pragma mark - MFCustomerMaintenanceContentModel
@interface MFCustomerMaintenanceContentModel : MFObject

@property (nonatomic,copy) NSString *questionNumber;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titleRemark;
@property (nonatomic,copy) NSString *titleDesc;
@property (nonatomic,strong) NSString *multipleChoice;
@property (nonatomic,assign) BOOL canMultipleChoice;
@property (nonatomic,strong) NSMutableArray *selectedQuestions;
@property (nonatomic,strong) NSMutableArray *questions;

@end

#pragma mark - MFCustomerMaintenanceContentQuestionModel
@interface MFCustomerMaintenanceContentQuestionModel : MFObject

@property (nonatomic,assign) NSRange questionRange;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titleDescription;
@property (nonatomic,copy) NSString *matchContent;

@end


