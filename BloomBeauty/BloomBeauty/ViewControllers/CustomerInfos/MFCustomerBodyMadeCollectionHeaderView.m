//
//  MFCustomerBodyMadeCollectionHeaderView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/7.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeCollectionHeaderView.h"
#import "MFCustomerBodyMadeCollectionNormalHeaderView.h"

@implementation MFCustomerBodyMadeCollectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentLabel = [MFCustomerBodyMadeCollectionNormalHeaderView viewWithNib];
        _contentLabel.frame = self.bounds;
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentLabel];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    [_contentLabel.titleLabel setText:title];
}

@end
