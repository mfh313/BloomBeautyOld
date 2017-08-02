//
//  MFDiagnosticItemSelectView.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFDiagnosticImageView.h"
#import "MFDiagnosticTextSelectView.h"

@interface MFDiagnosticItemSelectView : MFUIView
{
    MFDiagnosticImageView *_imageSelectView;
    MFDiagnosticTextSelectView *_textSelectView;
}

-(void)setType:(NSString *)type;
-(MFDiagnosticImageView *)imageSelectView;
-(MFDiagnosticTextSelectView *)textSelectView;

@end
