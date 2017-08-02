//
//  MFSelectShopingGuideViewController.h
//  装扮灵
//
//  Created by Administrator on 15/10/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"
#import "BBEmployeeInfo.h"

typedef void(^SelectShopingGuideBackBlock)();
typedef void(^SelectShopingGuideNextBlock)(BBEmployeeInfo *employeeInfo);

@interface MFSelectShopingGuideViewController : MFViewController

@property (nonatomic,copy) SelectShopingGuideBackBlock backBlock;
@property (nonatomic,copy) SelectShopingGuideNextBlock nextBlock;

@end
