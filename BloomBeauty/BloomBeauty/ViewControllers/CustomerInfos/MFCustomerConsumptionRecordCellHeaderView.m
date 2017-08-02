//
//  MFCustomerConsumptionRecordCellHeaderView.m
//  BloomBeauty
//
//  Created by EEKA on 16/4/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerConsumptionRecordCellHeaderView.h"

@interface MFCustomerConsumptionRecordCellHeaderView ()
{
    __weak IBOutlet UILabel *_consumptionNumberLabel;
    __weak IBOutlet UILabel *_shopNameLabel;
    __weak IBOutlet UILabel *_timeLabel;
    
}

@end

@implementation MFCustomerConsumptionRecordCellHeaderView

-(void)setConsumptionNumber:(NSString *)consumptionNumber
                   shopName:(NSString *)shopName
                       time:(NSString *)time
{
    _consumptionNumberLabel.text = [NSString stringWithFormat:@"单号: %@",consumptionNumber];
    _shopNameLabel.text = shopName;
    _timeLabel.text = time;
}


@end
