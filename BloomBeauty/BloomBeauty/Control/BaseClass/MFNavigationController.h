//
//  MFNavigationController.h
//  装扮灵
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFNavigationController : UINavigationController

@property (nonatomic,weak) id<UINavigationControllerDelegate> MF_NavigationControllerProxyDelegate;

@end
