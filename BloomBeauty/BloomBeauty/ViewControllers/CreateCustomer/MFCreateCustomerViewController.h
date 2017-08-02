//
//  MFCreateCustomerViewController.h
//  装扮灵
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"

@protocol MFCreateCustomerViewControllerDelegate <NSObject>

@optional
- (void)jumpToCustomerAnalysis;

@end

@interface MFCreateCustomerViewController : MFViewController

@property (nonatomic,weak) id<MFCreateCustomerViewControllerDelegate> delegate;

@end
