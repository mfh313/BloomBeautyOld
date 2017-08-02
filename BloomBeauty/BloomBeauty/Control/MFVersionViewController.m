//
//  MFVersionViewController.m
//  BloomBeauty
//
//  Created by EEKA on 2017/2/8.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFVersionViewController.h"
#import "UpgradeInfoUtil.h"

@interface MFVersionViewController ()
{
    UILabel *_contentLabel;
    
    NSString *_versionString;
}

@end

@implementation MFVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [UIFont systemFontOfSize:12.0];
    _contentLabel.textColor = BBDefaultColor;
    _contentLabel.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentLabel];
    
    _contentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLabel)];
    tapGes.numberOfTapsRequired = 3;
    [_contentLabel addGestureRecognizer:tapGes];
    
    _contentLabel.text = _versionString;
    
}

-(void)viewWillLayoutSubviews
{
    NSArray *children = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarBatteryItemView")]) {
            UIView *batteryItemView = child;
            
            [_contentLabel sizeToFit];
            _contentLabel.frame = CGRectMake(CGRectGetMinX(batteryItemView.frame) - CGRectGetWidth(_contentLabel.bounds) - 100, 0, CGRectGetWidth(_contentLabel.bounds), CGRectGetHeight(batteryItemView.frame));
        }
    }
}

-(void)onTapLabel
{
    NSString *strVersion = [UpgradeInfoUtil getNowVersion];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_BundleVersion = infoDictionary[@"CFBundleVersion"];
    NSString *app_shortVersion = infoDictionary[@"CFBundleShortVersionString"];
    NSString *packageDesc = [MFApiUtil getPackageDesc];
    
    NSString *buildDate = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    
    NSString *string = [NSString stringWithFormat:@"当前环境=%@\n版本详细版本号=%@\nCFBundleShortVersionString=%@\nCFBundleVersion=%@\n编译时间 = %@",packageDesc,
                        strVersion,
                        app_shortVersion,
                        app_BundleVersion,
                        buildDate];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本信息"
                                                    message:string
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)setVersion:(NSString *)string
{
    _versionString = string;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
