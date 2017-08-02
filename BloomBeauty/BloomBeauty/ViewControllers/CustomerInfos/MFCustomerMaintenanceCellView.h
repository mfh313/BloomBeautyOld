//
//  MFCustomerMaintenanceCellView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/11/28.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFCustomerMaintenanceCellViewDelegate <NSObject>

@optional

@end

@class MFCustomerMaintenanceModel,TTTAttributedLabel;
@interface MFCustomerMaintenanceCellView : MFUIView

@property (nonatomic,weak) id<MFCustomerMaintenanceCellViewDelegate> m_delegate;

-(void)setMaintenanceModel:(MFCustomerMaintenanceModel *)model
         contentModelIndex:(NSInteger)index;

+(CGFloat)cellHeightForMaintenanceModel:(MFCustomerMaintenanceModel *)model
                      contentModelIndex:(NSInteger)index
                         availableWidth:(CGFloat)availableWidth;

@end
