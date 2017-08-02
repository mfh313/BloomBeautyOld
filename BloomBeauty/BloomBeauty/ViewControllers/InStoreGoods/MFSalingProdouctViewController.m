//
//  MFSalingProdouctViewController.m
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSalingProdouctViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MFCommodityDetailModel.h"
#import "MFCommodityDetailViewController.h"
#import "MFCountsTitleView.h"
#import "MFSalingProdouctItemView.h"
#import "MFSmallCellSizeCacheManger.h"
#import "MFSalingProdouctQueryApi.h"
#import "MFGoodsFilter.h"
#import "MFSalingProdouctRightNaviView.h"
#import "MFSalingProdouctSearchViewController.h"

@interface MFSalingProdouctViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,MFSalingProdouctItemViewDelegate,MFGoodsFilterDelegate>
{
    __weak IBOutlet MFUICollectionView *_inStoreGoodsCollectionView;
    __weak IBOutlet UIView *_scrollTipsView;
    __weak IBOutlet NSLayoutConstraint *_topConstraint;
    
    NSMutableArray *_inStoreGoodsArray;
    MFCountsTitleView *_titleView;
    
    MFSalingProdouctQueryApi *_salingProdouctQueryApi;

    MFGoodsFilter *_filterView;
    
    UILabel *_tipsLabel;
    
    NSString *_filterStrForCommodityCode;
    NSString *_filterStrForOccasions;
}

@end

@implementation MFSalingProdouctViewController

-(void)dealloc
{
    [self removeObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MF_wantsFullScreenLayout:NO];
    
    _inStoreGoodsArray = [NSMutableArray array];
    
    [self initCollectionView];
    [_inStoreGoodsCollectionView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFSalingProdouctViewController"];
    
    [self initHeader];
    [self addScrollObservers];
    
    [self setNavTitle];
    [self setNaviItemViews];
    
    _salingProdouctQueryApi = [MFSalingProdouctQueryApi new];
    [self queryAvailableCommodity];
    
    _filterView = [MFGoodsFilter viewWithNib];
    _filterView.m_delegate = self;
    _filterView.frame = MFAppWindow.bounds;
}

#pragma mark - MFGoodsFilterDelegate
-(void)onClickFilterDoneCommodityCodeStr:(NSString *)filterStrForCommodityCode occasions:(NSString *)filterStrForOccasions
{
    _filterStrForCommodityCode = filterStrForCommodityCode;
    _filterStrForOccasions = filterStrForOccasions;
    
    [_filterView removeFromSuperview];
    [self queryAvailableCommodity];
}

-(void)onClickFilterDoneCommodityCodeDescription:(NSString *)filterStrForCommodityCodeDesc
                                   occasionsDesc:(NSString *)filterStrForOccasionsDesc
{
    if (filterStrForCommodityCodeDesc == nil && filterStrForOccasionsDesc == nil) {
        _topConstraint.constant = 0;
        [_tipsLabel removeFromSuperview];
        return;
    }
    
    NSMutableString *dec = [[NSMutableString alloc] initWithString:@"您已选择   "];
    if (filterStrForCommodityCodeDesc) {
        [dec appendString:[NSString stringWithFormat:@"品类:%@   ",filterStrForCommodityCodeDesc]];
    }
    
    if (filterStrForOccasionsDesc) {
        [dec appendString:[NSString stringWithFormat:@"场合:%@",filterStrForOccasionsDesc]];
    }
    
    _topConstraint.constant = 60;
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.view.frame)-30, 60)];
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:16.0];
        _tipsLabel.textColor = MFDarkGrayColor;
    }
    
    [self.view addSubview:_tipsLabel];
    _tipsLabel.text = dec;
}

-(void)setNavTitle
{
    if (_inStoreGoodsArray.count > 0) {
        [_titleView setNavTitle:@"在店单品 "
                   suffixString:[NSString stringWithFormat:@"(%d款)",(int)_inStoreGoodsArray.count]
                       sufColor:[UIColor whiteColor]];
    }
    else
    {
        [_titleView setNavTitle:@"在店单品"];
    }
}

