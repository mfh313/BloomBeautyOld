//
//  MFDiagnosticItemSelectView.m
//  BloomBeauty
//
//  Created by EEKA on 16/4/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFDiagnosticItemSelectView.h"

@implementation MFDiagnosticItemSelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageSelectView = [MFDiagnosticImageView viewWithNibName:@"MFDiagnosticImageView"];
        _imageSelectView.frame = self.bounds;
        _imageSelectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageSelectView];
        
        _textSelectView = [MFDiagnosticTextSelectView viewWithNibName:@"MFDiagnosticTextSelectView"];
        _textSelectView.frame = self.bounds;
        _textSelectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_textSelectView];
        
        _imageSelectView.hidden = YES;
        _textSelectView.hidden = YES;
    }
    
    return self;
}

-(void)setType:(NSString *)type
{
    _imageSelectView.hidden = YES;
    _textSelectView.hidden = YES;
    
    if ([type isEqualToString:MFDiagnosticTypeKeyString]) {
        _textSelectView.hidden = NO;
    }
    else if ([type isEqualToString:MFDiagnosticTypeKeyImage])
    {
        _imageSelectView.hidden = NO;
    }
}

-(MFDiagnosticImageView *)imageSelectView
{
    return _imageSelectView;
}

-(MFDiagnosticTextSelectView *)textSelectView
{
    return _textSelectView;
}

@end
