//
//  MFTextField.h
//  装扮灵
//
//  Created by Administrator on 15/10/19.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFLoginInputViewDelegate <NSObject>

@optional
-(void)didEnterString;
-(void)inputViewHasNamePassWord:(BOOL)has;

@end

@interface MFLoginInputView : MFUIView

@property (nonatomic,weak) id<MFLoginInputViewDelegate> delegate;
@property (nonatomic,weak) UIView *mSuperView;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *password;

-(void)checkLoginBtnStatus;
-(void)shakeAnimation;


@end
