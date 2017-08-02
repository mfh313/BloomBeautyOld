//
//  MFTextField.m
//  装扮灵
//
//  Created by Administrator on 15/10/19.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFLoginInputView.h"

@interface MFLoginInputView () <UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *_userNameTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    
    __weak IBOutlet UIImageView *_userBgImg;
    __weak IBOutlet UIImageView *_passwordBgImg;
    
    __weak IBOutlet UIButton *userArrawBtn;
    UIView *_userArrawBgView;
}

@end


@implementation MFLoginInputView
@synthesize delegate;
@synthesize mSuperView;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UITapGestureRecognizer *taoGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserImage)];
    [_userBgImg addGestureRecognizer:taoGes1];
    
    UITapGestureRecognizer *taoGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPasswordImage)];
    [_passwordBgImg addGestureRecognizer:taoGes2];
    
    [self bringSubviewToFront:userArrawBtn];
    userArrawBtn.hidden = YES;
}

- (void)textFieldDidChange:(NSNotification *)obj
{
    [self checkLoginBtnStatus];
}

-(void)checkLoginBtnStatus
{
    BOOL enableLoginBtn = NO;
    if (![self stringNull:_passwordTextField.text]
        && ![self stringNull:_userNameTextField.text]) {
        enableLoginBtn = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(inputViewHasNamePassWord:)]) {
        [self.delegate inputViewHasNamePassWord:enableLoginBtn];
    }
}

-(BOOL)stringNull:(NSString *)string
{
#ifdef DEBUG
    return NO;
#else
    if (!string || [string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
#endif
}

-(void)clickUserImage
{
    [_userNameTextField becomeFirstResponder];
}

-(void)clickPasswordImage
{
    [_passwordTextField becomeFirstResponder];
}

-(void)setName:(NSString *)name
{
    _userNameTextField.text = name;
}

-(void)setPassword:(NSString *)password
{
    _passwordTextField.text = password;
}

- (NSString *)name
{
    return [_userNameTextField.text copy];
}

-(NSString *)password
{
    return [_passwordTextField.text copy];
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if ([userArrawBtn pointInside:point withEvent:event]) {
//        return userArrawBtn;
//    }
//    
//    return [super hitTest:point withEvent:event];
//}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if ([userArrawBtn pointInside:point withEvent:event]) {
//        return NO;
//    }
//    
//    return YES;
//}

- (IBAction)showRecentUserList:(id)sender {
    
    [self endEditing:YES];
    
    if (_userArrawBgView == nil) {
        _userArrawBgView = [[UIView alloc] initWithFrame:mSuperView.bounds];
        _userArrawBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _userArrawBgView.backgroundColor = [UIColor blueColor];
        UITapGestureRecognizer *taoGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeUserBgView)];
        [_userArrawBgView addGestureRecognizer:taoGes1];
    }
    
    _userArrawBgView.frame = mSuperView.bounds;
    [mSuperView addSubview:_userArrawBgView];
}

- (void)removeUserBgView
{
    [_userArrawBgView removeFromSuperview];
}

-(void)shakeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;
    
    animation.additive = YES;
    
    [self.layer addAnimation:animation forKey:@"shake"];
}

@end
