//
//  MFLoginViewController.h
//  装扮灵
//
//  Created by Administrator on 15/10/18.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"

@protocol MFLoginViewControllerDelegate <NSObject>

@optional
-(void)didLoginSuccess;

@end

@interface MFLoginViewController : MFViewController

@property (nonatomic,weak) id<MFLoginViewControllerDelegate> delegate;

@end
