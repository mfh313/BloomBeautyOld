//
//  MFUIButton.m
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIButton.h"


@implementation MFUIButton

+ (id)viewWithNib
{
    NSString *nibName = NSStringFromClass(self);
    return [self viewWithNibName:nibName];
}

+ (id)viewWithNibName:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    UIView *view = [nibObjects objectAtIndex:0];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
