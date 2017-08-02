//
//  EntityDiagnosisRecordsDataItem.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface EntityDiagnosisRecordsDataItem : MFObject

@property (nonatomic,copy) NSString *diagnosisEmployeeName;
@property (nonatomic,copy) NSNumber *diagnosisResultId;
@property (nonatomic,copy) NSString *diagnosisTime;
@property (nonatomic,copy) NSString *individualName;
@property (nonatomic,copy) NSString *individualNo;
@property (nonatomic,copy) NSString *phoneNum;

@end
