//
//  MFNavigationController.m
//  装扮灵
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFNavigationController.h"

@interface MFNavigationController ()<UINavigationControllerDelegate>

@end

@implementation MFNavigationController
@synthesize MF_NavigationControllerProxyDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)respondsToSelector:(SEL)aSelector
//{
//    if ( [super respondsToSelector:aSelector] )
//        return YES;
//    
//    if ([self.MF_NavigationControllerProxyDelegate respondsToSelector:aSelector])
//        return YES;
//    
//    return NO;
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
//{
//    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
//    if(!signature) {
//        if([MF_NavigationControllerProxyDelegate respondsToSelector:selector]) {
//            return [(NSObject *)MF_NavigationControllerProxyDelegate methodSignatureForSelector:selector];
//        }
//    }
//    return signature;
//}
//
//- (void)forwardInvocation:(NSInvocation*)invocation
//{
//    if ([MF_NavigationControllerProxyDelegate respondsToSelector:[invocation selector]]) {
//        [invocation invokeWithTarget:MF_NavigationControllerProxyDelegate];
//    }
//}


@end
