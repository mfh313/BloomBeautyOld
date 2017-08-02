//
//  MFCustomerInfoMainHeaderView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/15.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MFCustomerInfoMainNavBarViewDelegate;

@protocol MFCustomerInfoMainHeaderViewDataSource <NSObject>

@optional

-(BOOL)isDiagnosis;

-(NSMutableArray *)middleBtnObjects;

@end


@protocol MFCustomerInfoMainHeaderViewDelegate <NSObject>

@optional
-(void)onTouchDownHeadImage;
-(void)didClickMiddleButton:(NSString *)viewKey index:(NSInteger)index;
-(void)onClickBackBtn;
-(void)onClickEditCustomer;
-(void)onClickDiagnosticCustomer;

@end

@class CustomerInfo;
@interface MFCustomerInfoMainHeaderView : MFUIView

@property (nonatomic,weak) id<MFCustomerInfoMainHeaderViewDataSource> m_dataSource;
@property (nonatomic,weak) id<MFCustomerInfoMainHeaderViewDelegate> m_delegate;

-(CGRect)imagePickerSourceRectToView:(UIView *)view;
-(void)setHeaderImage:(UIImage *)image;
-(void)setNavBarTitle:(NSString *)title;
-(void)setCustomerInfoEditing:(BOOL)editing;
-(void)setCustomerInfo:(CustomerInfo *)customerInfo;
-(void)setMiddleBtnSelectIndex:(NSInteger)index;

@end
