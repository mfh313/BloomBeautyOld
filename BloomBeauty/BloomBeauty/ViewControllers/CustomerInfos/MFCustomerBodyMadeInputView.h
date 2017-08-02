//
//  MFCustomerBodyMadeInputView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFCustomerBodyMadeModel;
@protocol MFCustomerBodyMadeInputViewDelegate <NSObject>

@optional
-(void)onFinishEndEditing;
-(void)onFinishEndEditingBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem string:(NSString *)value;
-(void)cancelInputBodyMade;

@end

@interface MFCustomerBodyMadeInputView : MFUIView

@property (nonatomic,weak) id<MFCustomerBodyMadeInputViewDelegate> m_delegate;

- (void)setBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem;
- (BOOL)resignFirstResponder;
- (BOOL)becomeFirstResponder;

@end
