//
//  MFDiagnosticImageSelectCoverView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/15.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDiagnosticImageSelectCoverView.h"

@implementation MFDiagnosticImageSelectCoverView

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIImage *coverImage = MFImageStretch(MFImage(@"zbl35"), MFImage(@"zbl35").size.width/2, MFImage(@"zbl35").size.height/2);
    [self setBackgroundImage:coverImage forState:UIControlStateNormal];
}

@end
