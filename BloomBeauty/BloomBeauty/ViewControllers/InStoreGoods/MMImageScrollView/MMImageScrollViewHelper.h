//
//  MMImageScrollViewHelper.h
//  Spring
//
//  Created by EEKA on 16/3/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MMImageScrollViewHelperDelegate <NSObject>

@optional
@property(copy, nonatomic) NSArray *gestureRecognizers;
@property(nonatomic) float maximumZoomScale;
@property(nonatomic) float minimumZoomScale;
@property(nonatomic) float zoomScale;
@property(nonatomic) CGRect frame;
- (void)zoomToRect:(CGRect)frame animated:(BOOL)animated;
- (void)setZoomScale:(float)scale animated:(BOOL)animated;
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gesture;
- (void)addGestureRecognizer:(UIGestureRecognizer *)gesture;
- (void)onDoubleTap:(UIGestureRecognizer *)gesture;
- (void)onSingleTap:(UIGestureRecognizer *)gesture;
- (UIScrollView *)getScrollView;
- (UIView *)viewForZooming;

@end

@interface MMImageScrollViewHelper : NSObject
{
    BOOL dontSupportHorizontalLongImage;
    BOOL dontSupportVerticalLongImage;
    BOOL noDoubleTaps;
    BOOL noSingleTaps;
    BOOL dontCalcPreviewRect;
    __weak id<MMImageScrollViewHelperDelegate> m_delegate;
}

@property (nonatomic,weak) id<MMImageScrollViewHelperDelegate> m_delegate;
@property (nonatomic,assign) BOOL dontSupportHorizontalLongImage;
@property (nonatomic,assign) BOOL dontSupportVerticalLongImage;
@property (nonatomic,assign) BOOL noDoubleTaps;
@property (nonatomic,assign) BOOL noSingleTaps;
@property (nonatomic,assign) BOOL dontCalcPreviewRect;

- (void)scrollViewDidZoom:(UIScrollView *)scrollView;
- (void)ZoomForPoint:(struct CGPoint)arg1;
- (void)onDoubleTap:(UITapGestureRecognizer *)gestureRecognizer;
- (CGRect)zoomRectForScale:(float)arg1 withCenter:(struct CGPoint)arg2;
- (void)onSingleTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)initHelper:(struct CGSize)arg1 orientation:(int)arg2;
- (void)initHelper:(struct CGSize)arg1 orientation:(int)arg2 containSize:(struct CGSize)arg3;
- (void)initHelper:(struct CGSize)arg1;
- (CGSize)calculateImageFitSizeForPreview:(CGSize)imageSize maxSize:(CGSize)maxSize;
- (void)InitGestureRecognizer;
- (id)init;

@end


