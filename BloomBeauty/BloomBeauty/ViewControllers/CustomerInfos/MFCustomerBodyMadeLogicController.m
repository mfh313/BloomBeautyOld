//
//  MFCustomerBodyMadeLogicController.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/6.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeLogicController.h"
#import "MFCustomerBodyMadeModel.h"

@interface MFCustomerBodyMadeLogicController ()
{
    NSMutableArray *_underWearTemplates;
    NSMutableArray *_bodyMadeTemplates;
    
    NSMutableDictionary *_bodyMadeFirstTipInfo;
}

@end

@implementation MFCustomerBodyMadeLogicController

-(instancetype)init
{
    self = [super init];
    if (self) {
        _underWearTemplates = [NSMutableArray array];
        _bodyMadeTemplates = [NSMutableArray array];
    }
    
    return self;
}

-(void)readjsonData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bodyCustomMade" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *jsonDataDic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
    
    _bodyMadeFirstTipInfo = jsonDataDic[@"bodyMadeFirstTip"];
    
    NSMutableArray *underWearContents = jsonDataDic[@"underWear"];
    
    for (int i = 0; i < underWearContents.count; i++) {
        MFCustomerBodyMadeUnderWearModel *underWearItem = [MFCustomerBodyMadeUnderWearModel yy_modelWithDictionary:underWearContents[i]];
        [_underWearTemplates addObject:underWearItem];
    }
    
    [self fixUnderWearTemplates];
    
    
    NSMutableArray *bodyMadeContents = jsonDataDic[@"bodyMade"];
    for (int i = 0; i < bodyMadeContents.count; i++) {
        MFCustomerBodyMadeModel *bodyMadeItem = [MFCustomerBodyMadeModel yy_modelWithDictionary:bodyMadeContents[i]];
        [_bodyMadeTemplates addObject:bodyMadeItem];
    }
}

-(void)fixUnderWearTemplates
{
    for (int i = 0; i < _underWearTemplates.count; i++) {
        MFCustomerBodyMadeUnderWearModel *underWearItem = _underWearTemplates[i];
        
        NSMutableAttributedString *showingTitleDescription = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d、%@",i+1,underWearItem.titleDescription]];
        underWearItem.showingTitleDescription = showingTitleDescription;
        
        NSMutableAttributedString *resultTitleDescription = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d、%@",i+1,underWearItem.titleResultDescription]];
        underWearItem.resultTitleDescription = resultTitleDescription;
        
        NSMutableArray *selectedQuestions = underWearItem.selectedQuestions;
        if (!selectedQuestions) {
            underWearItem.selectedQuestions = [NSMutableArray array];
        }
    }
}

-(NSMutableArray *)underWearTemplates
{
    return _underWearTemplates;
}

-(NSMutableArray *)bodyMadeTemplates
{
    return _bodyMadeTemplates;
}

-(NSMutableDictionary *)bodyMadeFirstTipInfo
{
    return _bodyMadeFirstTipInfo;
}

@end
