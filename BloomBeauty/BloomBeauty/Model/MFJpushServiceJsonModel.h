//
//  MFJpushServiceJsonModel.h
//  BloomBeauty
//
//  Created by EEKA on 16/10/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFJpushServiceJsonMsgModel : MFObject

@property (nonatomic,strong) NSString *valid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSArray *actionList;

@end
