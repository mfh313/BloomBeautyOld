//
//  MFStylistMatchItemCoverView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/14.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFStylistMatchItemCoverView.h"
#import "StylistMatchItem.h"
#import "MFStylistMatchItemCoverCellItemView.h"

@interface MFStylistMatchItemCoverView ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *_infoTableView;
    NSMutableArray *_infoArray;
    BOOL _hasOccasion;
    NSString *_occasionString;
}

@end

@implementation MFStylistMatchItemCoverView

-(void)setStylistMatchItem:(StylistMatchItem *)item
{
    _infoArray = item.codesInfo;
    
    _hasOccasion = NO;
    if ([item.hasOccasion isEqualToString:@"Y"]) {
        _hasOccasion = YES;
    }
    
    _occasionString = item.occasion;
    
    [_infoTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_hasOccasion) {
        return 2;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hasOccasion) {
        if (section == 0) {
            return _infoArray.count;
        }
        else
        {
            return 1;
        }
    }
    
    return _infoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasOccasion) {
        return [self tableView:tableView occasionCellForRowAtIndexPath:indexPath];
    }
    
    static NSString *identifier = @"MFStylistMatchItemCoverView";
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MFStylistMatchItemCoverCellItemView *cellView = [MFStylistMatchItemCoverCellItemView viewWithNibName:@"MFStylistMatchItemCoverCellItemView"];
        cell.m_subContentView = cellView;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    NSDictionary *itemInfo = _infoArray[indexPath.row];
    
    MFStylistMatchItemCoverCellItemView *cellView = (MFStylistMatchItemCoverCellItemView *)cell.m_subContentView;
    [cellView setItemName:itemInfo[stylistMatchItemName] itemCode:itemInfo[stylistMatchItemCode]];
    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView occasionCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"occasionCell";
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MFStylistMatchItemCoverCellItemView *cellView = [MFStylistMatchItemCoverCellItemView viewWithNibName:@"MFStylistMatchItemCoverCellItemView"];
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFStylistMatchItemCoverCellItemView *cellView = (MFStylistMatchItemCoverCellItemView *)cell.m_subContentView;
    
    [cellView setLineHidden:NO];
    
    if (indexPath.section == 0)
    {
        cell.backgroundColor = [UIColor clearColor];
        NSDictionary *itemInfo = _infoArray[indexPath.row];
        [cellView setItemName:itemInfo[stylistMatchItemName] itemCode:itemInfo[stylistMatchItemCode]];
        
        if (indexPath.row == _infoArray.count - 1)
        {
            [cellView setLineHidden:YES];
        }
    }
    else
    {
        cellView.backgroundColor = MFRGB(242, 243, 244);
        [cellView setItemName:@"场合" itemCode:_occasionString];
        [cellView setLineHidden:YES];
    }
    
    return cell;
}

@end
