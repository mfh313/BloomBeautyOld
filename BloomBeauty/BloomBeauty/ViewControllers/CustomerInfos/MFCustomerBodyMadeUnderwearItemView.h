//
//  MFCustomerBodyMadeUnderwearItemView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/11/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFCustomerBodyMadeUnderWearModel;

@interface MFCustomerBodyMadeUnderwearItemView : MFUIView

-(void)setUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel editing:(BOOL)editing;

+(CGSize)sizeForUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel availableWidth:(CGFloat)availableWidth editing:(BOOL)editing;


@end
