//
//  MFCustomerMaintenanceLogicController.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/28.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceLogicController.h"
#import "MFCustomerMaintenanceModel.h"

@interface MFCustomerMaintenanceLogicController ()
{
    NSMutableArray *_maintenanceTemplates;
}

@end

@implementation MFCustomerMaintenanceLogicController

-(instancetype)init
{
    self = [super init];
    if (self) {
        _maintenanceTemplates = [NSMutableArray array];
    }
    
    return self;
}

-(void)readjsonData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"customerMaintenanceTemplate" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *jsonDataDic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
    
    NSMutableArray *contents = jsonDataDic[@"contents"];
    
    for (int i = 0; i < contents.count; i++) {
        MFCustomerMaintenanceModel *dataItem = [MFCustomerMaintenanceModel yy_modelWithDictionary:contents[i]];
        
        [_maintenanceTemplates addObject:dataItem];
    }
    
    [self fixMaintenanceTemplates];
    
}

-(void)fixMaintenanceTemplates
{
    for (int i = 0; i < _maintenanceTemplates.count; i++) {
        MFCustomerMaintenanceModel *dataItem = _maintenanceTemplates[i];
        
        NSMutableArray *contentArray = dataItem.contentArray;
        for (int j = 0; j < contentArray.count; j++) {
            MFCustomerMaintenanceContentModel *contentModel = contentArray[j];
            
            NSMutableArray *selectedQuestions = contentModel.selectedQuestions;
            if (!selectedQuestions) {
                contentModel.selectedQuestions = [NSMutableArray array];
            }
        }
    }
}

-(NSMutableArray *)maintenanceTemplates
{
    return _maintenanceTemplates;
}

@end
