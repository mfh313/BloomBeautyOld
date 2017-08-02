//
//  MsgImgFullScreenViewController.m
//  Spring
//
//  Created by EEKA on 16/3/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MsgImgFullScreenViewController.h"
#import "MFCommodityDetailModel.h"

@interface MsgImgFullScreenViewController ()

@end

@implementation MsgImgFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MF_wantsFullScreenLayout:NO];
    self.view.backgroundColor = [UIColor yellowColor];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTapView:)];
    [self.view addGestureRecognizer:tapGes];
}

- (void)onSingleTapView:(UITapGestureRecognizer *)ges
{
    if ([self.m_delegate respondsToSelector:@selector(onSingleTap)]) {
        [self.m_delegate onSingleTap];
    }
}

-(void)initWithCommodityDetailModel:(MFCommodityDetailModel *)commodityDetailModel
{
    if (!pagingScrollView) {
        pagingScrollView = [[MsgImgFullScreenContainer alloc] initWithFrame:self.view.bounds];
        pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:pagingScrollView];
    }
    
    [pagingScrollView initWithCommodityDetailModel:commodityDetailModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
