//
//  MFCustomerConsumptionRecordCellHeaderView.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@interface MFCustomerConsumptionRecordCellHeaderView : MFUIView

-(void)setConsumptionNumber:(NSString *)consumptionNumber
                   shopName:(NSString *)shopName
                       time:(NSString *)time;

@end
