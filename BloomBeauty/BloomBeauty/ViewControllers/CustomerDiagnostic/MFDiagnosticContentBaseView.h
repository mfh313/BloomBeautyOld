//
//  MFDiagnosticContentBaseView.h
//  BloomBeauty
//
//  Created by EEKA on 1/11/16.
//  Copyright © 2016 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFDiagnosticModel.h"
#import "MFImageGridView.h"
#import "MFDiagnosticSelectView.h"

@protocol MFDiagnosticSelectViewDelegate;
@interface MFDiagnosticContentBaseView : MFUIView <MFDiagnosticSelectViewDelegate>
{
    MFDiagnosticQuestionDataItem *_oDataItem;
    NSMutableArray *_diagnosticDataItemViewArray;
}

@property (nonatomic,strong) MFDiagnosticQuestionDataItem *oDataItem;
@property (nonatomic,weak) id<MFDiagnosticSelectViewDelegate> diagnosticSelectViewDelegate;

+(float)heightForQuestionDataItem:(MFDiagnosticQuestionDataItem *)oDataItem;

-(id)initWithDiagnosticDataItem:(MFDiagnosticQuestionDataItem *)oDataItem;

@end
