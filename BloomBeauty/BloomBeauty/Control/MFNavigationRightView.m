//
//  MFNavigationRightView.m
//  BloomBeauty
//
//  Created by Administrator on 15/11/6.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFNavigationRightView.h"

@interface MFNavigationRightView ()
{
    __weak IBOutlet MFUIImageView *_headImageView;
    __weak IBOutlet UILabel *_nameLabel;
    
}

@end

@implementation MFNavigationRightView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _headImageView.backgroundColor = [UIColor clearColor];
    _headImageView.layer.cornerRadius = 21;
    _headImageView.layer.borderColor = [UIColor clearColor].CGColor;
    _headImageView.layer.borderWidth = 0.2;
    _headImageView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiCustomerUpdateImage:) name:MFNotifiCurrentCustomerInfoChange object:nil];
}

-(void)notifiCustomerUpdateImage:(NSNotification *)notification
{
    CustomerInfo *info = [[MFLoginCenter sharedCenter] currentCustomerInfo];
    _nameLabel.text = info.individualName;
    [self setHeadImageByUrl:info];
}

-(void)setHeadImageByUrl:(CustomerInfo *)customerInfo
{
    NSString *name = [customerInfo getFullName];
    CGFloat width = 62 + [name MFSizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.frame = CGRectMake(0, 0, width, 44);

    _nameLabel.text = name;
//    UIImage *image = MFImage(@"zbl31");
//    _headImageView.image = image;
//    
//    if(customerInfo.portraitUrl != nil && customerInfo.individualNo != nil)
//    {
//        image = [[ImageSanBoxUtil sharedUtil] getImageByLoginUser:[customerInfo getImgNameByPortraitUpdateDate] ];
//        if(image == nil)
//        {
//            NSURL *nsUrl = [NSURL URLWithString:customerInfo.portraitUrl];
//            
//            [_headImageView sd_setImageWithURL:nsUrl placeholderImage:MFImage(@"zbl31") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                [[ImageSanBoxUtil sharedUtil] setImageByLoginUser:[customerInfo getImgNameByPortraitUpdateDate] image:image];
//                _headImageView.image = image;
//            }];
//        }
//        
//        _headImageView.image = image;
//    }
    
    NSURL *nsUrl = [NSURL URLWithString:customerInfo.portraitUrl];
    [_headImageView sd_setImageWithURL:nsUrl placeholderImage:MFImage(@"zbl31") options:SDWebImageRefreshCached];
}

-(void)setHeadImage:(UIImage *)image name:(NSString *)name
{
    
    CGFloat width = 62 + [name MFSizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.frame = CGRectMake(0, 0, width, 44);
    
    if (image) {
        _headImageView.image = image;
    }
    else
    {
        _headImageView.image = MFImage(@"zbl31");
    }
    
    _nameLabel.text = name;  
    
}

-(CGRect)headImageFrame
{
    CGRect frame = [_headImageView convertRect:_headImageView.frame toView:MFAppWindow];
    CGRect newFrame = frame;
    newFrame.origin.x = CGRectGetWidth(MFAppWindow.bounds)-CGRectGetWidth(self.bounds) + 10;
    newFrame.origin.y = frame.origin.y + 20;
    return newFrame;
}

-(void)setHeadImageHidden:(BOOL)hidden
{
    _headImageView.hidden = hidden;
}

@end
