//
//  MFGoodsFilter.m
//  BloomBeauty
//
//  Created by EEKA on 2017/4/9.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFGoodsFilter.h"
#import "MFGoodsFilterItemData.h"
#import "MFGoodsFilterActionFloatItemView.h"
#import "MFGoodsFilterItemCellView.h"


@interface MFGoodsFilter ()<MFGoodsFilterActionFloatItemViewDelegate,MFGoodsFilterItemCellViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UIScrollView *_contentScrollView;
    __weak IBOutlet UIView *_contentBgView;
    __weak IBOutlet UIView *_backgroundView;
    __weak IBOutlet UIButton *_reSelectedBtn;
    __weak IBOutlet UIView *_categorySelectView;
    
    __weak IBOutlet NSLayoutConstraint *_categorySelectHeight;
    __weak IBOutlet NSLayoutConstraint *_contentViewHeight;
    
    __weak IBOutlet UITableView *_occasionSelectedView;
    
    NSMutableArray *_commoditySelectBtnArray;
    
    NSMutableArray *_filterDataForCommodityCode;
    NSMutableArray *_filterDataForOccasions;
    
    NSMutableArray *_currentFilterData;
    
    NSString *_filterStrForCommodityCode;
    NSString *_filterStrForOccasions;
    
}

@end

@implementation MFGoodsFilter

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnCancel:)];
    [_backgroundView addGestureRecognizer:tapGes];
    
    _filterDataForCommodityCode = [MFGoodsFilterItemData getItemDatasForCommodityCode];
    _filterDataForOccasions = [MFGoodsFilterItemData getItemDatasForOccasions];
    
    _commoditySelectBtnArray = [NSMutableArray array];
    
    [self initCommoditySelectView];

}

#pragma mark - MFGoodsFilterActionFloatItemViewDelegate
-(void)onClickActionFloatItemView:(MFGoodsFilterActionFloatItemView *)btn
{
    NSInteger selectedIndex = [_commoditySelectBtnArray indexOfObject:btn];
    MFGoodsFilterItemData *dataItem = _filterDataForCommodityCode[selectedIndex];
    
    for (int i = 0; i < _filterDataForCommodityCode.count; i++) {
        MFGoodsFilterItemData *filterItem = _filterDataForCommodityCode[i];
        if ([filterItem.matchContent isEqualToString:dataItem.matchContent]) {
            filterItem.isSelected = !filterItem.isSelected;
        }
        else
        {
            filterItem.isSelected = NO;
        }
    }
    
    for (int i = 0; i < _commoditySelectBtnArray.count; i++) {
        MFGoodsFilterActionFloatItemView *selectbtn = (MFGoodsFilterActionFloatItemView *)_commoditySelectBtnArray[i];
        MFGoodsFilterItemData *filterItem = _filterDataForCommodityCode[i];
        [selectbtn setSelected:filterItem.isSelected];
    }
}

