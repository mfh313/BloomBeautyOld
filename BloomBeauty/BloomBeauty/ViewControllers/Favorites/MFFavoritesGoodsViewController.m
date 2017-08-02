//
//  MFFavoritesGoodsViewController.m
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFFavoritesGoodsViewController.h"
#import "MFInstoreGoodsCollectionCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MFCommodityDetailModel.h"
#import "MFCommodityDetailViewController.h"

@interface MFFavoritesGoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,MFInstoreGoodsItemViewDelegate,MFFavoriteButtonDelegate>
{
    __weak IBOutlet MFUICollectionView *_favGoodsCollectionView;
    NSMutableArray *_favGoodsArray;
    MFNavigationRightView *_rightNaviItemView;
}

@end

@implementation MFFavoritesGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self MF_wantsFullScreenLayout:NO];
    _favGoodsArray = [NSMutableArray array];
    [self initCollectionView];
    [_favGoodsCollectionView registerNib:[MFInstoreGoodsCollectionCell nib] forCellWithReuseIdentifier:[MFInstoreGoodsCollectionCell nibid]];
    [self queryAvailableCommodity];
    
    [self setNaviItemViews];
    [self initHeader];
}

-(void)setNaviItemViews
{
    _rightNaviItemView = [MFNavigationRightView viewWithNibName:@"MFNavigationRightView"];
    _rightNaviItemView.frame = CGRectMake(0, 0, 100, 44);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNaviItemView];
    [self setRightBarButtonItem:rightBarButtonItem];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CustomerInfo *info = [MFLoginCenter sharedCenter].currentCustomerInfo;
    if (info)
    {
        [_rightNaviItemView setHeadImageByUrl:info];
        [self setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightNaviItemView]];
    }
    else
    {
        [self setRightBarButtonItem:nil];
    }
    [_favGoodsCollectionView reloadData];
    if (self.block) {
        self.block(_favGoodsArray);
    }
}

-(void)initHeader
{
    __weak typeof(self)weakSelf = self;
    _favGoodsCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf queryAvailableCommodity];
        [_favGoodsCollectionView.mj_header endRefreshing];
    }];
}

-(void)initCollectionView
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 5);
    layout.minimumColumnSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    layout.columnCount = 4;
    _favGoodsCollectionView.collectionViewLayout = layout;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _favGoodsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFInstoreGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFInstoreGoodsCollectionCell nibid] forIndexPath:indexPath];
    MFInstoreGoodsItemView *itemView = cell.itemView;
    [itemView setItemIndexPath:indexPath];
    itemView.delegate = self;
    
    MFCommodityDetailModel *commodityDetailModel = _favGoodsArray[indexPath.row];
    [cell.itemView setCommodityDetailModel:commodityDetailModel];
    BOOL isFavorite = [commodityDetailModel.commodityCode MF_isFavorite];
    [itemView setFavorite:isFavorite];
    
    __weak typeof(self) weakSelf = self;
    [itemView setClickBlock:^(BOOL didSelected, NSString *itemStyleColor, NSString *tips) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showTips:tips withDuration:0.5];
        [strongSelf queryAvailableCommodity];
    }];
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFCommodityDetailModel *commodityDetailModel = _favGoodsArray[indexPath.row];
    return [[MFSmallCellSizeCacheManger sharedManager] smallItemsSizeForUrl:commodityDetailModel.commodityThumbNailUrl blockWithSuccess:^(NSString *url)
            {
                NSArray *indexPathsForVisibleItems = [_favGoodsCollectionView indexPathsForVisibleItems];
                [indexPathsForVisibleItems enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSInteger index = indexPath.row;
                    MFCommodityDetailModel  *obj = _favGoodsArray[index];
                    if (obj.commodityThumbNailUrl == url) {
                        [_favGoodsCollectionView reloadData];
                        
                        *stop = YES;
                    }
                }];
            } failure:nil];
}

#pragma mark - MFInstoreGoodsItemViewDelegate
-(void)didSelectInstoreGoodsItemView:(MFInstoreGoodsItemView *)itemView indexPath:(NSIndexPath *)indexPath
{
    MFCommodityDetailModel *commodityDetailModel = _favGoodsArray[indexPath.row];
    MFCommodityDetailViewController *commodityDetailVC = [BBInStoreGoodstoryBoard instantiateViewControllerWithIdentifier:@"MFCommodityDetailViewController"];
    commodityDetailVC.commodityDetailModel = commodityDetailModel;
    [self.navigationController pushViewController:commodityDetailVC animated:YES];
}

-(void)queryAvailableCommodity
{
    CustomerInfo *currentCustomInfo = [MFLoginCenter sharedCenter].currentCustomerInfo;
    if (!currentCustomInfo)
    {
        return;
    }
     [_favGoodsArray removeAllObjects];
     NSMutableArray *array = [MFLoginCenter sharedCenter].currentCustomerInfo.favoriteArray;
     for (int i = 0; i < array.count; i++) {
         MFCommodityDetailModel *model = [[MFCommodityDetailModel alloc] init];
         CustomerFavoriteCommodityItem *commodityItem = array[i];
         model.commodityCode = commodityItem.itemStyleColor;
         model.commodityThumbNailUrl = commodityItem.smallItemUrl;
         model.commodityImageOriginalUrl = commodityItem.originalItemUrl;
         [_favGoodsArray addObject:model];
     }
     
     dispatch_main_async_safe(^{
         [_favGoodsCollectionView reloadData];
         if (self.block) {
             self.block(_favGoodsArray);
         }
     });
}

-(NSMutableArray *)dataArray
{
    return _favGoodsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
