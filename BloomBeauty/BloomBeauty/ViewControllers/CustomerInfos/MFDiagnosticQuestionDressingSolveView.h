//
//  MFDiagnosticQuestionDressingSolveView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/13.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFDiagnosticQuestionDressingSolveViewDelegate <NSObject>

@optional

@end

@class MFCustomerBodyMadeUnderWearModel;
@interface MFDiagnosticQuestionDressingSolveView : MFUIView

@property (nonatomic,weak) id<MFDiagnosticQuestionDressingSolveViewDelegate> m_delegate;

-(void)setUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel editing:(BOOL)editing;
+(CGSize)sizeForUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel availableWidth:(CGFloat)availableWidth editing:(BOOL)editing;

@end