-(void)setNaviItemViews
{
    _titleView = [MFCountsTitleView viewWithNib];
    _titleView.frame = CGRectMake(0, 0, 200, 44);
    self.navigationItem.titleView = _titleView;
    

    MFSalingProdouctRightNaviView *rightNavTitleView = [MFSalingProdouctRightNaviView viewWithNib];
    rightNavTitleView.frame = CGRectMake(0, 0, 220, 44);
    [rightNavTitleView.filterBtn addTarget:self action:@selector(onClickFilterBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightNavTitleView.searchBtn addTarget:self action:@selector(onClickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavTitleView];
    [self setRightBarButtonItem:rightBarButtonItem];

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

-(void)onClickSearchBtn
{
    //TODO:基于装扮灵架构实现navpush全屏！！
    
    MFSalingProdouctSearchViewController *searchVC = [[MFSalingProdouctSearchViewController alloc] init];
    
    MFNavigationController *nav = [[MFNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)initHeader
{
    __weak typeof(self) weakSelf = self;
    _inStoreGoodsCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf queryAvailableCommodity];
        [_inStoreGoodsCollectionView.mj_header endRefreshing];
    }];
}

-(void)addScrollObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_inStoreGoodsCollectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)removeObservers
{
    [_inStoreGoodsCollectionView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = _inStoreGoodsCollectionView.contentOffset.y;
        if (offsetY > 900) {
            [_scrollTipsView setHidden:NO];
        }
        else
        {
            [_scrollTipsView setHidden:YES];
        }
    }
}

- (IBAction)onClickScrollTop:(id)sender
{
    [_inStoreGoodsCollectionView setContentOffset:CGPointZero animated:NO];
}


-(void)initCollectionView
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumColumnSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    layout.columnCount = 4;
    _inStoreGoodsCollectionView.collectionViewLayout = layout;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _inStoreGoodsArray.count;
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
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFCollectionViewCell *iCell = (MFCollectionViewCell *)cell;
    iCell.m_subContentView.frame = iCell.contentView.bounds;
    
    __block MFInStoreGoodsModel *goodsModel = _inStoreGoodsArray[indexPath.row];
    
    MFSalingProdouctItemView *cellView = (MFSalingProdouctItemView *)iCell.m_subContentView;
    [cellView setInStoreGoodsModel:goodsModel];
    
    [cellView.imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.smallItemUrl] placeholderImage:MFImage(@"zbl55") options:SDWebImageRetryFailed];
    
    __weak typeof(self) weakSelf = self;
    [cellView setClickBlock:^(BOOL didSelected, NSString *itemStyleColor, NSString *tips) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showTips:tips withDuration:0.5];
    }];
}

-(void)didSelectSalingProdouct:(MFInStoreGoodsModel *)goodsModel
{
    MFCommodityDetailModel *commodityDetailModel = [MFCommodityDetailModel new];
    commodityDetailModel.commodityCode = goodsModel.itemStyleColor;
    commodityDetailModel.commodityImageOriginalUrl = goodsModel.originalItemUrl;
    commodityDetailModel.commodityThumbNailUrl = goodsModel.smallItemUrl;
    
    MFCommodityDetailViewController *commodityDetailVC = [BBInStoreGoodstoryBoard instantiateViewControllerWithIdentifier:@"MFCommodityDetailViewController"];
    commodityDetailVC.commodityDetailModel = commodityDetailModel;
    [self.navigationController pushViewController:commodityDetailVC animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFInStoreGoodsModel *goodsModel = _inStoreGoodsArray[indexPath.row];
    return [self smallItemsSizeForGoodsModel:goodsModel];
}

-(void)queryAvailableCommodity
{
    BBEmployeeInfo *currentShopingGuideInfo = [MFLoginCenter sharedCenter].currentShopingGuideInfo;
    if (!currentShopingGuideInfo.entityId)
    {
        return;
    }
    
    _salingProdouctQueryApi.entityId = currentShopingGuideInfo.entityId;
    _salingProdouctQueryApi.categoryCode = _filterStrForCommodityCode;
    _salingProdouctQueryApi.occasions = _filterStrForOccasions;
    
    __weak typeof(self) weakSelf = self;
    [_salingProdouctQueryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSMutableArray *commodityInfo = responseObject[@"commodityInfo"];
        
        [_inStoreGoodsArray removeAllObjects];
        for (int i = 0; i < commodityInfo.count; i++) {
            MFInStoreGoodsModel *goodsModel = [MFInStoreGoodsModel objectWithKeyValues:commodityInfo[i]];
            if (goodsModel.smallItemUrl == nil)
            {
                goodsModel.smallItemUrl = [MFCommodityUrlHelper inStoreGoodsSmallItemUrl:goodsModel.originalItemUrl];
            }
            
            goodsModel.originalItemUrl = [MFCommodityUrlHelper inStoreGoodsShowingOriginalItemUrl:goodsModel.originalItemUrl];
            
            [_inStoreGoodsArray addObject:goodsModel];
        }
        
        dispatch_main_async_safe(^{
            [weakSelf setNavTitle];
            [_inStoreGoodsCollectionView reloadData];
        });
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
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
            MFInStoreGoodsModel  *obj = _inStoreGoodsArray[index];
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
