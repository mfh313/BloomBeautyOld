//
//  MFCustomerInfoCoverSelectView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/6.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoCoverSelectView.h"
#import "MFCustomerInfoCoverSelectCellView.h"

@interface MFCustomerInfoCoverSelectView ()
{
    __weak IBOutlet UIImageView *_bgImageView;
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet NSLayoutConstraint *_tableHeightConstaint;
    
}

@end

@implementation MFCustomerInfoCoverSelectView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor hx_colorWithHexString:@"#000" alpha:0.3];
    _bgImageView.image = MFImageStretchCenter(@"round");
    
    _tableView.rowHeight = 44.0f;

}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self setTableViewConstaint];
}

-(void)didMoveToSuperview
{
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setTableViewConstaint];
}

-(void)setTableViewConstaint
{
    NSInteger rowCount = [self.m_dataSource numberOfRowsWithViewKey:self.viewKey];
    _tableHeightConstaint.constant = rowCount * _tableView.rowHeight;
    
    [_tableView reloadData];
    
    CGFloat maxHeight = CGRectGetHeight(self.bounds) - 200;
    if (_tableHeightConstaint.constant < maxHeight) {
        _tableView.scrollEnabled = NO;
    }
    else
    {
        _tableHeightConstaint.constant =  maxHeight;
        _tableView.scrollEnabled = YES;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.m_dataSource respondsToSelector:@selector(numberOfRowsWithViewKey:)]) {
        return [self.m_dataSource numberOfRowsWithViewKey:self.viewKey];
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFCustomerInfoCoverSelectView"];
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MFCustomerInfoCoverSelectView"];
        MFCustomerInfoCoverSelectCellView *cellView = [MFCustomerInfoCoverSelectCellView viewWithNib];
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFCustomerInfoCoverSelectCellView *cellView = (MFCustomerInfoCoverSelectCellView *)cell.m_subContentView;
    
    NSString *title = nil;
    if ([self.m_dataSource respondsToSelector:@selector(titleWithViewKey:forIndex:)]) {
        title = [self.m_dataSource titleWithViewKey:self.viewKey forIndex:indexPath.row];
    }
    
    BOOL selected = NO;
    if ([self.m_dataSource respondsToSelector:@selector(isSelectedWithViewKey:forIndex:)]) {
        selected = [self.m_dataSource isSelectedWithViewKey:self.viewKey forIndex:indexPath.row];
    }
    
    [cellView setTitle:title selected:selected];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.m_delegate respondsToSelector:@selector(didSelectIndexViewKey:forIndex:)]) {
        [self.m_delegate didSelectIndexViewKey:self.viewKey forIndex:indexPath.row];
    }
}

- (IBAction)onClickCoverBgView:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickCoverSelectBgView:)]) {
        [self.m_delegate onClickCoverSelectBgView:self.viewKey];
    }
}

- (IBAction)onClickCancelBtn:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickCancelButton:)]) {
        [self.m_delegate onClickCancelButton:self.viewKey];
    }
}

- (IBAction)onClickDoneBtn:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickDoneButton:)]) {
        [self.m_delegate onClickDoneButton:self.viewKey];
    }
}

-(void)reloadContentTable
{
    [_tableView reloadData];
}

@end
