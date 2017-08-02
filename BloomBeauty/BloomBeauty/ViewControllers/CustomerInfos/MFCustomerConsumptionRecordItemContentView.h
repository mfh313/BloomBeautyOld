//
//  MFCustomerConsumptionRecordItemContentView.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFCustomerConsumptionRecordItemContentView,PosVoucherDetail;

@protocol MFCustomerConsumptionRecordItemContentViewDelegate <NSObject>

-(void)onClickConsumptionRecordItem:(MFCustomerConsumptionRecordItemContentView *)itemView detail:(PosVoucherDetail *)detail;

@end


@interface MFCustomerConsumptionRecordItemContentView : MFUIView
@property (nonatomic,weak) id<MFCustomerConsumptionRecordItemContentViewDelegate> m_delegate;

-(void)setPosVoucherDetail:(PosVoucherDetail *)detail;

@end
