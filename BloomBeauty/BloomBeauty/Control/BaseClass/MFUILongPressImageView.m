//
//  MFUILongPressImageView.m
//  BloomBeauty
//
//  Created by Administrator on 15/11/5.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUILongPressImageView.h"

@implementation MFUILongPressImageView
@synthesize delegate;
@synthesize m_fLongPressTime;


-(void)commonInit
{
    m_bIsLongPressHandled = NO;
    m_fLongPressTime = 1.0;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self addGestureRecognizer:tapGes];
    [self LongPressEvents];
}

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)setM_fLongPressTime:(float)pressTime
{
    m_fLongPressTime = pressTime;
    _longGesture.minimumPressDuration = m_fLongPressTime;
}

- (void)LongPressEvents
{
    _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longGesture.minimumPressDuration = m_fLongPressTime;
    [self addGestureRecognizer:_longGesture];
}

- (void)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(OnPress:)])
    {
        [self.delegate OnPress:self];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.delegate respondsToSelector:@selector(OnLongPress:)])
        {
            m_bIsLongPressHandled = YES;
            [self.delegate OnLongPress:self];
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (m_bIsLongPressHandled)
        {
            if ([self.delegate respondsToSelector:@selector(OnTouchUp:)]) {
                [self.delegate OnTouchUp:self];
            }
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(OnTouchDown:)])
    {
        [self.delegate OnTouchDown:self];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(OnTouchUp:)]) {
        [self.delegate OnTouchUp:self];
    }
}



@end
