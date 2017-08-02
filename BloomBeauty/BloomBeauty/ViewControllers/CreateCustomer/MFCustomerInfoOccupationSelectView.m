//
//  MFCustomerInfoOccupationSelectView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/6.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoOccupationSelectView.h"
#import "MFCustomerInfoManager.h"
#import "MFCustomerInfoCoverSelectCellView.h"

@interface MFCustomerInfoOccupationSelectView ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIImageView *_bgImageView;
    
    NSMutableArray *_occupations;
    NSMutableArray *_dataArray;
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet NSLayoutConstraint *_tableHeightConstaint;
    
    NSString *_selectedKey;
}

@end

@implementation MFCustomerInfoOccupationSelectView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor hx_colorWithHexString:@"#000" alpha:0.3];
    _bgImageView.image = MFImageStretchCenter(@"round");
    
    _occupations = [[MFCustomerInfoManager sharedManager] occupations];
    
    _dataArray = [NSMutableArray arrayWithArray:_occupations];
    
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
    NSInteger rowCount = _dataArray.count;
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

-(void)setSelectOccupation:(NSString *)key
{
    _selectedKey = key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFCustomerInfoOccupationSelectView"];
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MFCustomerInfoOccupationSelectView"];
        MFCustomerInfoCoverSelectCellView *cellView = [MFCustomerInfoCoverSelectCellView viewWithNib];
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFCustomerInfoCoverSelectCellView *cellView = (MFCustomerInfoCoverSelectCellView *)cell.m_subContentView;
    
    MFCustomerInfoOccupationDataItem *dataItem = _dataArray[indexPath.row];
    BOOL isSelected = NO;
    if ([dataItem.key isEqualToString:_selectedKey]) {
        isSelected = YES;
    }
    
    [cellView setTitle:dataItem.value selected:isSelected];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFCustomerInfoOccupationDataItem *dataItem = _dataArray[indexPath.row];
    
    _selectedKey = dataItem.key;
    [_tableView reloadData];
    
}

- (IBAction)onClickCancelBtn:(id)sender
{
    [self onClickBgView];
}

- (IBAction)onClickDoneBtn:(id)sender
{
    for (int i = 0; i < _dataArray.count; i++) {
        MFCustomerInfoOccupationDataItem *dataItem = _dataArray[i];
        if ([dataItem.key isEqualToString:_selectedKey])
        {
            if ([self.m_delegate respondsToSelector:@selector(onDidSelectOccupation:occupation:)]) {
                [self.m_delegate onDidSelectOccupation:dataItem.key occupation:dataItem.value];
            }
            
            break;
        }
    }
    
    [self onClickBgView];
}

- (IBAction)onClickBgBtn:(id)sender
{
    [self onClickBgView];
}

-(void)onClickBgView
{
    [self removeFromSuperview];
}

@end
