//
//  UIView+threadHook.m
//  BloomBeauty
//
//  Created by EEKA on 16/6/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "UIView+threadHook.h"

static inline void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIView (threadHook)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL needsLayoutOriginalSelector = @selector(setNeedsLayout);
        SEL needsLayoutSwizzleSelector  = @selector(guard_setNeedsLayout);
        swizzling_exchangeMethod(self, needsLayoutOriginalSelector,needsLayoutSwizzleSelector);
        
        SEL needsDisplaOriginalSelector = @selector(setNeedsDisplay);
        SEL needsDisplaSwizzleSelector  = @selector(guard_setNeedsDisplay);
        swizzling_exchangeMethod(self, needsDisplaOriginalSelector,needsDisplaSwizzleSelector);
        
        SEL needsDisplayInRectOriginalSelector = @selector(setNeedsDisplayInRect:);
        SEL needsDisplayInRectSwizzleSelector  = @selector(guard_setNeedsDisplayInRect:);
        swizzling_exchangeMethod(self, needsDisplayInRectOriginalSelector,needsDisplayInRectSwizzleSelector);
        
    });
}

#ifdef DEBUG

- (void)guard_setNeedsLayout
{
    [self UIMainThreadCheck];
    [self guard_setNeedsLayout];
}

- (void)guard_setNeedsDisplay
{
    [self UIMainThreadCheck];
    [self guard_setNeedsDisplay];
}


- (void)guard_setNeedsDisplayInRect:(CGRect)rect
{
    [self UIMainThreadCheck];
    [self guard_setNeedsDisplayInRect:rect];
}

- (void)UIMainThreadCheck
{
    NSString *desc = [NSString stringWithFormat:@"%@ UIMainThreadCheck", self.class];
    NSAssert([NSThread isMainThread], desc);
}

#else

- (void)guard_setNeedsLayout
{
    dispatch_main_async_safe(^{
        [self guard_setNeedsLayout];
    });
}

- (void)guard_setNeedsDisplay
{
    dispatch_main_async_safe(^{
        [self guard_setNeedsDisplay];
    });
}

- (void)guard_setNeedsDisplayInRect:(CGRect)rect
{
    dispatch_main_async_safe(^{
        [self guard_setNeedsDisplayInRect:rect];
    });
}

#endif

@end
 
