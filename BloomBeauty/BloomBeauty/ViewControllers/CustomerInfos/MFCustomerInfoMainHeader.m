//
//  MFCustomerInfoMainHeader.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/11.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerInfoMainHeader.h"
#import "MFUILongPressImageView.h"
#import <CoreText/CoreText.h>
#import "DiagnosisResult.h"
#import "MFUILongPressImageView.h"
@interface MFCustomerInfoMainHeader ()<MFLongPressImageViewDelegate>
{

    __weak IBOutlet UILabel *_nameLabel;
    
    __weak IBOutlet UIView *_analysisStatusView;
    
    __weak IBOutlet UILabel *_analysisStatusLabel;
    
    UIPopoverController *popCon;
    
}

@end


@implementation MFCustomerInfoMainHeader
@synthesize delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor hx_colorWithHexString:@"1c1e2a"];
    _headImageView.layer.cornerRadius = 41;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.delegate = self;
    
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"";
    
    _analysisStatusView.hidden = YES;
}

-(void)setHeadImage:(UIImage *)image
{
    _headImageView.image = image;
}

-(void)setHeadImageByUrl:(CustomerInfo *)customerInfo
{
    NSURL *nsUrl = [NSURL URLWithString:customerInfo.portraitUrl];
    [_headImageView sd_setImageWithURL:nsUrl placeholderImage:MFImage(@"zbl31") options:SDWebImageRefreshCached];
}

-(void)setName:(NSString *)name
{
    _nameLabel.text = name;
}

-(void)setAnalysisStatus:(BOOL)analysisStatus
{
    _analysisStatusView.hidden = NO;
    if (analysisStatus) {
        _analysisStatusLabel.text = @"已诊断";
    }
    else
    {
        _analysisStatusLabel.text = @"未诊断";
    }
}

#pragma mark - MFLongPressImageViewDelegate
- (void)OnTouchDown:(MFUILongPressImageView*)imgView
{
    if([self.delegate respondsToSelector:@selector(OnTouchDownHeadImage)])
    {
        [self.delegate OnTouchDownHeadImage];
    }
}

@end
