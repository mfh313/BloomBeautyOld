//
//  MFCustomerSearchResultsCell.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerSearchResultsCell.h"
#import "MFUnderLineButton.h"

@interface MFCustomerSearchResultsCell () <MFLongPressImageViewDelegate>
{
    
    __weak IBOutlet MFUILongPressImageView *_headImageView;
    
    __weak IBOutlet UILabel *_nameLabel;
    
    __weak IBOutlet UILabel *_analysisStatusLabel;
    
    __weak IBOutlet UILabel *_memeberLevelLabel;
    
    __weak IBOutlet UIButton *_analysisBtn;
    
}

@end

@implementation MFCustomerSearchResultsCell
@synthesize delegate;
@synthesize indexPath;

- (void)awakeFromNib
{
    _headImageView.delegate = self;
    _headImageView.image = MFImage(@"zbl31");
    _headImageView.layer.cornerRadius = CGRectGetWidth(_headImageView.bounds)/2;
    _headImageView.layer.masksToBounds = YES;

    [_analysisBtn setTitle:@"再次诊断" forState:UIControlStateNormal];

}

-(void)setCustomerInfo:(CustomerInfo *)customerInfo
{
    _customerInfo = customerInfo;
    [self setCustomerInfoViews];
}

-(void)setHeadImageByUrl
{
    UIImage *image = MFImage(@"zbl31");
    if(self.customerInfo != nil )
    {
        if(self.customerInfo.portraitUrl != nil && self.customerInfo.individualNo != nil)
        {
            image = [[ImageSanBoxUtil sharedUtil] getImageByLoginUser:[self.customerInfo getImgNameByPortraitUpdateDate]];
            if(image == nil)
            {
                NSURL *nsUrl = [NSURL URLWithString:self.customerInfo.portraitUrl];
                [_headImageView sd_setImageWithURL:nsUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [[ImageSanBoxUtil sharedUtil] setImageByLoginUser:[self.customerInfo getImgNameByPortraitUpdateDate] image:image];
                }];
            }
        }
    }
    _headImageView.image = image;
}


-(void)setCustomerInfoViews
{
    _nameLabel.text = [_customerInfo getFullName];
    if(_customerInfo.isDiagnosis && [_customerInfo.isDiagnosis MF_isDiagnosis])
    {
        [_analysisBtn setTitle:@"再次诊断" forState:UIControlStateNormal];
    }
    else
    {
        [_analysisBtn setTitle:@"立即诊断" forState:UIControlStateNormal];
    }
    
     [self setHeadImageByUrl];
    
    _analysisStatusLabel.text = [_customerInfo getStrIsDiagnosis];
    _memeberLevelLabel.text = _customerInfo.individualGroupDesc;
    
}

- (IBAction)onClickAnalysis:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onClickAnalysis:)]) {
        [self.delegate onClickAnalysis:self.indexPath];
    }
}

#pragma mark - MFLongPressImageViewDelegate

- (void)OnPress:(MFUILongPressImageView*)imgView
{
    if ([self.delegate respondsToSelector:@selector(onClickHeadImage:)]) {
        [self.delegate onClickHeadImage:self.indexPath];
    }
}

@end
