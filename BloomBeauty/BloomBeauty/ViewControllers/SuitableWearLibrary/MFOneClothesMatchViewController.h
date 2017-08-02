//
//  MFOneClothesMatchViewController.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/24.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFViewController.h"

@class MFCommodityDetailModel;
@interface MFOneClothesMatchViewController : MFViewController

@property (nonatomic,strong) MFCommodityDetailModel *commodityDetailModel;
@property (nonatomic,assign) NSNumber *diagnosisResultId;
@property (nonatomic,strong) EntityBrandItemInfo *brandItemInfo;

@end
