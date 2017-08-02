//
//  MFCustomerBodyMadeModel.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/6.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeModel.h"

@implementation MFCustomerBodyMadeUnderWearModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"dressingSolveModel" : @"solveModel"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"questions" : [MFCustomerBodyMadeUnderWearQuestionModel class],
             @"dressingSolveModel" : [MFQuestionDressingSolveModel class]};
}

@end

#pragma mark - MFQuestionDressingSolveModel
@implementation MFQuestionDressingSolveModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"contents" : [MFDiagnosticQuestionDressingSolveContentDataItem class]};
}

@end

#pragma mark - MFDiagnosticQuestionDressingSolveContentDataItem
@implementation MFDiagnosticQuestionDressingSolveContentDataItem

@end

#pragma mark - MFCustomerBodyMadeUnderWearQuestionModel
@implementation MFCustomerBodyMadeUnderWearQuestionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"titleDescription" : @"description"
             };
}

@end


#pragma mark - MFCustomerBodyMadeModel
@implementation MFCustomerBodyMadeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"titleDescription" : @"description"
             };
}

@end

@implementation MFCustomerBodyMadeHelper

+(NSString *)makeBodyMadeValueJsonString:(MFCustomerBodyMadeModel *)bodyModel value:(NSString *)value
{
    NSMutableDictionary *valueInfo = [NSMutableDictionary dictionary];
    valueInfo[@"value"] = value;
    valueInfo[@"unit"] = bodyModel.unit;
    valueInfo[@"unitDesc"] = bodyModel.unitDesc;
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:valueInfo options:0 error:&err];
    NSString *valueString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return valueString;
}

+(NSDictionary *)bodyMadeValueDic:(NSString *)bodyMadeValue
{
    NSError * err;
    NSData *data =[bodyMadeValue dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * response;
    if(data!=nil){
        response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    }
    
    return response;
}

+(NSString *)bodyMadeValueShowString:(NSString *)bodyMadeValue
{
    NSDictionary *bodyValueInfo = [self bodyMadeValueDic:bodyMadeValue];
    
    NSString *value = bodyValueInfo[@"value"];
    NSString *unitString = bodyValueInfo[@"unitDesc"];
    if (!unitString) {
        return value;
    }
    
    return [value stringByAppendingString:unitString];
}

+(NSString *)bodyMadeValueShowStringWithOutUnit:(NSString *)bodyMadeValue
{
    NSDictionary *bodyValueInfo = [self bodyMadeValueDic:bodyMadeValue];
    
    NSString *value = bodyValueInfo[@"value"];
    
    return value;
}

@end
