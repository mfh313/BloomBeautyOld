//
//  MFCommodityDetailImageView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/4/22.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCommodityDetailImageView.h"

@interface MFCommodityDetailImageView ()<MFLongPressImageViewDelegate>
{
    __weak IBOutlet UIView *_noImageTipsView;
    MFUILongPressImageView *_imageView;
}

@end

@implementation MFCommodityDetailImageView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initImageView];
}

-(void)initImageView
{
    _imageView = [[MFUILongPressImageView alloc] initWithImage:nil];
    _imageView.delegate = self;
    _imageView.frame = self.bounds;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_imageView];
    
    [_imageView setShowActivityIndicatorView:YES];
    [_imageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}


-(void)fillContentImageView
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]
                  placeholderImage:MFImage(@"zbl56")
                           options:SDWebImageRetryFailed
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                              
                          } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              
                              dispatch_main_async_safe(^{
                                  if (image)
                                  {
                                      _imageView.contentMode = UIViewContentModeScaleAspectFit;
                                      _imageView.image = image;
                                  }
                                  else
                                  {
                                      [_imageView setHidden:YES];
                                      [_noImageTipsView setHidden:NO];
                                  }
                                  
                              });
                              
                          }];
}

@end
