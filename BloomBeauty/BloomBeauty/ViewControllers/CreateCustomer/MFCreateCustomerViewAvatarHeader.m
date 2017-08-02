//
//  MFCreateCustomerViewAvatarHeader.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/5.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCreateCustomerViewAvatarHeader.h"

@implementation MFCreateCustomerViewAvatarHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatarCreateView.layer.cornerRadius = 41;
    self.avatarCreateView.layer.masksToBounds = YES;
    
    [self.avatarCreateView setImage:MFImage(@"zbl31")];
}



@end
