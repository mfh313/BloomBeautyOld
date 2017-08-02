//
//  MFCustomerBodyMadeUnderwearItemResultView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFCustomerBodyMadeUnderWearModel;
@interface MFCustomerBodyMadeUnderwearItemResultView : UIView

-(void)setUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)model;

+(CGSize)contentSize:(MFCustomerBodyMadeUnderWearModel *)model availableWidth:(CGFloat)availableWidth;

@end
