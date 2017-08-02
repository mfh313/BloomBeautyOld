//
//  MFSuitableWearLibraryViewController.m
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSuitableWearLibraryViewController.h"
#import "MFCommodityDetailModel.h"
#import "MFCountsTitleView.h"
#import "MFSuitableWearLibraryRightNavView.h"
#import "MFSuitableWearLibraryDropDownView.h"
#import "MFSuitableWearCommodityDetailViewController.h"
#import "MFSalingProdouctCellView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MFSmallCellSizeCacheManger.h"
#import "MFGoodsFilter.h"


@interface MFSuitableWearLibraryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MFSalingProdouctCellViewDelegate,MFGoodsFilterDelegate,MFCountsTitleViewDelegate,MFSuitableWearLibraryDropDownViewDataSource,MFSuitableWearLibraryDropDownViewDelegate,CHTCollectionViewDelegateWaterfallLayout,MFSalingProdouctItemViewDelegate>
{
    __weak IBOutlet UIView *_blankTipView;
    __weak IBOutlet MFUICollectionView *_inStoreGoodsCollectionView;
    
    NSMutableArray *_commodityDetailArray;
    NSArray *_filterBrandInfoArray;
    
    MFCountsTitleView *_titleView;
    MFSuitableWearLibraryRightNavView *_rightNavTitleView;
    MFGoodsFilter *_filterView;
    MFSuitableWearLibraryDropDownView *_brandFloatView;
    
    NSString *_filterStrForCommodityCode;
    NSString *_filterStrForOccasions;
    
    NSNumber *_filterEntityBrandId;
    
    EntityBrandItemInfo *_selectedItemInfo;

}

@end

@implementation MFSuitableWearLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MF_wantsFullScreenLayout:NO];
    [self setNaviItemViews];
    [self initCollectionView];
    
    _commodityDetailArray = [NSMutableArray array];
    
    _filterBrandInfoArray = [MFLoginCenter sharedCenter].loginInfo.collectionEntitys;
    if(_filterBrandInfoArray.count > 0)
    {
        NSNumber *entityId = [MFLoginCenter sharedCenter].loginInfo.entityId;
        for (EntityBrandItemInfo *itemInfo in _filterBrandInfoArray) {
            if ([itemInfo.entityId isEqual:entityId]) {
                _selectedItemInfo = itemInfo;
                
                _filterEntityBrandId = _selectedItemInfo.entityBrandId;
                [_titleView setCanSelectBrand:YES];
                [_titleView setSelectBrandTitle:_selectedItemInfo.brandEnglishName];
                break;
            }
        }
    }
    else
    {
        _filterEntityBrandId = [MFLoginCenter sharedCenter].loginInfo.entityBrandId;
    }
    
    [self queryAvailableCommodity];
    
    _filterView = [MFGoodsFilter viewWithNib];
    _filterView.m_delegate = self;
    _filterView.frame = MFAppWindow.bounds;

    _brandFloatView = [MFSuitableWearLibraryDropDownView viewWithNibName:@"MFSuitableWearLibraryDropDownView"];
    _brandFloatView.frame = self.view.bounds;
    _brandFloatView.backgroundColor = [UIColor hx_colorWithHexString:@"000000" alpha:0.1];
    _brandFloatView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _brandFloatView.m_dataSource = self;
    _brandFloatView.m_delegate = self;
    [_brandFloatView setBrandCount:_filterBrandInfoArray.count];
    
    [self setNavTitle];
}

#pragma mark - MFSuitableWearLibraryDropDownViewDataSource
-(NSString *)brandTitleForIndex:(NSUInteger)index
{
    EntityBrandItemInfo *itemInfo = _filterBrandInfoArray[index];
    return itemInfo.brandEnglishName;
}


-(BOOL)isSeletedBrandForIndex:(NSUInteger)index
{
    EntityBrandItemInfo *itemInfo = _filterBrandInfoArray[index];
    if (_filterEntityBrandId == itemInfo.entityBrandId) {
        return YES;
    }
    
    return NO;
}

-(NSInteger)numberOfBrand
{
    return _filterBrandInfoArray.count;
}

#pragma mark - MFSuitableWearLibraryDropDownViewDelegate
-(void)didSelectBrandForIndex:(NSUInteger)index
{
    _selectedItemInfo = _filterBrandInfoArray[index];
    _filterEntityBrandId = _selectedItemInfo.entityBrandId;
    
    [_titleView setSelectBrandTitle:_selectedItemInfo.brandEnglishName];
    [_brandFloatView reloadView];
    [_brandFloatView removeFromSuperview];
    
    [self queryAvailableCommodity];
}

