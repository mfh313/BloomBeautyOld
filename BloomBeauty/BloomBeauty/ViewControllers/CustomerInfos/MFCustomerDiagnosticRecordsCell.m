//
//  MFCustomerDiagnosticRecordsCell.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/13.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticRecordsCell.h"

@implementation MFCustomerDiagnosticRecordsCell
@synthesize itemView;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.itemView setHandleBtnTitle:@"查看报告"];
    [self.itemView setClickBtnColorfull];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
