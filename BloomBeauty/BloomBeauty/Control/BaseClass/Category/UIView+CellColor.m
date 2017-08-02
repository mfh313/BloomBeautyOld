//
//  UIView+CellColor.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/13.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "UIView+CellColor.h"

@implementation UIView (CellColor)

-(void)setWhiteGrayColor:(NSInteger)index
{
    if (index%2 == 1)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = MFRGB(243, 240, 245);
    }
}

@end
