//
//  MFRoundTextField.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFRoundTextField;

@protocol MFRoundTextFieldDelegate <NSObject>

@optional
-(void)onClickKeyBoardDone;
-(void)onCLickKeyBoardClearBtn;

@end

@interface MFRoundTextField : MFUIView

@property (nonatomic,strong) id<MFRoundTextFieldDelegate> delegate;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,weak) id<UITextFieldDelegate> textFieldDelegate;

- (void)clearContent;
- (BOOL)resignFirstResponder;
- (BOOL)becomeFirstResponder;
- (void)setPlaceHolder:(NSString *)placeHolder;
- (void)setText:(NSString *)text;
- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType;
- (void)setKeyboardType:(UIKeyboardType)keyboardType;
- (UITextField *)inputTextField;

@end
