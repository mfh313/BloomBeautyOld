//
//  MFSuitableWearCommodityDetailViewController.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFSuitableWearCommodityDetailViewController.h"
#import "MFCommodityDetailRightView.h"
#import "MFCommodityDetailModel.h"
#import "MFOneClothesMatchDataItem.h"
#import "MFOneClothesMatchViewController.h"
#import "MsgImgFullScreenWindow.h"
#import "MFCreateStylistMatchViewController.h"
#import "MFQueryAvailableSizeApi.h"
#import "MFCommodityAvailableSizeView.h"

@interface MFSuitableWearCommodityDetailViewController ()<MFLongPressImageViewDelegate>
{
    __weak IBOutlet MFCommodityAvailableSizeView *_detailSizeView;
    
    __weak IBOutlet UIView *_commodityContentView;
    
    __weak IBOutlet UIButton *_oneClothesMatchBtn;
    
    __weak IBOutlet UIButton *_createStylistMatchBtn;
    
    MFUILongPressImageView *_imageView;
    
    MsgImgFullScreenWindow *m_imgFullScreenWnd;
    
    MFQueryAvailableSizeApi *_queryAvailableSizeApi;
}

@end

@implementation MFSuitableWearCommodityDetailViewController
@synthesize diagnosisResultId;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    
    _oneClothesMatchBtn.backgroundColor = BBDefaultColor;
    _createStylistMatchBtn.backgroundColor = BBDefaultColor;
    [_createStylistMatchBtn setHidden:YES];
    
    [self MF_wantsFullScreenLayout:NO];
    
    [self initImageView];
    
    _queryAvailableSizeApi = [MFQueryAvailableSizeApi new];
    [self queryAvailableSize];
}

-(void)initImageView
{
    _imageView = [[MFUILongPressImageView alloc] initWithImage:nil];
    _imageView.delegate = self;
    _imageView.frame = _commodityContentView.bounds;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.contentMode = UIViewContentModeCenter;
    [_commodityContentView addSubview:_imageView];
    
    [_imageView setShowActivityIndicatorView:YES];
    [_imageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.commodityDetailModel.commodityImageOriginalUrl] placeholderImage:MFImage(@"zbl56") options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_main_async_safe(^{
            _imageView.bounds = _commodityContentView.bounds;
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView.image = image;
        });
    }];
    
    
}

-(void)OnPress:(MFUILongPressImageView *)imgView
{
    if (!m_imgFullScreenWnd) {
        m_imgFullScreenWnd = [[MsgImgFullScreenWindow alloc] initWithFrame:MFAppWindow.bounds];
    }
    
    [m_imgFullScreenWnd initWithCommodityDetailModel:self.commodityDetailModel];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [m_imgFullScreenWnd setHidden:NO];
}

-(void)queryAvailableSize
{
    __weak __typeof(self) weakSelf = self;
    
    _queryAvailableSizeApi.entityId = self.brandItemInfo.entityId.stringValue;
    if (!self.brandItemInfo.entityId.stringValue)
    {
        _queryAvailableSizeApi.entityId = [MFLoginCenter sharedCenter].currentShopingGuideInfo.entityId;
    }
    
    _queryAvailableSizeApi.commodityCode = self.commodityDetailModel.commodityCode;
    [_queryAvailableSizeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        if ([responseObject[@"statusCode"] isKindOfClass:[NSNull class]]) {
            return;
        }
        if ([responseObject[@"commodityDetail"] isKindOfClass:[NSNull class]]) {
            return;
        }
        
        NSMutableDictionary *commodityDetailDic = responseObject[@"commodityDetail"];
        NSString *commodityCode = commodityDetailDic[@"commodityCode"];
        NSNumber *listPrice = commodityDetailDic[@"listPrice"];
        NSMutableDictionary *sizeMapDic = commodityDetailDic[@"sizeMap"];
        NSString *hasStylistMatchValue = commodityDetailDic[@"hasStylistMatch"];
        
        if ([hasStylistMatchValue isEqualToString:@"Y"]) {
            [_createStylistMatchBtn setHidden:NO];
        }
        else
        {
            [_createStylistMatchBtn setHidden:YES];
        }
                
        strongSelf.commodityDetailModel.listPrice = listPrice;
        strongSelf.commodityDetailModel.sizeDic = sizeMapDic;
        dispatch_main_async_safe((^{
            [_detailSizeView setCommodityCode:commodityCode];
            [_detailSizeView setListPrice:[NSString stringWithFormat:@"%@",listPrice]];
            [_detailSizeView setSizeMap:sizeMapDic];
        }));
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (IBAction)onClickOneClothesMatch:(id)sender {
    
    MFOneClothesMatchViewController *oneClothesMatchVC = [BBSuitableWearStoryBoard instantiateViewControllerWithIdentifier:@"MFOneClothesMatchViewController"];
    oneClothesMatchVC.commodityDetailModel = self.commodityDetailModel;
    oneClothesMatchVC.brandItemInfo = self.brandItemInfo;
    MFNavigationController *oneClothNav = [[MFNavigationController alloc] initWithRootViewController:oneClothesMatchVC];
    [self presentViewController:oneClothNav animated:YES completion:nil];
    
}

- (IBAction)onClickCreateStylistMatch:(id)sender {
    MFCreateStylistMatchViewController *createStylistMatchVC = [BBSuitableWearStoryBoard instantiateViewControllerWithIdentifier:@"MFCreateStylistMatchViewController"];
    createStylistMatchVC.itemStyleColor = self.commodityDetailModel.commodityCode;
    
    MFNavigationController *oneClothNav = [[MFNavigationController alloc] initWithRootViewController:createStylistMatchVC];
    [self presentViewController:oneClothNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
