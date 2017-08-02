//
//  MFCustomerMaintenanceRichView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/4.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFCustomerMaintenanceContentModel;

@interface MFCustomerMaintenanceRichView : UIView

-(void)setMaintenanceContentModel:(MFCustomerMaintenanceContentModel *)model;

+(CGSize)contentSize:(MFCustomerMaintenanceContentModel *)model availableWidth:(CGFloat)availableWidth;

@end
