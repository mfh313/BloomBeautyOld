//
//  MFCustomerDiagnosisCellView.h
//  BloomBeauty
//
//  Created by EEKA on 16/1/15.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFCustomerDiagnosisCellView;

@protocol MFCustomerDiagnosisCellViewDelegate <NSObject>

-(void)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView shouldNotSelectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath;

-(BOOL)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView shouldSelectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath;

-(void)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView didSelectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath;

-(void)customerDiagnosisCellView:(MFCustomerDiagnosisCellView *)cellView didDeselectDiagnosticItem:(NSIndexPath *)indexPath subIndexPath:(NSIndexPath *)subIndexPath;

@end



@class MFDiagnosticQuestionDataItem;
@interface MFCustomerDiagnosisCellView : MFUIView
{
    MFDiagnosticQuestionDataItem *_dataItem;
}

@property (nonatomic,strong) MFDiagnosticQuestionDataItem *dataItem;
@property (nonatomic,weak) id<MFCustomerDiagnosisCellViewDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;

+(NSMutableAttributedString *)_textWithString:(NSMutableAttributedString *)text withRemarkColor:(UIColor *)remarkColor;

- (void)setQuestionDataItem:(MFDiagnosticQuestionDataItem *)aDiagnosisDataItem;
+ (float)heightForDiagnosticQuestionDataItem:(MFDiagnosticQuestionDataItem *)dataItem;

@end
