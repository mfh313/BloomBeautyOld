
#import "MFSysInit.h"


@implementation MFSysInit


+ (void)initUIAppearance
{
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
    {
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    }
    
    [[UINavigationBar appearance] setBackgroundImage:MFImageStretchCenter(@"zbl40") forBarMetrics:UIBarMetricsDefault];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 20);
    UIImage *backArrowImage = [MFImage(@"Back") imageWithAlignmentRectInsets:insets];
    
    [[UINavigationBar appearance] setBackIndicatorImage:backArrowImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backArrowImage];
        
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTintColor:BBDefaultColor];
    [[UITextView appearance] setTintColor:BBDefaultColor];
    [[UITextField appearance] setTintColor:BBDefaultColor];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor clearColor];
    NSDictionary *textAttributes = @{NSShadowAttributeName: shadow,NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    [[UISwitch appearance] setOnTintColor:BBDefaultColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
@end
