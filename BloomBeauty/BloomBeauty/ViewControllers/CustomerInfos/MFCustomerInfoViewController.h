//
//  MFCustomerInfoViewController.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerBaseViewController.h"

@protocol MFCustomerInfoViewControllerDelegate <NSObject>

@optional
-(BOOL)isEditingInfo;

@end

@interface MFCustomerInfoViewController : MFCustomerBaseViewController

@property (nonatomic,weak) id<MFCustomerInfoViewControllerDelegate> m_delegate;

-(void)setEditngInfo:(BOOL)editing;
-(NSMutableDictionary *)editingInfoValues;

@end
