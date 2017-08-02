//
//  MFOneClothesMatchDataItem.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFOneClothesMatchDataItem : MFObject

@property (nonatomic,strong) NSString *itemkey; //downItem middleItem upperItem
@property (nonatomic,strong) NSString *itemStyleColor;
@property (nonatomic,strong) NSString *originalItemUrl;
@property (nonatomic,strong) NSString *smallItemUrl;

@end
