//
//  MFCustomerInfoCellView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/5.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFCustomerInfoShowObject;

@protocol MFCustomerInfoCellViewDelegate <NSObject>

@optional

@end

@interface MFCustomerInfoCellView : MFUIView

@property (nonatomic,weak) UIScrollView *superScrollView;
@property (nonatomic,weak) id<MFCustomerInfoCellViewDelegate> m_delegate;

-(void)setCustomerInfoShowObject:(MFCustomerInfoShowObject *)object;
-(void)setCustomerInfoShowObject:(MFCustomerInfoShowObject *)object editing:(BOOL)editing;

@end
