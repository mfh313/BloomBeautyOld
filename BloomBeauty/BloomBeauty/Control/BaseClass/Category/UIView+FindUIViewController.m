#import "UIView+FindUIViewController.h"

@implementation UIView (FindUIViewController)

- (UIViewController *)firstAvailableUIViewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    }
    
    // If the view controller isn't found, return nil.
    return nil;
}


- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end
