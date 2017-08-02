//
//  MFCustomerBodyMadeUnderwearItemInputView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFCustomerBodyMadeUnderWearModel;
@interface MFCustomerBodyMadeUnderwearItemInputView : UIView

-(void)setBodyMadeUnderWearModel:(MFCustomerBodyMadeUnderWearModel*)underWearModel;

+(CGSize)cellSizeForBodyMadeUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)model
                            availableWidth:(CGFloat)availableWidth;

@end
