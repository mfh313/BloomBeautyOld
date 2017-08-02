//
//  MFCustomerInfoMainRightTitleNavView.h
//  BloomBeauty
//
//  Created by EEKA on 16/7/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFCustomerInfoMainRightTitleDelegate <NSObject>

@optional
-(void)onClickEditCustomer;
-(void)onClickDiagnosticCustomer;

@end

@interface MFCustomerInfoMainRightTitleNavView : MFUIView

@property (nonatomic,weak) id<MFCustomerInfoMainRightTitleDelegate> delegate;

-(void)setEditBtnHide:(BOOL)hidden;
-(void)setDiagnosticBtnHide:(BOOL)hidden;
-(void)setEditBtnTitle:(NSString *)title;
-(void)setEditBtnTitleColor:(UIColor *)titleColor;

@end
