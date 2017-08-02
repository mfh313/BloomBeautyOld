//
//  UIViewController+pregress.h
#import <UIKit/UIKit.h>

#define MB_STATUS_SHOW_DURATION_SHORT       1.5
#define MB_STATUS_SHOW_DURATION_NORMAL      2.0
#define MB_STATUS_SHOW_DURATION_LONG        2.8

typedef NS_ENUM(NSInteger, ViewTag)
{
    ViewTagAction=100380,
    ViewTagLable,
    ViewTagShade,
    ViewTagBlowShade,
    ViewTagMBProgress
};

typedef NS_ENUM(NSInteger, MBProgressIn)
{
    InViewController,
    InWindow
};
@interface UIViewController (pregress)
- (void)showShadeView;
- (void)hiddenShadeView;

- (void)showStatusInNavBarWithText:(NSString *)status;
- (void)hiddenStatusInNavBar;
- (void)hideStausInNavBarWithText:(NSString *) status afterDelay:(NSTimeInterval)delay;

- (void)showMBCircleInViewController;
- (void)showMBStatusInViewController:(NSString *)status;
- (void)showMBStatusInViewController:(NSString *)status withDuration:(NSTimeInterval)delay;
- (void)showMBCircleInWindow;
- (void)showMBStatusInWindow:(NSString *)status withDuration:(NSTimeInterval)delay;
- (void)hiddenMBStatus;
- (void)showError:(int)resultCode;
- (void)showTips:(NSString *)status;
- (void)showTips:(NSString *)status withDuration:(NSTimeInterval)delay;
//自定义方法
- (void)showTipsByWindow:(NSString *)status window:(UIWindow *)window;
- (void)showTipsByWindow:(NSString *)status withDuration:(NSTimeInterval)delay window:(UIWindow *)window;
- (void)showTipsByWindowAutoHidden:(NSString *)status window:(UIWindow *)window;
- (void)showTipsByWindowAutoHidden:(NSString *)status withDuration:(NSTimeInterval)delay window:(UIWindow *)window;
@end
