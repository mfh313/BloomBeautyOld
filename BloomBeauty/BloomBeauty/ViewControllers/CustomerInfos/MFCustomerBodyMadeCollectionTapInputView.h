//
//  MFCustomerBodyMadeCollectionTapInputView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIButton.h"

@class MFCustomerBodyMadeCollectionTapInputView;
@protocol MFCustomerBodyMadeCollectionTapInputViewDelegate <NSObject>

@optional
-(void)onTapBeginEditing;
-(void)onKeyBoardWillShow:(NSNumber *)duration curve:(NSNumber *)curve needOffet:(CGFloat)yOffest;
-(void)onKeyBoardWillHide:(NSNumber *)duration curve:(NSNumber *)curve keyboardEndFrame:(CGRect)keyboardEndFrame;
-(void)textFieldDidEndEditing:(UITextField *)textField tapView:(MFCustomerBodyMadeCollectionTapInputView *)tapView;
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string tapView:(MFCustomerBodyMadeCollectionTapInputView *)tapView;
@end

@interface MFCustomerBodyMadeCollectionTapInputView : MFUIButton

@property (nonatomic,weak) id<MFCustomerBodyMadeCollectionTapInputViewDelegate> m_delegate;

-(void)setInputViewValue:(NSString *)value unit:(NSString *)unit;
-(void)setValueString:(NSString *)value;
-(UITextField *)containTextField;

@end
