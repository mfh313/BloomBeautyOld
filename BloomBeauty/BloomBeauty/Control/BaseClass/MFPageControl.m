//
//  MFPageControl.m
//  BloomBeauty
//
//  Created by EEKA on 1/7/16.
//  Copyright © 2016 EEKA. All rights reserved.
//

#import "MFPageControl.h"

@implementation MFPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetup];
        
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultSetup];
    }
    
    return self;
}

-(void)defaultSetup
{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setPageControlStyle:PageControlStyleThumb];
    [self setThumbImage:MFImage(@"zbl42")];
    [self setSelectedThumbImage:MFImage(@"zbl41")];
    [self setNumberOfPages:2];
}

@end
