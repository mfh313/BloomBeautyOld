//
//  MFCustomerBodyMadeLogicController.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/6.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface MFCustomerBodyMadeLogicController : MFObject

-(void)readjsonData;
-(NSMutableDictionary *)bodyMadeFirstTipInfo;
-(NSMutableArray *)underWearTemplates;
-(NSMutableArray *)bodyMadeTemplates;

@end
