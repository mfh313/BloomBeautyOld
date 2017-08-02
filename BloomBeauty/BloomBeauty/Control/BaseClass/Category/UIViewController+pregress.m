//
//  UIViewController+pregress.m 

#import "UIViewController+pregress.h"
#import "MBProgressHUD.h"

@implementation UIViewController (pregress)
- (void)showStatusInNavBarWithText:(NSString *)status
{
//    [self hiddenStatusInNavBar];
//    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(35, 7, 30, 30)];
//    activity.tag = ViewTagAction;
//    [activity startAnimating];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, 50, 21)];
//    label.tag =ViewTagLable;
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.text = status;
//    label.font = [UIFont systemFontOfSize:11];
//    [self.navigationController.navigationBar addSubview:activity];
//    [self.navigationController.navigationBar addSubview:label];
    
}

- (void)hiddenStatusInNavBar
{
//    for (UIView *view in self.navigationController.navigationBar.subviews)
//    {
//        if (view.tag == ViewTagLable || view.tag == ViewTagAction)
//        {
//            [view removeFromSuperview];
//        }
//    }
}

- (void)hideStausInNavBarWithText:(NSString *) status afterDelay:(NSTimeInterval)delay
{
    [self hiddenStatusInNavBar];
    [self showStatusInNavBarWithText:status];
	[self performSelector:@selector(hiddenStatusInNavBar) withObject:NULL afterDelay:delay];
}

- (void)showShadeView;
{
    [self hiddenShadeView];
    UIView *_shadeView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadeView.backgroundColor=[UIColor blackColor];
    _shadeView.alpha = 0.7;
    _shadeView.tag = ViewTagShade;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_shadeView];
}

- (void)hiddenShadeView
{
    for (UIView* view in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ( view.tag == ViewTagShade)
        {
            [view removeFromSuperview];
            break;
        }
    }

}

static int MBprogressIN=0;
-(void)showMBStatusInViewController:(NSString *)status withDuration:(NSTimeInterval)delay
{
    [self hiddenMBStatus];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.tag=ViewTagMBProgress;
//    hud.mode = MBProgressHUDModeText;
    hud.labelText = status;
    [hud show:YES];
    if (delay == 0 )
    {
        delay =2;//默认为两秒
    }
    MBprogressIN = InViewController;
    [self performSelector:@selector(hiddenMBStatusInViewController) withObject:NULL afterDelay:delay];
}
- (void)hiddenMBStatusInViewController
{
    for (UIView *view in self.view.subviews)
    {
        if (view.tag == ViewTagMBProgress)
        {
            [view removeFromSuperview];
            break;
        }
    }
    
}
- (void)hiddenMBStatus
{
    if (MBprogressIN == InViewController)
    {
        [self hiddenMBStatusInViewController];
    }
    else
    {
        [self hiddenMBStatusInWindow];
    }
}

- (void)showMBStatusInWindow:(NSString *)status withDuration:(NSTimeInterval)delay
{
    [self hiddenMBStatus];

    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];

    hud.tag=ViewTagMBProgress;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = status;
    [hud show:YES];
    if (delay == 0 )
    {
        delay =2; 
    }
    MBprogressIN = InWindow;
    [self performSelector:@selector(hiddenMBStatusInWindow) withObject:NULL afterDelay:delay];

}




//
- (void)hiddenMBTipByWindow:(UIWindow *)window
{
    if(window != nil)
    {
        for (UIView *view in window.subviews)
        {
            if (view.tag == ViewTagMBProgress)
            {
                [view removeFromSuperview];
                break;
            }
        }
    }
}


- (void)hiddenMBStatusInWindow
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if (view.tag == ViewTagMBProgress)
        {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)showMBCircleInViewController
{
    [self hiddenMBStatus];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.tag = ViewTagMBProgress;
    [hud show:YES];
    MBprogressIN = InViewController;
}

- (void)showMBCircleInWindow
{
    [self hiddenMBStatus];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];

    hud.tag = ViewTagMBProgress;
    [hud show:YES];
    MBprogressIN = InWindow;
}

- (void)showMBStatusInViewController:(NSString *)status
{
    [self hiddenMBStatus];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.tag = ViewTagMBProgress;
    //hud.mode = MBProgressHUDModeText;
    hud.labelText = status;
    [hud show:YES];
    MBprogressIN = InViewController;
}

- (void)showError:(int)resultCode
{
    
    switch (resultCode)
    {
        case 404:
            [self showMBStatusInViewController:@"common_connect_error" withDuration:1];
            break;
            
        default:
            [self showMBStatusInViewController:[NSString stringWithFormat:@"fail %d",resultCode] withDuration:1];
            break;
    }
}
//自定义方法
- (void)showTips:(NSString *)status
{
    [self showMBStatusInWindow:status withDuration:MB_STATUS_SHOW_DURATION_SHORT];
}

- (void)showTips:(NSString *)status withDuration:(NSTimeInterval)delay
{
    [self showMBStatusInWindow:status withDuration:delay];
}

- (void)showTipsByWindow:(NSString *)status withDuration:(NSTimeInterval)delay window:(UIWindow *)window
{
    if (MBprogressIN == InViewController)
    {
        [self hiddenMBStatusInViewController];
    }
    else
    {
        [self hiddenMBTipByWindow:window];
    }
    
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    
    hud.tag=ViewTagMBProgress;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = status;
    [hud show:YES];
    if (delay == 0 )
    {
        delay =2;
    }
    MBprogressIN = InWindow;
    [self performSelector:@selector(hiddenMBTipByWindow:) withObject:window afterDelay:delay];
}

- (void)showTipsByWindow:(NSString *)status window:(UIWindow *)window
{
    [self showTipsByWindow:status withDuration:MB_STATUS_SHOW_DURATION_SHORT window:window];
}
//显示 自动隐藏
- (void)showTipsByWindowAutoHidden:(NSString *)status window:(UIWindow *)window
{
    [self showTipsByWindowAutoHidden:status withDuration:MB_STATUS_SHOW_DURATION_SHORT window:window];
}
//显示 自动隐藏
- (void)showTipsByWindowAutoHidden:(NSString *)status withDuration:(NSTimeInterval)delay window:(UIWindow *)window
{
    [self hiddenMBStatus];
    
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    
    hud.tag=ViewTagMBProgress;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = status;
    [hud show:YES];
    if (delay == 0 )
    {
        delay =2;
    }
    MBprogressIN = InWindow;
    [self performSelector:@selector(hiddenMBTipByWindow:) withObject:window afterDelay:delay];
    
}

@end
