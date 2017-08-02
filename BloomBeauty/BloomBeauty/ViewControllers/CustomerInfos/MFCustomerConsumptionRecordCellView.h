//
//  MFCustomerConsumptionRecordCellView.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class PosVoucherDetail;
@protocol MFCustomerConsumptionRecordCellViewDelegate <NSObject>

-(void)onClickCustomerConsumptionRecordCellVieWithDetail:(PosVoucherDetail *)detail;

@end

@interface MFCustomerConsumptionRecordCellView : MFUIView
{
    NSMutableArray *_itemViews;
    NSUInteger _colummCount;
}

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<MFCustomerConsumptionRecordCellViewDelegate> m_delegate;

-(instancetype)initWithFrame:(CGRect)frame withColummCount:(int)colummCount;
-(void)setPosVoucherDetails:(NSMutableArray *)posVoucherDetails indexPath:(NSIndexPath *)indexPath;

@end
