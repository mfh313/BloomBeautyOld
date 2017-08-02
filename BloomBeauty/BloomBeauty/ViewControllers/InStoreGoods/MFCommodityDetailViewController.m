//
//  MFCommodityDetailViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/23.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCommodityDetailViewController.h"
#import "MFCommodityDetailRightView.h"
#import "MFCommodityDetailModel.h"
#import "MsgImgFullScreenWindow.h"
#import "MFCreateStylistMatchViewController.h"
#import "MFQueryAvailableSizeApi.h"
#import "MFCommodityAvailableSizeView.h"

@interface MFCommodityDetailViewController ()<MFLongPressImageViewDelegate>
{
    __weak IBOutlet MFCommodityAvailableSizeView *_detailSizeView;
    
    __weak IBOutlet UIView *_commodityContentView;
    
    __weak IBOutlet UIButton *_createStylistMatchBtn;
    
    MFUILongPressImageView *_imageView;
    MsgImgFullScreenWindow *m_imgFullScreenWnd;
    MFQueryAvailableSizeApi *_queryAvailableSizeApi;
}

@end

@implementation MFCommodityDetailViewController
@synthesize commodityDetailModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self MF_wantsFullScreenLayout:NO];
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    
    _createStylistMatchBtn.backgroundColor = BBDefaultColor;
    [_createStylistMatchBtn setHidden:YES];
    
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
    
    _queryAvailableSizeApi.entityId = [MFLoginCenter sharedCenter].currentShopingGuideInfo.entityId;
    _queryAvailableSizeApi.commodityCode = self.commodityDetailModel.commodityCode;
    [_queryAvailableSizeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        if ([responseObject[@"statusCode"] isKindOfClass:[NSNull class]]
            || [responseObject[@"commodityDetail"] isKindOfClass:[NSNull class]]) {
            return;
        }
        
        NSMutableDictionary *commodityDetailDic = responseObject[@"commodityDetail"];
        NSString *commodityCode = commodityDetailDic[@"commodityCode"];
        NSNumber *listPrice = commodityDetailDic[@"listPrice"];
        NSMutableDictionary *sizeMapDic = commodityDetailDic[@"sizeMap"];
        
        strongSelf.commodityDetailModel.listPrice = listPrice;
        strongSelf.commodityDetailModel.sizeDic = sizeMapDic;
        NSString *hasStylistMatchValue = commodityDetailDic[@"hasStylistMatch"];
        if ([hasStylistMatchValue isEqualToString:@"Y"]) {
            [_createStylistMatchBtn setHidden:NO];
        }
        else
        {
            [_createStylistMatchBtn setHidden:YES];
        }
        
        dispatch_main_async_safe((^{
            [_detailSizeView setCommodityCode:commodityCode];
            [_detailSizeView setListPrice:[NSString stringWithFormat:@"%@",listPrice]];
            [_detailSizeView setSizeMap:sizeMapDic];
        }));
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
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
