//
//  PresentAnimation.m
//  RichTextDemo
//
//  Created by EEKA on 16/4/9.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "PresentAnimation.h"

@implementation PresentAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for toVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
//    toVC.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
//    toVC.view.frame = CGRectOffset(finalFrame, -screenBounds.size.width, screenBounds.size.height);
    toVC.view.frame = CGRectOffset(finalFrame, 0, -screenBounds.size.height);
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    CATransform3D t1 = [self firstTransform];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toVC.view.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         // 5. Tell context that we completed.
                         [transitionContext completeTransition:YES];
                     }];
    
//    [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
//        toVC.view.layer.transform = t1;
//        toVC.view.alpha = 1.0;
//    }];
}

-(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
    
}

@end
