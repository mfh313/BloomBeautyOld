//
//  MFVersionWindow.m
//  装扮灵
//
//  Created by Administrator on 15/10/18.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFVersionWindow.h"
#import "MFVersionViewController.h"

@interface MFVersionWindow ()
{
    MFVersionViewController *m_rootVC;
}

@end

@implementation MFVersionWindow

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        m_rootVC = [[MFVersionViewController alloc] init];
        [self setRootViewController:m_rootVC];
    }
    
    return self;
}

- (void)setVersion:(NSString *)string
{
    [m_rootVC setVersion:string];
}

@end
