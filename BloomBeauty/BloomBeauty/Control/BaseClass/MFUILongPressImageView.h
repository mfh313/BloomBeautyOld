//
//  MFUILongPressImageView.h
//  BloomBeauty
//
//  Created by Administrator on 15/11/5.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIImageView.h"


@class MFUILongPressImageView;
@protocol MFLongPressImageViewDelegate <NSObject>

@optional
- (void)OnTouchUp:(MFUILongPressImageView*)imgView;
- (void)OnTouchDown:(MFUILongPressImageView*)imgView;
- (void)OnLongPress:(MFUILongPressImageView*)imgView;
- (void)OnPress:(MFUILongPressImageView*)imgView;
@end

@interface MFUILongPressImageView : MFUIImageView
{
    BOOL m_bIsLongPressHandled;
    UILongPressGestureRecognizer *_longGesture;
    float m_fLongPressTime;
    __weak id<MFLongPressImageViewDelegate> _delegate;
}
@property (nonatomic,weak)id<MFLongPressImageViewDelegate> delegate;
@property (nonatomic,assign) float m_fLongPressTime;

@end
