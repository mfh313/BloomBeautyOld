//
//  MFCustomerInfoMainNavBarView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/3.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFCustomerInfoMainNavBarViewDelegate <NSObject>

@optional
-(void)onClickBackBtn;
-(void)onClickEditCustomer;
-(void)onClickDiagnosticCustomer;

@end

@interface MFCustomerInfoMainNavBarView : MFUIView

@property (nonatomic,weak) id<MFCustomerInfoMainNavBarViewDelegate> m_delegate;

-(void)setNavBarTitle:(NSString *)title;
-(void)setDiagnosisButton:(BOOL)hidden;
-(void)setEditButtonTitle:(NSString *)title;

@end
