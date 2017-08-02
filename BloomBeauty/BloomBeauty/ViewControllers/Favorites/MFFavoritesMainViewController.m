//
//  MFFavoritesMainViewController.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/11.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFFavoritesMainViewController.h"
#import "MFFavoritesBestCollocationViewController.h"
#import "MFFavoritesGoodsViewController.h"
#import "MFFavoritesMainTittleView.h"

@interface MFFavoritesMainViewController ()
{
    __weak IBOutlet UIView *bodyView;
    MFFavoritesGoodsViewController *_favoritesGoodsVC;
    MFFavoritesBestCollocationViewController *_favoritesBestCollocationVC;
    
    MFFavoritesMainTittleView *_titleView;
    
    __weak UILabel *_rightTitleLabel;
}

@end

@implementation MFFavoritesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MF_wantsFullScreenLayout:NO];
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    
    _titleView = [MFFavoritesMainTittleView viewWithNibName:@"MFFavoritesMainTittleView"];
    _titleView.frame = CGRectMake(0, 0, 240, 44);
//    self.navigationItem.titleView = _titleView;
    self.title = @"单品收藏库";
    
    [_titleView.btnGoods setText:@"收藏单品"];
    [_titleView.btnBestCollection setText:@"收藏搭配"];
    [_titleView.btnGoods addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView.btnBestCollection addTarget:self action:@selector(bestCollectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.textAlignment = NSTextAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightTitleLabel];
    
    _rightTitleLabel = rightTitleLabel;
    
    [self goodsClick:nil];
    
}

- (void)goodsClick:(id)sender {
    [_titleView.btnGoods setSelected:YES];
    [_titleView.btnBestCollection setSelected:NO];
    [_favoritesBestCollocationVC.view removeFromSuperview];
    if (!_favoritesGoodsVC) {
        
        _favoritesGoodsVC = [BloomBeautyFavorites instantiateViewControllerWithIdentifier:@"MFFavoritesGoodsViewController"];
        
        __weak UILabel *weakRightTitleLabel = _rightTitleLabel;
        _favoritesGoodsVC.block = ^(NSMutableArray *dataArray)
        {
            __strong UILabel *strongRightTitleLabel = weakRightTitleLabel;
            strongRightTitleLabel.text = [NSString stringWithFormat:@"%lu款",dataArray.count];
        };
        
        [self addChildViewController:_favoritesGoodsVC];
        _favoritesGoodsVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(bodyView.bounds), CGRectGetHeight(bodyView.bounds));
    }
    [bodyView addSubview:_favoritesGoodsVC.view];
    [_favoritesGoodsVC didMoveToParentViewController:self];
    
    NSMutableArray *dataArray = [_favoritesGoodsVC dataArray];
    _rightTitleLabel.text = [NSString stringWithFormat:@"%lu款",dataArray.count];
}

- (void)bestCollectionClick:(id)sender {
    [_titleView.btnGoods setSelected:NO];
    [_titleView.btnBestCollection setSelected:YES];
    
    [_favoritesGoodsVC.view removeFromSuperview];
    if (!_favoritesBestCollocationVC) {
        _favoritesBestCollocationVC = [BloomBeautyFavorites instantiateViewControllerWithIdentifier:@"MFFavoritesBestCollocationViewController"];
        [self addChildViewController:_favoritesBestCollocationVC];
        _favoritesBestCollocationVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(bodyView.bounds), CGRectGetHeight(bodyView.bounds));
    }
    
    [bodyView addSubview:_favoritesBestCollocationVC.view];
    [_favoritesBestCollocationVC didMoveToParentViewController:self];
}

-(void)setBtnSelected:(NSUInteger)index
{
    [_titleView.btnGoods setSelected:NO];
    [_titleView.btnBestCollection setSelected:NO];
    switch (index) {
        case 0:
        {
            [_titleView.btnGoods setSelected:YES];
        }
            break;
        case 1:
        {
            [_titleView.btnBestCollection setSelected:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
