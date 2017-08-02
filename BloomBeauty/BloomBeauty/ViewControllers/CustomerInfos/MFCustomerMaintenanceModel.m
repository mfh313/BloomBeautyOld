//
//  MFCustomerMaintenanceModel.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/30.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceModel.h"

@implementation MFCustomerMaintenanceModel

-(BOOL)boolMultiContents
{
    BOOL multiContents = NO;
    if ([self.multiContents isEqualToString:@"Y"]) {
        multiContents = YES;
    }
    
    return multiContents;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"contentArray" : [MFCustomerMaintenanceContentModel class]};
}

@end

#pragma mark - MFCustomerMaintenanceContentModel
@implementation MFCustomerMaintenanceContentModel

-(BOOL)canMultipleChoice
{
    BOOL canMultipleChoice = NO;
    if ([self.multipleChoice isEqualToString:@"Y"]) {
        canMultipleChoice = YES;
    }
    
    return canMultipleChoice;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"questions" : [MFCustomerMaintenanceContentQuestionModel class]};
}

@end

#pragma mark - MFCustomerMaintenanceContentQuestionModel
@implementation MFCustomerMaintenanceContentQuestionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"titleDescription" : @"description"
             };
}

@end
