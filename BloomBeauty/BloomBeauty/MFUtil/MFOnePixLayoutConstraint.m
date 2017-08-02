//
//  MFOnePixLayoutConstraint.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/3.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFOnePixLayoutConstraint.h"


@implementation MFOnePixLayoutConstraint

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.constant = MFOnePixHeigtht;
}

@end

#pragma mark - MFOnePixLine
@implementation MFOnePixLine

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor hx_colorWithHexString:@"242834"];
    if (self.constraints.count > 0) {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.constant == 1) {
                constraint.constant = MFOnePixHeigtht;
            }
        }
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.exBackgroundColor) {
        [self.exBackgroundColor setFill];
    }
    else
    {
        [self.backgroundColor setFill];
    }
    
    UIRectFill(rect);
}

@end