#pragma mark - MFGoodsFilterDelegate
-(void)onClickFilterDoneCommodityCodeStr:(NSString *)filterStrForCommodityCode occasions:(NSString *)filterStrForOccasions
{
    _filterStrForCommodityCode = filterStrForCommodityCode;
    _filterStrForOccasions = filterStrForOccasions;
    
    [_filterView removeFromSuperview];
    [self queryAvailableCommodity];
}

-(void)setNaviItemViews
{
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    
    _titleView = [MFCountsTitleView viewWithNibName:@"MFCountsTitleView"];
    _titleView.frame = CGRectMake(0, 0, 400, 44);
    _titleView.delegate = self;
    self.navigationItem.titleView = _titleView;
    
    _rightNavTitleView = [MFSuitableWearLibraryRightNavView viewWithNibName:@"MFSuitableWearLibraryRightNavView"];
    _rightNavTitleView.frame = CGRectMake(0, 0, 100, 44);
    [_rightNavTitleView.filterBtn addTarget:self action:@selector(onClickFilterBtn) forControlEvents:UIControlEventTouchUpInside];

}

-(void)initCollectionView
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumColumnSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    layout.columnCount = 4;
    _inStoreGoodsCollectionView.collectionViewLayout = layout;
    
    [_inStoreGoodsCollectionView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFSalingProdouctViewController"];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _commodityDetailArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MFSalingProdouctViewController";
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFSalingProdouctItemView *cellView = [MFSalingProdouctItemView viewWithNibName:@"MFSalingProdouctItemView"];
        cellView.delegate = self;
        cellView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.m_subContentView = cellView;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    MFCollectionViewCell *iCell = (MFCollectionViewCell *)cell;
    iCell.m_subContentView.frame = iCell.contentView.bounds;
    
    __block MFInStoreGoodsModel *goodsModel = _commodityDetailArray[indexPath.row];
    
    MFSalingProdouctItemView *cellView = (MFSalingProdouctItemView *)iCell.m_subContentView;
    [cellView setInStoreGoodsModel:goodsModel];
    
    [cellView.imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.smallItemUrl] placeholderImage:MFImage(@"zbl55") options:SDWebImageRetryFailed];
    
    __weak typeof(self) weakSelf = self;
    [cellView setClickBlock:^(BOOL didSelected, NSString *itemStyleColor, NSString *tips) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showTips:tips];
    }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MFCollectionViewCell *iCell = (MFCollectionViewCell *)cell;
//    iCell.m_subContentView.frame = iCell.contentView.bounds;
//    
//    __block MFInStoreGoodsModel *goodsModel = _commodityDetailArray[indexPath.row];
//    
//    MFSalingProdouctItemView *cellView = (MFSalingProdouctItemView *)iCell.m_subContentView;
//    [cellView setInStoreGoodsModel:goodsModel];
//    
//    [cellView.imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.smallItemUrl] placeholderImage:MFImage(@"zbl55") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            if (!CGSizeEqualToSize(goodsModel.imageSize, image.size)) {
//                goodsModel.imageSize = image.size;
//                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//            }
//        }
//    }];
//    
//    __weak typeof(self) weakSelf = self;
//    [cellView setClickBlock:^(BOOL didSelected, NSString *itemStyleColor, NSString *tips) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf showTips:tips];
//    }];
}

