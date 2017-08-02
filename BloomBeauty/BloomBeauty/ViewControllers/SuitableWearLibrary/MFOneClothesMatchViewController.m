//
//  MFOneClothesMatchViewController.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/24.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFOneClothesMatchViewController.h"
#import "MFCommodityDetailModel.h"
#import "LoopPageScrollView.h"
#import "MFOneClothesMatchItemView.h"
#import "MFCommodityDetailViewController.h"

@interface MFOneClothesMatchViewController () <LoopPageScrollViewDataSourceDelegate,MFOneClothesMatchItemViewDelegate,MFLongPressImageViewDelegate>
{
    NSMutableArray *_matchItemArray;
    LoopPageScrollView *_loopScrollView;
}

@end

@implementation MFOneClothesMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.title = @"一衣多搭";
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    _matchItemArray = [NSMutableArray array];
    
    _loopScrollView = [[LoopPageScrollView alloc] initWithFrame:self.view.bounds];
    _loopScrollView.m_delegate = self;
    _loopScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_loopScrollView];
    
    [self generateOneClothesMatch];
    
    MFUILongPressImageView *longPressView = [[MFUILongPressImageView alloc] initWithImage:nil];
    longPressView.frame = CGRectMake(0, 0, 80, 44);
    longPressView.m_fLongPressTime = 2.0f;
    longPressView.backgroundColor = [UIColor clearColor];
    longPressView.delegate = self;
    [self setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:longPressView]];
    
}

-(void)OnLongPress:(MFUILongPressImageView *)imgView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeColor" object:nil];
}

- (void)onClickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)generateOneClothesMatch
{
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    NSString *commodityCode = self.commodityDetailModel.commodityCode;
    
    self.diagnosisResultId = [MFLoginCenter sharedCenter].currentCustomerInfo.lastDiagnosisResultId;
    
    if (!self.diagnosisResultId) {
        return;
    }
    
    NSNumber *entityId = self.brandItemInfo.entityId;
    NSNumber *entityBrandId = self.brandItemInfo.entityBrandId;
    if (!self.brandItemInfo)
    {
        entityId = [MFLoginCenter sharedCenter].loginInfo.entityId;
        entityBrandId = [MFLoginCenter sharedCenter].loginInfo.entityBrandId;
    }
    
    NSDictionary *parameters = @{@"token": token,
                                 @"diagnosisResultId": self.diagnosisResultId,
                                 @"entityId": entityId,
                                 @"entityBrandId":entityBrandId,
                                 @"itemStyleColor":commodityCode
                                 };
    
    
    
    __weak typeof(self) weakSelf = self;
    
    [self showMBCircleInViewController];
    
    [MFHTTPUtil POST:MFApiGenerateOneClothesMatchMatchURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         __strong typeof(self) strongSelf = weakSelf;
         
         [strongSelf hiddenMBStatus];
         
         NSString *statusCode = responseObject[@"statusCode"];
         if (![statusCode isEqualToString:@"200"])
         {
             return;
         }
         
         if ([responseObject[@"oneClothesMatch"] isKindOfClass:[NSNull class]]) {
             [strongSelf showTips:@"无搭配数据" withDuration:1];
             return;
         }
         
         NSArray *matchArray = responseObject[@"oneClothesMatch"];
         [_matchItemArray removeAllObjects];
         
         for (int i = 0; i < matchArray.count; i++) {
             
             NSMutableArray *matchkeyItemArray = [NSMutableArray array];
             
             NSDictionary *itemDic = matchArray[i];
             NSArray *keys = @[@"upperItem",@"middleItem",@"downItem"];
             for (NSString *key in keys)
             {
                 if ([itemDic[key] isKindOfClass:[NSNull class]]) {
                     [matchkeyItemArray addObject:[NSNull null]];
                 }
                 else
                 {
                     MFOneClothesMatchDataItem *item = [MFOneClothesMatchDataItem objectWithKeyValues:itemDic[key]];
                     if (item.smallItemUrl == nil)
                     {
                         item.smallItemUrl = [MFCommodityUrlHelper oneClothesMatchShowingItemUrl:item.originalItemUrl];
                     }
                     
                     item.itemkey = key;
                     
                     [matchkeyItemArray addObject:item];
                 }
                 
             }
             
             [_matchItemArray addObject:matchkeyItemArray];
             
         }
         
         strongSelf.title = [NSString stringWithFormat:@"一衣多搭(%lu组)",(unsigned long)_matchItemArray.count];
         
         dispatch_main_async_safe(^{
             [_loopScrollView reloadData];
         });
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [weakSelf hiddenMBStatus];
         NSLog(@"Error: %@", error);
     }];
    
}

- (void)didChangeToPage:(NSInteger)page
{
    
}

- (int)totalNumOfPage
{
    return (int)_matchItemArray.count;
}

- (UIView *)viewForPage:(UIView *)view pageNum:(NSInteger)number
{
    MFOneClothesMatchItemView *itemView = [[MFOneClothesMatchItemView alloc] initWithFrame:view.bounds];
    itemView.m_delegate = self;
    itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:itemView];
    
    NSArray *itemArray = _matchItemArray[number];
    [itemView setClothesMatchInfo:itemArray];
    
    return view;
}

-(void)didTapMatchDataItem:(MFOneClothesMatchDataItem *)dataItem
{
    if (!dataItem.itemStyleColor) {
        return;
    }
    
    MFCommodityDetailModel *commodityDetailModel = [MFCommodityDetailModel new];
    commodityDetailModel.commodityCode = dataItem.itemStyleColor;
    commodityDetailModel.commodityThumbNailUrl = dataItem.smallItemUrl;
    commodityDetailModel.commodityImageOriginalUrl = dataItem.originalItemUrl;
    
    MFCommodityDetailViewController *commodityDetailVC = [BBInStoreGoodstoryBoard instantiateViewControllerWithIdentifier:@"MFCommodityDetailViewController"];
    commodityDetailVC.commodityDetailModel = commodityDetailModel;
    [self.navigationController pushViewController:commodityDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
