//
//  MFCustomerInfoViewController.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"

@protocol MFCustomerDelegate <NSObject>

@optional
-(void)keyboardMoveYMain:(float)y;

@end

@interface MFCustomerBaseViewController : MFViewController

@property (nonatomic,strong) CustomerInfo *customerInfo;
@property (nonatomic,assign) MFCustomerStatus viewStatus;
@property (nonatomic,weak) id<MFCustomerDelegate> delegate;

@end
