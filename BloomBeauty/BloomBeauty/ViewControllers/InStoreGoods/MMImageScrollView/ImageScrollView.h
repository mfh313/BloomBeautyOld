//
//  ImageScrollView.h
//  Spring
//
//  Created by EEKA on 16/3/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMImageScrollViewHelper.h"

@protocol ImageScrollViewDelegate <NSObject>

@optional
- (void)OnLongPressBegin:(id)arg1;
- (void)OnLongPress:(id)arg1;
- (void)onDoubleTap:(UIGestureRecognizer *)arg1;
- (void)onSingleTap:(UIGestureRecognizer *)arg1;
@end

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate,MMImageScrollViewHelperDelegate>
{
    UIImageView *imageView;
    MMImageScrollViewHelper *m_scrollViewHelper;
    __weak id<ImageScrollViewDelegate> m_delegate;
}

@property (nonatomic,weak) id<ImageScrollViewDelegate> m_delegate;
@property (nonatomic,assign) float maximumZoomScale;
@property (nonatomic,assign) float minimumZoomScale;
@property (nonatomic,assign) float zoomScale;
@property (copy, nonatomic) NSArray *gestureRecognizers;
@property (nonatomic,assign)  CGRect frame;

- (void)displayImage:(UIImage *)image withFrame:(CGRect)imageFrame;

@end
