//
//  MFCustomerConsumptionRecordCellView.m
//  BloomBeauty
//
//  Created by EEKA on 16/4/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerConsumptionRecordCellView.h"
#import "MFCustomerConsumptionRecordItemContentView.h"
#import "PosVoucherDetail.h"

@interface MFCustomerConsumptionRecordCellView () <MFCustomerConsumptionRecordItemContentViewDelegate>
{
    
}

@end

@implementation MFCustomerConsumptionRecordCellView
@synthesize m_delegate;

-(instancetype)initWithFrame:(CGRect)frame withColummCount:(int)colummCount
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _colummCount = colummCount;
        
        _itemViews = [NSMutableArray array];
        
        for (int i = 0; i < _colummCount; i++) {
            MFCustomerConsumptionRecordItemContentView *subView = [MFCustomerConsumptionRecordItemContentView viewWithNibName:@"MFCustomerConsumptionRecordItemContentView"];
            subView.m_delegate = self;
            [self addSubview:subView];
            
            [_itemViews addObject:subView];
        }
        
        UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.bounds) - MFOnePixHeigtht, CGRectGetWidth(self.bounds) - 30, MFOnePixHeigtht)];
        footLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        footLine.backgroundColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
        [self addSubview:footLine];
    }
    return self;
}

-(void)onClickConsumptionRecordItem:(MFCustomerConsumptionRecordItemContentView *)itemView detail:(PosVoucherDetail *)detail
{
    if ([self.m_delegate respondsToSelector:@selector(onClickCustomerConsumptionRecordCellVieWithDetail:)]) {
        [self.m_delegate onClickCustomerConsumptionRecordCellVieWithDetail:detail];
    }
}

-(void)setPosVoucherDetails:(NSMutableArray *)posVoucherDetails indexPath:(NSIndexPath *)indexPath
{
    NSUInteger firstDetailIndex = indexPath.row * _colummCount;
    
    if (firstDetailIndex > posVoucherDetails.count) {
        return;
    }
    
    for (int i = 0; i < _colummCount; i++) {
        NSUInteger objectIndex = indexPath.row * _colummCount + i;
        MFCustomerConsumptionRecordItemContentView *subView = (MFCustomerConsumptionRecordItemContentView *)_itemViews[i];
        
        if (objectIndex > posVoucherDetails.count - 1) {
            subView.hidden = YES;
            return;
        }
        
        subView.hidden = NO;
        CGFloat width = CGRectGetWidth(self.bounds) / _colummCount;
        CGRect subViewframe = CGRectMake(width * i, 0, width, CGRectGetHeight(self.bounds));
        subView.frame = subViewframe;
        
        PosVoucherDetail *detail = posVoucherDetails[objectIndex];
        [subView setPosVoucherDetail:detail];
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < _colummCount; i++) {
        MFCustomerConsumptionRecordItemContentView *subView = (MFCustomerConsumptionRecordItemContentView *)_itemViews[i];
        CGFloat width = CGRectGetWidth(self.bounds) / _colummCount;
        CGRect subViewframe = CGRectMake(width * i, 0, width, CGRectGetHeight(self.bounds));
        subView.frame = subViewframe;
    }
}

@end
