//
//  MFDiagnosticTextSelectView.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/15.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDiagnosticSelectView.h"

@interface MFDiagnosticTextSelectView : MFDiagnosticSelectView

-(void)setTextContent:(NSString *)text;
-(void)setTextSelected:(BOOL)selected;
-(void)setTextSelected:(BOOL)selected
        normalHexColor:(NSString *)desNormalHexColor
      selectedHexColor:(NSString *)desSelectedHexColor;

@end
