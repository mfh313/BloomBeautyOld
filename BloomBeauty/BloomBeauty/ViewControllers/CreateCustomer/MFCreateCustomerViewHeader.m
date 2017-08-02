//
//  MFCreateCustomerViewHeader.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/12.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCreateCustomerViewHeader.h"

@interface MFCreateCustomerViewHeader ()
{
    __weak IBOutlet UIView *_requireView;
    __weak IBOutlet UIView *_optionalView;
}

@end

@implementation MFCreateCustomerViewHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [_requireView setHidden:NO];
    [_optionalView setHidden:YES];
}

-(void)setRequiredType:(BOOL)required
{
    [_requireView setHidden:YES];
    [_optionalView setHidden:YES];
    
    if (required) {
        [_requireView setHidden:NO];
    }
    else
    {
        [_optionalView setHidden:NO];
    }
}

@end
