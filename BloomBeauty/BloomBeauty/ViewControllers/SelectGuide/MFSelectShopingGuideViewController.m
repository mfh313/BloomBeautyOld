//
//  MFSelectShopingGuideViewController.m
//  装扮灵
//
//  Created by Administrator on 15/10/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSelectShopingGuideViewController.h"
#import "MFLoginCenter.h"
#import "MFSelectGuideView.h"

@interface MFSelectShopingGuideViewController ()<MFSelectGuideViewDelegate>
{
    
    __weak IBOutlet UIButton *_brandIcon;
    
    __weak IBOutlet UILabel *_entityNameLabel;
    
    __weak IBOutlet MFSelectGuideView *_selectGuideView;
    
    __weak IBOutlet UIButton *_quitLoginBtn;
}

@end

@implementation MFSelectShopingGuideViewController
@synthesize backBlock;
@synthesize nextBlock;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_quitLoginBtn setTitleColor:BBDefaultColor forState:UIControlStateNormal];
    _selectGuideView.delegate = self;
    
    LoginUserInfo *info = [MFLoginCenter sharedCenter].loginInfo;
    [self setBrand:info.entityBrandCode Store:info.entityName];
    
    [_selectGuideView queryEmployee:info.entityId];
    
    NSString *brandImageUrl = [MFLoginCenter sharedCenter].loginInfo.brandPictureUrl;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:brandImageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        dispatch_main_async_safe(^{
            [_brandIcon setImage:image forState:UIControlStateNormal];
        });
    }];
    
}

-(void)setBrand:(NSString *)brand Store:(NSString *)store
{
    _entityNameLabel.text = store;
}

- (IBAction)backForawd:(id)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)didSelectedEmployee:(BBEmployeeInfo *)employee
{
    BBEmployeeInfo *selectEmployeeInfo = _selectGuideView.selectedEmployeeInfo;
    [MFLoginCenter sharedCenter].currentShopingGuideInfo = selectEmployeeInfo;
    if (!selectEmployeeInfo) {
        NSLog(@"请先选择你是谁");
        return;
    }
    
    if (self.nextBlock) {
        self.nextBlock(selectEmployeeInfo);
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
