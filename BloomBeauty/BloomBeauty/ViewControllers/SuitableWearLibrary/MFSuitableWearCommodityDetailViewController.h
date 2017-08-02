//
//  MFSuitableWearCommodityDetailViewController.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFViewController.h"


@class MFCommodityDetailModel;
@interface MFSuitableWearCommodityDetailViewController : MFViewController

@property (nonatomic,strong) MFCommodityDetailModel *commodityDetailModel;
@property (nonatomic,strong) EntityBrandItemInfo *brandItemInfo;
@property (nonatomic,assign) NSNumber *diagnosisResultId;

@end
