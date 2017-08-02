//
//  ImageScrollView.m
//  Spring
//
//  Created by EEKA on 16/3/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "ImageScrollView.h"

@implementation ImageScrollView

- (void)LongPressEvents
{
    
}

- (void)LongPressBegin
{
    
}


-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
}

-(UIImageView *)getImageView
{
    return imageView;
}

-(UIImage *)getImage
{
    return imageView.image;
}

-(void)updateImage:(UIImage *)image
{
    
}

- (void)displayImage:(UIImage *)image withFrame:(CGRect)imageFrame
{
    CGSize imageFitSize = [m_scrollViewHelper calculateImageFitSizeForPreview:image.size maxSize:imageFrame.size];
    CGRect imgFrame = CGRectMake(0, 0, imageFitSize.width, imageFitSize.height);
    
//    imageView.frame = imgFrame;
//    imageView.backgroundColor = [UIColor redColor];
//    imageView.image = image;
    
    imageView.frame = self.bounds;

    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.center;
    imageView.image = image;
    imageView.backgroundColor = [UIColor clearColor];
}

- (void)displayImage:(UIImage *)image withFrame:(CGRect)imageFrame FullScreen:(BOOL)fullScreen
{
    
}

- (void)displayImage:(UIImage *)image withFrame:(CGRect)imageFrame FullScreen:(BOOL)fullScreen CornerRadius:(float)cornerRadius
{
    
}

- (void)reloadView:(UIImage *)image FullScreen:(BOOL)fullScreen
{
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}

- (void)pressedEvents
{
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imageView];
        
        m_scrollViewHelper = [[MMImageScrollViewHelper alloc] init];
        m_scrollViewHelper.noSingleTaps = NO;
        m_scrollViewHelper.noDoubleTaps = NO;
        m_scrollViewHelper.dontSupportHorizontalLongImage = NO;
        m_scrollViewHelper.dontSupportVerticalLongImage = NO;
        m_scrollViewHelper.dontCalcPreviewRect = NO;
        m_scrollViewHelper.m_delegate = self;
        
        [m_scrollViewHelper InitGestureRecognizer];
        
        self.minimumZoomScale = 1;
        self.delegate = self;
        
    }
    
    return self;
}

- (UIScrollView *)getScrollView
{
    return self;
}

-(UIView *)viewForZooming
{
    return imageView;
}

-(void)onDoubleTap:(UIGestureRecognizer *)gesture
{
    if ([self.m_delegate respondsToSelector:@selector(onDoubleTap:)])
    {
        [self.m_delegate onDoubleTap:gesture];
    }
}



@end