-(void)didSelectSalingProdouct:(MFInStoreGoodsModel *)goodsModel
{
    MFCommodityDetailModel *commodityDetailModel = [MFCommodityDetailModel new];
    commodityDetailModel.commodityCode = goodsModel.itemStyleColor;
    commodityDetailModel.commodityImageOriginalUrl = goodsModel.originalItemUrl;
    commodityDetailModel.commodityThumbNailUrl = goodsModel.smallItemUrl;

    MFSuitableWearCommodityDetailViewController *swCommodityDetailVC = [BBSuitableWearStoryBoard instantiateViewControllerWithIdentifier:@"MFSuitableWearCommodityDetailViewController"];
    swCommodityDetailVC.commodityDetailModel = commodityDetailModel;
    swCommodityDetailVC.brandItemInfo = _selectedItemInfo;
    [self.navigationController pushViewController:swCommodityDetailVC animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFInStoreGoodsModel *goodsModel = _commodityDetailArray[indexPath.row];
    return [self smallItemsSizeForGoodsModel:goodsModel];
}

#pragma mark - onClickSelectBrandButton
-(void)onClickSelectBrandButton
{
    if (_brandFloatView.superview) {
        [_brandFloatView removeFromSuperview];
    }
    else
    {
        _brandFloatView.frame = self.view.bounds;
        [self.view addSubview:_brandFloatView];
        [self.view bringSubviewToFront:_brandFloatView];
    }
}

-(void)onClickFilterBtn
{
    if (_filterView.superview) {
        [_filterView removeFromSuperview];
    }
    else
    {
        [MFAppWindow addSubview:_filterView];
    }
}

-(void)setNavTitle
{
    if (_commodityDetailArray.count > 0) {
        [_titleView setNavTitle:@"适穿库 "
                   suffixString:[NSString stringWithFormat:@"(%d款)",(int)_commodityDetailArray.count]
                       sufColor:[UIColor whiteColor]];
    }
    else
    {
        [_titleView setNavTitle:@"适穿库"];
    }
}

-(void)queryAvailableCommodity
{
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    BBEmployeeInfo *currentShopingGuideInfo = [MFLoginCenter sharedCenter].currentShopingGuideInfo;
    if (!currentShopingGuideInfo.entityId)
    {
        return;
    }
    NSNumber *lastDiagnosisResultId = [MFLoginCenter sharedCenter].currentCustomerInfo.lastDiagnosisResultId;
    if(lastDiagnosisResultId == nil){
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                                                @{
                                                                 @"diagnosisResultId": lastDiagnosisResultId,
                                                                 @"token": token
                                                                 }];
    
    if (_filterStrForCommodityCode) {
        parameters[@"commodityCode"] = _filterStrForCommodityCode;
    }
    
    if (_filterStrForOccasions) {
        parameters[@"occasions"] = _filterStrForOccasions;
    }
    
    if(_filterBrandInfoArray.count > 0)
    {
        parameters[@"entityId"] = _selectedItemInfo.entityId;
    }
    else
    {
        parameters[@"entityId"] = currentShopingGuideInfo.entityId;
    }
    
    if (_filterEntityBrandId) {
        parameters[@"entityBrandId"] = _filterEntityBrandId;
    }

    [self showMBCircleInViewController];
    
    [MFHTTPUtil POST:MFApiGenerateItemStockURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hiddenMBStatus];
         NSString *statusCode = responseObject[@"statusCode"];
         
         if ([responseObject[@"commodityInfo"] isKindOfClass:[NSNull class]]) {
             return;
         }
         
         NSMutableArray *commodityInfo = responseObject[@"commodityInfo"];
         if (![statusCode isEqualToString:@"200"])
         {
             return;
         }
         
         [_commodityDetailArray removeAllObjects];
         for (int i = 0; i < commodityInfo.count; i++)
         {
             MFInStoreGoodsModel *goodsModel = [MFInStoreGoodsModel objectWithKeyValues:commodityInfo[i]];
             if (goodsModel.smallItemUrl == nil)
             {
                 goodsModel.smallItemUrl = [MFCommodityUrlHelper inStoreGoodsSmallItemUrl:goodsModel.originalItemUrl];
             }
             
             [_commodityDetailArray addObject:goodsModel];
         }
         
         dispatch_main_async_safe(^{
             
             if (_commodityDetailArray.count > 0) {
                 _blankTipView.hidden = YES;
                 _inStoreGoodsCollectionView.hidden = NO;
             }
             else
             {
                 _blankTipView.hidden = NO;
                 _inStoreGoodsCollectionView.hidden = YES;
             }
             
             [self setNavTitle];
             [self setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightNavTitleView]];
             [_inStoreGoodsCollectionView setContentOffset:CGPointZero animated:NO];
             [_inStoreGoodsCollectionView reloadData];
         });
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self hiddenMBStatus];
     }];
}

-(CGSize)smallItemsSizeForGoodsModel:(MFInStoreGoodsModel *)goodsModel
{
    NSString *url = goodsModel.smallItemUrl;
    return [[MFSmallCellSizeCacheManger sharedManager] smallItemsSizeForUrl:url blockWithSuccess:^(NSString *url)
            {
                NSArray *indexPathsForVisibleItems = [_inStoreGoodsCollectionView indexPathsForVisibleItems];
                
                [indexPathsForVisibleItems enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSInteger index = indexPath.row;
                    MFInStoreGoodsModel  *obj = _commodityDetailArray[index];
                    if (obj.smallItemUrl == url) {
                        [_inStoreGoodsCollectionView reloadData];
                        
                        *stop = YES;
                    }
                }];
                
            } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
