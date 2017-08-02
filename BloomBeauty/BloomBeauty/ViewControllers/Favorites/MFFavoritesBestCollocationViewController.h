//
//  MFFavoritesMainViewController.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/11.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"

typedef void(^tableFreshBlock)(NSMutableArray *dataArray);

@interface MFFavoritesBestCollocationViewController : MFViewController

@property (nonatomic,copy) tableFreshBlock block;


@end
