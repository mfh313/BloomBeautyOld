//
//  MFDiagnosisHistoryCellView.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

typedef void(^ClickActionBlock)();

@interface MFDiagnosisHistoryCellView : MFUIView

-(void)setCustomerName:(NSString *)name
           phoneNumber:(NSString *)phoneNumber
         diagnosisTime:(NSString *)diagnosisTime
        diagnosisGuide:(NSString *)diagnosisGuide
           actionLabel:(NSString *)actionTitle
                action:(ClickActionBlock)actionBlock;

-(void)setActionLabelColor:(UIColor *)color;
-(void)setUnderLineHidden:(BOOL)hidden;

@end
