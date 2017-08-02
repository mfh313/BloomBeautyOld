//
//  MFCustomerInfoViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerInfoViewController.h"
#import "MFCustomerCreateLogicController.h"
#import "MFCustomerInfoCellView.h"
#import "MFCreateCustomerViewHeader.h"


@interface MFCustomerInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MFCustomerInfoCellViewDelegate>
{
    __weak IBOutlet UICollectionView *_customerInfoView;
    NSMutableArray *_requiredArray;
    NSMutableArray *_optionalArray;
    
    MFCustomerCreateLogicController *m_logic;
}

@end

@implementation MFCustomerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_customerInfoView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
    _customerInfoView.backgroundColor = [UIColor whiteColor];
    
    [_customerInfoView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFCustomerInfoViewController"];
    [_customerInfoView registerClass:[MFUICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCreateCustomerSectionHeaderView"];
    
    m_logic = [MFCustomerCreateLogicController new];
    
    [self customerInfoArrayWith:self.customerInfo];
}

-(void)customerInfoArrayWith:(CustomerInfo *)customerInfo
{
    _requiredArray = [m_logic customerInfoShowObjects:[m_logic editRequiredCustomerInfoModel] info:customerInfo];
    _optionalArray = [m_logic customerInfoShowObjects:[m_logic editOptionalCustomerInfoModel] info:customerInfo];
}

-(NSMutableDictionary *)editingInfoValues
{
    NSMutableDictionary *editingInfo = [NSMutableDictionary dictionary];
    NSMutableArray *infoArray = [NSMutableArray arrayWithArray:_requiredArray];
    [infoArray addObjectsFromArray:_optionalArray];
    
    for (int i = 0; i < infoArray.count; i++) {
        MFCustomerInfoShowObject *infoObject = infoArray[i];
        
        NSMutableDictionary *valueInfo = infoObject.valueInfo;
        for (int j = 0; j < valueInfo.allKeys.count; j++) {
            NSString *key = valueInfo.allKeys[j];
            [editingInfo setObject:valueInfo[key] forKey:key];
        }
    }
    
    return editingInfo;
}

-(BOOL)isEdting
{
    if ([self.m_delegate respondsToSelector:@selector(isEditingInfo)]) {
        return [self.m_delegate isEditingInfo];
    }
    
    return NO;
}

-(void)setEditngInfo:(BOOL)editing
{
    [_customerInfoView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _requiredArray.count;
    }
    else if (section == 1)
    {
        return _optionalArray.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MFCustomerInfoViewController";
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFCustomerInfoCellView *cellView = [MFCustomerInfoCellView viewWithNib];
        cellView.m_delegate = self;
        cell.m_subContentView = cellView;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    
    MFCustomerInfoShowObject *infoObject = nil;
    if (indexPath.section == 0) {
        infoObject = _requiredArray[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        infoObject = _optionalArray[indexPath.row];
    }
    
    MFCustomerInfoCellView *cellView = (MFCustomerInfoCellView *)cell.m_subContentView;
    cellView.superScrollView = collectionView;
    
    [cellView setCustomerInfoShowObject:infoObject editing:[self isEdting]];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(collectionView.bounds) - 120 -  40) / 2, 36);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 66, 0, 66);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        MFUICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MFCreateCustomerSectionHeaderView" forIndexPath:indexPath];
        if (headerView.m_subContentView == nil) {
            MFCreateCustomerViewHeader *header = [MFCreateCustomerViewHeader viewWithNib];
            header.frame = headerView.bounds;
            headerView.m_subContentView = header;
        }
        
        headerView.m_subContentView.frame = headerView.bounds;
  
        MFCreateCustomerViewHeader *header = (MFCreateCustomerViewHeader *)headerView.m_subContentView;
        if (indexPath.section == 0)
        {
            [header setRequiredType:YES];
        }
        else if (indexPath.section == 1)
        {
            [header setRequiredType:NO];
        }
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 70);
    }
    else if (section == 1)
    {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 56);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view.window endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
