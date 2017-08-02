//
//  MFSalingProdouctSearchViewController.m
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFSalingProdouctSearchViewController.h"
#import "MFSalingProdouctSearchBlankView.h"
#import "MFSalingProdouctSearchResultView.h"
#import "MFCommodityQueryByItemCodeApi.h"
#import "MFCommodityDetailModel.h"
#import "MFSearchBar.h"

@interface MFSalingProdouctSearchViewController ()<MFSearchBarDelegate>
{
    MFSalingProdouctSearchBlankView *_blankView;
    MFSalingProdouctSearchResultView *_resultView;
    MFCommodityQueryByItemCodeApi *_queryApi;
    NSString *_searchItemCode;
    
    MFInStoreGoodsModel *_resultGoodsModel;
    
    MFSearchBar *_searchBar;
}

@end

@implementation MFSalingProdouctSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    
    _searchBar = [MFSearchBar viewWithNib];
    [_searchBar setPlaceHolder:@"尽量输入完整款号搜索"];
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0, 600, 44);
    self.navigationItem.titleView = _searchBar;
    
    _blankView = [MFSalingProdouctSearchBlankView viewWithNib];
    _blankView.frame = self.view.bounds;
    [self.view addSubview:_blankView];
    
    _resultView = [MFSalingProdouctSearchResultView viewWithNib];
    _resultView.frame = self.view.bounds;
    [self.view addSubview:_resultView];
    
    [_resultView setHidden:YES];
    [_blankView setHidden:YES];
    
    _queryApi = [MFCommodityQueryByItemCodeApi new];
    
    [self showTips:@"尽量输入完整款号搜索"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_searchBar becomeFirstResponder];
    });
}

#pragma mark - MFSearchBarDelegate
-(void)searchBarCancelButtonClicked:(MFSearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

-(BOOL)searchBar:(MFSearchBar *)searchBar shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)searchBar:(MFSearchBar *)searchBar searchText:(NSString *)text
{
    _searchItemCode = text;  //@"E1AGB100101";
    [self queryCommodityByItemCode];
}

-(void)queryCommodityByItemCode
{
    BBEmployeeInfo *currentShopingGuideInfo = [MFLoginCenter sharedCenter].currentShopingGuideInfo;
    if (!currentShopingGuideInfo.entityId)
    {
        return;
    }
    
    _queryApi.entityId = currentShopingGuideInfo.entityId;
    _queryApi.commodityCode = _searchItemCode;
    
    __weak typeof(self) weakSelf = self;
    
    [weakSelf showMBCircleInViewController];
    [_queryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [weakSelf hiddenMBStatus];
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSMutableArray *commodityInfo = responseObject[@"commodityInfo"];
        
        if (responseObject[@"statusCode"] && [responseObject[@"statusCode"] isKindOfClass:[NSString class]]) {
            NSString *statusCode = (NSString *)responseObject[@"statusCode"];
            
            if (![statusCode isEqualToString:@"200"]) {
                [weakSelf showTips:(NSString *)responseObject[@"message"]];
                [_resultView setHidden:YES];
                [_blankView setHidden:YES];
                return;
            }
        }
        
        if ([commodityInfo isKindOfClass:[NSArray class]] && commodityInfo.count > 0) {
            _resultGoodsModel = [MFInStoreGoodsModel objectWithKeyValues:commodityInfo[0]];
            if (_resultGoodsModel.smallItemUrl == nil)
            {
                _resultGoodsModel.smallItemUrl = [MFCommodityUrlHelper inStoreGoodsSmallItemUrl:_resultGoodsModel.originalItemUrl];
            }
            _resultGoodsModel.originalItemUrl = [MFCommodityUrlHelper inStoreGoodsShowingOriginalItemUrl:_resultGoodsModel.originalItemUrl];
            
            _resultView.itemStyleColor = _resultGoodsModel.itemStyleColor;
            _resultView.itemOriginalItemUrl = _resultGoodsModel.originalItemUrl;
            
            dispatch_main_async_safe(^{
                [_blankView setHidden:YES];
                [_resultView setHidden:NO];
                [self.view bringSubviewToFront:_resultView];
                [_resultView queryAvailableDetail];
            });
        }
        else
        {
            [_resultView setHidden:YES];
            [_blankView setHidden:NO];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf hiddenMBStatus];
    }];
}

-(void)onClickBackBtn:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
