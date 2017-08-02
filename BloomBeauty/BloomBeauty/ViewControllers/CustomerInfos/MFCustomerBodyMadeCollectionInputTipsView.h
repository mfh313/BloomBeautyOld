//
//  MFCustomerBodyMadeCollectionInputTipsView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@interface MFCustomerBodyMadeCollectionInputTipsView : MFUIView

-(void)setTipsInfo:(NSDictionary *)info;

+(CGSize)sizeForTipsInfo:(NSDictionary *)info;

@end
