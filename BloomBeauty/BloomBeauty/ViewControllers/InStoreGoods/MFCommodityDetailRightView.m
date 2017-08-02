//
//  MFCommodityDetailRightView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/23.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCommodityDetailRightView.h"
#import "MFCommodityDetailSizeCell.h"


@interface MFCommodityDetailRightView ()<UICollectionViewDelegateFlowLayout>
{
    
    __weak IBOutlet UILabel *_commodityCodeLabel;
    
    __weak IBOutlet UILabel *_listPriceLabel;
    
    __weak IBOutlet UILabel *_sizeLabel;
    __weak IBOutlet MFUICollectionView *_sizeCollectionView;
    NSMutableArray *_sizeKeysArray;
    NSMutableDictionary *_sizeMap;
    __weak IBOutlet NSLayoutConstraint *_sizeCollectionHeightLayout;
    
    CGFloat collectionItemHeight;
    
}

@end

@implementation MFCommodityDetailRightView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setLabel:_commodityCodeLabel title:@"款号" content:@"" contentPre:nil];
    [self setLabel:_listPriceLabel title:@"价格" content:@"" contentPre:nil];
    [self setLabel:_sizeLabel title:@"库存" content:nil contentPre:nil];
    
    collectionItemHeight = 34.0;
    [_sizeCollectionView registerNib:[MFCommodityDetailSizeCell nib] forCellWithReuseIdentifier:[MFCommodityDetailSizeCell nibid]];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sizeKeysArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return CGSizeMake(CGRectGetWidth(_sizeCollectionView.bounds), collectionItemHeight);
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFCommodityDetailSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFCommodityDetailSizeCell nibid] forIndexPath:indexPath];
    NSString *size = _sizeKeysArray[indexPath.row];
    NSString *count = nil;
    if (size) {
        count = [_sizeMap objectForKey:size];
    }
    
    [cell setSize:size count:count];
    return cell;
}

-(void)setLabel:(UILabel *)label title:(NSString *)title content:(NSString *)content contentPre:(NSString *)contentPreix
{
    
    NSString *titleStr = [NSString stringWithFormat:@"%@:",title];
    NSString *contentStr = content;
    if (contentPreix) {
        contentStr = [NSString stringWithFormat:@"%@%@",contentPreix,content];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];

    long number = 5;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:(NSRange){title.length-1,1}];
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:(NSRange){titleStr.length-1,1}];
    CFRelease(num);
    
    if (contentStr) {
        NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedString appendAttributedString:contentAttributedString];
    }
    
    label.attributedText = attributedString;
}

-(void)setCommodityCode:(NSString *)commodityCode Price:(NSString *)priceStr
{
    [self setLabel:_commodityCodeLabel title:@"款号" content:commodityCode contentPre:nil];
    [self setLabel:_listPriceLabel title:@"价格" content:priceStr contentPre:@"￥"];
}

-(void)setSizeMapDic:(NSMutableDictionary *)dic
{
    _sizeMap = dic;
    
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[dic allKeys]];
    [keys sortUsingSelector:@selector(compare:)];
    _sizeKeysArray = [keys mutableCopy];
    
    _sizeCollectionHeightLayout.constant = collectionItemHeight * _sizeKeysArray.count;
    
    [_sizeCollectionView reloadData];
}

@end
