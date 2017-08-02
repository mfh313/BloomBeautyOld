//
//  MFCustomerBodyMadeUnderwearItemView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeUnderwearItemView.h"
#import "MFCustomerBodyMadeUnderwearItemInputView.h"
#import "MFCustomerBodyMadeUnderwearItemResultView.h"
#import "MFCustomerBodyMadeModel.h"

@interface MFCustomerBodyMadeUnderwearItemView ()
{
    MFCustomerBodyMadeUnderwearItemInputView *_inputView;
    MFCustomerBodyMadeUnderwearItemResultView *_resultView;
}

@end

@implementation MFCustomerBodyMadeUnderwearItemView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _inputView = [[MFCustomerBodyMadeUnderwearItemInputView alloc] initWithFrame:CGRectZero];
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _inputView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_inputView];
        
        _resultView = [[MFCustomerBodyMadeUnderwearItemResultView alloc] initWithFrame:CGRectZero];
        _resultView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_resultView];
        
        [_inputView setHidden:YES];
        [_resultView setHidden:YES];
        
    }
    
    return self;
}

-(void)setUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel editing:(BOOL)editing
{
    [_inputView setHidden:YES];
    [_resultView setHidden:YES];
    if (editing) {
        [_inputView setHidden:NO];
        
        _inputView.frame = self.bounds;
        [_inputView setBodyMadeUnderWearModel:underWearModel];
    }
    else
    {
        [_resultView setHidden:NO];
        
        CGSize resultSize = [MFCustomerBodyMadeUnderwearItemResultView contentSize:underWearModel availableWidth:CGRectGetWidth(self.bounds)];
        _resultView.frame = CGRectMake(0, 0, resultSize.width, resultSize.height);
        [_resultView setUnderWearModel:underWearModel];
    }

    
}

+(CGSize)sizeForUnderWearModel:(MFCustomerBodyMadeUnderWearModel *)underWearModel availableWidth:(CGFloat)availableWidth editing:(BOOL)editing
{
    if (editing)
    {
        return [MFCustomerBodyMadeUnderwearItemInputView cellSizeForBodyMadeUnderWearModel:underWearModel availableWidth:availableWidth];
    }
    
    CGSize resultSize = [MFCustomerBodyMadeUnderwearItemResultView contentSize:underWearModel availableWidth:availableWidth];
    
    return CGSizeMake(resultSize.width, resultSize.height + 5);
}

@end
