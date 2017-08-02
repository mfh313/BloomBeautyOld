//
//  MMImageScrollViewHelper.m
//  Spring
//
//  Created by EEKA on 16/3/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MMImageScrollViewHelper.h"

@implementation MMImageScrollViewHelper

-(id)init
{
    self = [super init];
    if (self) {
        dontSupportHorizontalLongImage = NO;
        dontSupportVerticalLongImage = NO;
        noDoubleTaps = NO;
        noSingleTaps = NO;
        dontCalcPreviewRect = NO;
    }
    
    return self;
}

- (void)InitGestureRecognizer
{
    if (!noSingleTaps) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        if ([self.m_delegate respondsToSelector:@selector(addGestureRecognizer:)]) {
            [self.m_delegate addGestureRecognizer:singleTap];
        }
    }
    
    if (!noDoubleTaps) {
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        if ([self.m_delegate respondsToSelector:@selector(addGestureRecognizer:)]) {
            [self.m_delegate addGestureRecognizer:doubleTap];
        }
    }
    
}

-(void)onSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.m_delegate respondsToSelector:@selector(onSingleTap:)])
    {
        [self.m_delegate onSingleTap:gestureRecognizer];
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.m_delegate respondsToSelector:@selector(onDoubleTap:)])
    {
        [self.m_delegate onDoubleTap:gestureRecognizer];
    }
}

- (CGSize)calculateImageFitSizeForPreview:(CGSize)imageSize maxSize:(CGSize)maxSize
{
    return imageSize;
}

@end
