//
//  MFCustomerInfoMainViewController.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/11.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"
#import "MFCreateCustomerCollectionCellObj.h"


@interface MFCustomerInfoMainViewController : MFViewController

@property (strong, nonatomic) CustomerInfo *customerInfo;
@property (strong, nonatomic) NSString *individualNo;
@property (assign, nonatomic) BOOL diagnosticStatus;
@property (nonatomic,assign)  MFCustomerStatus viewStatus;
@property (retain, nonatomic) NSString *imageStreams;

@end
