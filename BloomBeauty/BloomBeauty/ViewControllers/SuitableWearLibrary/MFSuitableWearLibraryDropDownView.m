//
//  MFSuitableWearLibraryDropDownView.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFSuitableWearLibraryDropDownView.h"
#import "MFSuitableWearLibraryDropDownCellView.h"

@interface MFSuitableWearLibraryDropDownView ()<MFSuitableWearLibraryDropDownCellViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet MFUITableView *_tableView;
    
    __weak IBOutlet NSLayoutConstraint *_tableHeightConstraint;
}

@end


@implementation MFSuitableWearLibraryDropDownView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _tableView.rowHeight = 40;
    [self addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setBrandCount:(NSInteger)count
{
    _tableHeightConstraint.constant = _tableView.rowHeight * count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.m_dataSource respondsToSelector:@selector(numberOfBrand)]) {
        return [self.m_dataSource numberOfBrand];
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MFSuitableWearLibraryDropDownView";
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MFSuitableWearLibraryDropDownCellView *cellView = [MFSuitableWearLibraryDropDownCellView viewWithNibName:@"MFSuitableWearLibraryDropDownCellView"];
        cellView.m_delegate = self;
        cell.m_subContentView = cellView;
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    MFSuitableWearLibraryDropDownCellView *cellView = (MFSuitableWearLibraryDropDownCellView *)cell.m_subContentView;
    cellView.frame = cell.contentView.bounds;
    cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cellView.indexPath = indexPath;
    
    if ([self.m_dataSource respondsToSelector:@selector(brandTitleForIndex:)]) {
        NSString *brandTitle = [self.m_dataSource brandTitleForIndex:indexPath.row];
        [cellView setBrandTitle:brandTitle];
    }
    
    if ([self.m_dataSource respondsToSelector:@selector(isSeletedBrandForIndex:)]) {
        BOOL isSelected = [self.m_dataSource isSeletedBrandForIndex:indexPath.row];
        [cellView setCellViewSelected:isSelected];
    }
    
    return cell;
}

-(void)onClickDropDownCellView:(NSIndexPath *)indexPath
{
    if ([self.m_delegate respondsToSelector:@selector(didSelectBrandForIndex:)]) {
        [self.m_delegate didSelectBrandForIndex:indexPath.row];
    }
}

-(void)reloadView
{
    [_tableView reloadData];
}

@end
