//
//  MFCustomerMaintenanceReportRichContentView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/6.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerMaintenanceReportRichContentView.h"

@implementation MFCustomerMaintenanceReportRichContentView

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!self.ctFrame) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw(self.ctFrame, context);
}

@end
