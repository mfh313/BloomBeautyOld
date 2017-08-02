//
//  MFDiagnosisHistoryCellView.m
//  BloomBeauty
//
//  Created by EEKA on 16/4/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFDiagnosisHistoryCellView.h"

@interface MFDiagnosisHistoryCellView ()
{
    
    __weak IBOutlet UILabel *_customerNameLabel;
    __weak IBOutlet UILabel *_phoneNumberLabel;
    __weak IBOutlet UILabel *_diagnosisTimeLabel;
    __weak IBOutlet UILabel *_diagnosisGuideLabel;
    __weak IBOutlet UILabel *_actionLabel;
    
    __weak IBOutlet UIView *_underLine;
    
    
    ClickActionBlock _actionBlock;
    
    NSString *_phoneNumber;
}

@end

@implementation MFDiagnosisHistoryCellView

-(void)awakeFromNib
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickActionLabel)];
    [_actionLabel addGestureRecognizer:tapGes];
    
    [_phoneNumberLabel addMF_LongPressGesture];
    [_phoneNumberLabel setMF_LongPressGestureTitles:@[@"长按复制号码保存到粘贴板"]
                                        object:self
                                      SELArray:@[NSStringFromSelector(@selector(makeTextOnPasteBorard))]];
}

-(void)makeTextOnPasteBorard
{
    [[UIPasteboard generalPasteboard] setString:_phoneNumber];
}

-(void)onClickActionLabel
{
    if (_actionBlock != NULL) {
        _actionBlock();
    }
}

-(void)setCustomerName:(NSString *)name
           phoneNumber:(NSString *)phoneNumber
         diagnosisTime:(NSString *)diagnosisTime
        diagnosisGuide:(NSString *)diagnosisGuide
           actionLabel:(NSString *)actionTitle
                action:(ClickActionBlock)actionBlock
{
    _phoneNumber = phoneNumber;
    
    _customerNameLabel.text = name;
    _phoneNumberLabel.text = phoneNumber;
    _diagnosisTimeLabel.text = diagnosisTime;
    _diagnosisGuideLabel.text = diagnosisGuide;
    _actionLabel.text = actionTitle;
    
    _actionLabel.userInteractionEnabled = NO;
    if (actionBlock != NULL) {
        _actionLabel.userInteractionEnabled = YES;
        _actionBlock = actionBlock;
    }
}

-(void)setActionLabelColor:(UIColor *)color
{
    _actionLabel.textColor = color;
}


-(void)setUnderLineHidden:(BOOL)hidden
{
    _underLine.hidden = hidden;
}

@end