-(void)initCommoditySelectView
{
    CGFloat btnWSpace = 10;
    for (int i = 0; i < _filterDataForCommodityCode.count; i++) {
        MFGoodsFilterActionFloatItemView *selectbtn = [MFGoodsFilterActionFloatItemView viewWithNib];
        selectbtn.touchDelegate = self;
        
        MFGoodsFilterItemData *dataItem = _filterDataForCommodityCode[i];
        
        selectbtn.normalTitle = dataItem.title;
        selectbtn.highlightTitle = dataItem.title;
        [selectbtn setSelected:dataItem.isSelected];
        
        CGFloat btnWidth = [dataItem.title MFSizeWithFont:selectbtn.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        if (btnWidth < 40) {
            btnWidth = 40;
        }
        selectbtn.frame = CGRectMake(0, 0, btnWidth + 2 * btnWSpace, 28);
        [_categorySelectView addSubview:selectbtn];
        
        [_commoditySelectBtnArray addObject:selectbtn];
    }
}

-(void)OnCancel:(id *)sender
{
    [self removeFromSuperview];
}

-(void)layoutSubviews
{
    CGFloat HSpace = 14;
    CGFloat VSpace = 14;
    
    CGFloat boarderMinX = 17;
    CGFloat boarderMaxX = 260 - 2 * boarderMinX;
    
    CGFloat originX = boarderMinX;
    CGFloat originY = 0 + VSpace;
    
    for (int i = 0; i < _commoditySelectBtnArray.count; i++) {
        UIView *itemView = (UIView *)_commoditySelectBtnArray[i];
        
        CGRect selectedBtnFrame = itemView.frame;
        
        if (originX + CGRectGetWidth(selectedBtnFrame) > boarderMaxX) {
            originX = boarderMinX;
            originY = originY + CGRectGetHeight(selectedBtnFrame) + VSpace;
        }
        
        CGRect itemFrame = CGRectMake(originX, originY, CGRectGetWidth(selectedBtnFrame), CGRectGetHeight(selectedBtnFrame));
        itemView.frame = itemFrame;
        itemView.backgroundColor = [UIColor whiteColor];
        
        originX = CGRectGetMaxX(itemFrame) + HSpace;
        
    }
    
    UIView *lastView = _commoditySelectBtnArray.lastObject;
    CGFloat headerHeight = CGRectGetMaxY(lastView.frame) + VSpace;
    _categorySelectHeight.constant = headerHeight;
    
    _contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(_contentScrollView.frame), headerHeight + 145 + _filterDataForOccasions.count * 40);
    
    _contentViewHeight.constant = _contentScrollView.contentSize.height;
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filterDataForOccasions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MFGoodsFilterItemCellView"];
    if (cell == nil) {
        cell = [[MFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MFGoodsFilterItemCellView"];
        MFGoodsFilterItemCellView *cellView = [MFGoodsFilterItemCellView viewWithNibName:@"MFGoodsFilterItemCellView"];
        cell.m_subContentView = cellView;
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFGoodsFilterItemData *filterItemData = _filterDataForOccasions[indexPath.row];
    MFGoodsFilterItemCellView *cellView = (MFGoodsFilterItemCellView *)cell.m_subContentView;
    [cellView setTitle:filterItemData.title selected:filterItemData.isSelected];
    cellView.indexPath = indexPath;
    
    cellView.m_delegate = self;
    
    return cell;
}

-(void)onDidSelectedFilterItem:(NSIndexPath *)indexPath
{
    MFGoodsFilterItemData *itemData = _filterDataForOccasions[indexPath.row];
    itemData.isSelected = !itemData.isSelected;
    
    [_occasionSelectedView reloadData];
}

-(NSString *)selectedFilterStr:(NSMutableArray *)array
{
    NSMutableArray *selectedCommodityArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        MFGoodsFilterItemData *data = array[i];
        if (data.isSelected) {
            [selectedCommodityArray addObject:data.matchContent];
        }
    }
    
    if (selectedCommodityArray.count == 0)
    {
        return nil;
    }
    
    NSString *string = [selectedCommodityArray componentsJoinedByString:@","];
    return string;
}

-(NSString *)selectedFilterDecStr:(NSMutableArray *)array
{
    NSMutableArray *selectedCommodityArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        MFGoodsFilterItemData *data = array[i];
        if (data.isSelected) {
            [selectedCommodityArray addObject:data.title];
        }
    }
    
    if (selectedCommodityArray.count == 0)
    {
        return nil;
    }
    
    NSString *string = [selectedCommodityArray componentsJoinedByString:@","];
    return string;
}


- (IBAction)onClickedReSelectedBtn:(id)sender {
    for (int i = 0; i < _filterDataForCommodityCode.count; i++) {
        MFGoodsFilterActionFloatItemView *selectbtn = (MFGoodsFilterActionFloatItemView *)_commoditySelectBtnArray[i];
        MFGoodsFilterItemData *filterItem = _filterDataForCommodityCode[i];
        filterItem.isSelected = NO;
        
        [selectbtn setSelected:filterItem.isSelected];
    }
    
    for (int i = 0; i < _filterDataForOccasions.count; i++) {
        MFGoodsFilterItemData *itemData = _filterDataForOccasions[i];
        itemData.isSelected = NO;
    }
    
    [_occasionSelectedView reloadData];
    [_contentScrollView setContentOffset:CGPointZero animated:NO];
}

- (IBAction)onClickDoneBtn:(id)sender {
    _filterStrForCommodityCode = [self selectedFilterStr:_filterDataForCommodityCode];
    _filterStrForOccasions = [self selectedFilterStr:_filterDataForOccasions];
    
    NSString *currentCommodityCodeDesc = [self selectedFilterDecStr:_filterDataForCommodityCode];
    NSString *currentOccasionsDesc = [self selectedFilterDecStr:_filterDataForOccasions];
    
    if ([self.m_delegate respondsToSelector:@selector(onClickFilterDoneCommodityCodeDescription:occasionsDesc:)]) {
        [self.m_delegate onClickFilterDoneCommodityCodeDescription:currentCommodityCodeDesc occasionsDesc:currentOccasionsDesc];
    }
    
    if ([self.m_delegate respondsToSelector:@selector(onClickFilterDoneCommodityCodeStr:occasions:)]) {
        [self.m_delegate onClickFilterDoneCommodityCodeStr:_filterStrForCommodityCode occasions:_filterStrForOccasions];
    }
}


@end
