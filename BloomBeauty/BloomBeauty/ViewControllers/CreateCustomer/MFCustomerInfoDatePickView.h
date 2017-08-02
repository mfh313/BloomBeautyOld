//
//  MFCustomerInfoDatePickView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/9.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFCustomerInfoDatePickViewDelegate <NSObject>

@optional
-(void)onClickDatePickerSelectBgView;
-(void)datePickerViewDidSelected:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob;

@end

@interface MFCustomerInfoDatePickView : MFUIView

@property (nonatomic,weak) id<MFCustomerInfoDatePickViewDelegate> m_delegate;

-(void)setDatePickerView:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob;

@end

