//
//  MFCustomerSearchHistoryCell.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerSearchHistoryCell.h"

@interface MFCustomerSearchHistoryCell ()
{
    __weak IBOutlet UILabel *_nameLabel;
}

@end

@implementation MFCustomerSearchHistoryCell
@synthesize delegate;
@synthesize indexPath;


- (IBAction)onClickItem:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onClickHistory:)])
    {
        [self.delegate onClickHistory:self.indexPath];
    }
}

- (void)setName:(NSString *)name
{
    _nameLabel.text = name;
}


@end
