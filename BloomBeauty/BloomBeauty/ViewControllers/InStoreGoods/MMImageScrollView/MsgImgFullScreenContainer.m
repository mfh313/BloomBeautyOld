//
//  MsgImgFullScreenContainer.m
//  Spring
//
//  Created by EEKA on 16/3/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MsgImgFullScreenContainer.h"
#import "MFCommodityDetailModel.h"

@implementation MsgImgFullScreenContainer

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 0, 20)];
        _contentImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_contentImageView];
        
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //设置缩放级别才能缩放
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 3;
    }
    
    return self;
}

-(void)initWithCommodityDetailModel:(MFCommodityDetailModel *)commodityDetailModel
{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:commodityDetailModel.commodityImageOriginalUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        dispatch_main_async_safe(^{
            _contentImageView.image = image;
        });
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _contentImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _contentImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_contentImageView.frame, frameToCenter))
        _contentImageView.frame = frameToCenter;
}

@end
