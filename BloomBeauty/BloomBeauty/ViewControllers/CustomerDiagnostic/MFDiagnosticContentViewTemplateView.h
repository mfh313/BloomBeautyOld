//
//  MFDiagnosticContentViewTemplateView.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFDiagnosticContentBaseView.h"

@interface MFDiagnosticContentViewTemplateView : MFDiagnosticContentBaseView
{
    MFImageGridView *_imageGridView;
}

-(void)initViewsWithQuestionDataItem:(MFDiagnosticQuestionDataItem *)oDataItem;
+(float)heightForQuestionDataItem:(MFDiagnosticQuestionDataItem *)oDataItem;

@end
