//
//  MFCustomerInputTextFieldEx.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/5.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFCustomerCreateLogicController.h"

@class MFCustomerInputTextFieldEx;

@protocol MFCustomerInputTextFieldExDelegate <NSObject>

@optional
-(BOOL)textField:(MFCustomerInputTextFieldEx *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)textFieldDidEndEditing:(MFCustomerInputTextFieldEx *)textField;
-(void)onTapEditing;
-(void)onDidSelectIsLunar:(BOOL)isLunar;
-(void)onKeyBoardWillShow:(NSNumber *)duration curve:(NSNumber *)curve needOffet:(CGFloat)yOffest;
-(void)onKeyBoardWillHide:(NSNumber *)duration curve:(NSNumber *)curve keyboardEndFrame:(CGRect)keyboardEndFrame;
-(void)showCoverSelectView;

@end

@interface MFCustomerInputTextFieldEx : MFUIView

@property (nonatomic,weak) id<MFCustomerInputTextFieldExDelegate> m_delegate;

-(void)setTitle:(NSString *)title;
-(void)setTitle:(NSString *)title desc:(NSString *)desc;
-(void)setPlaceHolder:(NSString *)placeHolder hidden:(BOOL)hidden;
-(void)setContentDesc:(NSString *)desc;
-(void)setBirthDayView:(NSString *)dateDesc IsLunar:(BOOL)isLunar;
-(void)setShowType:(MFCustomerInfoShowType)type editing:(BOOL)editing canEdit:(BOOL)canEdit;
-(void)onClickInputingShowType:(MFCustomerInfoShowType)type;
-(UITextField *)containTextField;
-(NSString *)text;

@end
