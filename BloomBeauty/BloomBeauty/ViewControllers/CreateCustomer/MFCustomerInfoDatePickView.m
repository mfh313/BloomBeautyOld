//
//  MFCustomerInfoDatePickView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/9.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoDatePickView.h"
#import "MFCustomerCreateLogicController.h"

@interface MFCustomerInfoDatePickView ()
{
    __weak IBOutlet UIImageView *_bgImageView;
    __weak IBOutlet UIDatePicker *_datePicker;
}

@end

@implementation MFCustomerInfoDatePickView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor hx_colorWithHexString:@"#000" alpha:0.3];
    _bgImageView.image = MFImageStretchCenter(@"round");
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.timeZone = [MFCustomerCreateLogicController timeZone];
}

-(void)setDatePickerView:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob
{
    NSDate *date = [MFCustomerCreateLogicController dateWithYob:yob mob:mob dob:dob];
    [_datePicker setDate:date animated:NO];
}

- (IBAction)onClickCoverBgView:(id)sender {
    
    if ([self.m_delegate respondsToSelector:@selector(onClickDatePickerSelectBgView)]) {
        [self.m_delegate onClickDatePickerSelectBgView];
    }
}

- (IBAction)onClickCancelBtn:(id)sender
{
    if ([self.m_delegate respondsToSelector:@selector(onClickDatePickerSelectBgView)]) {
        [self.m_delegate onClickDatePickerSelectBgView];
    }
}

- (IBAction)onClickDoneBtn:(id)sender
{
    if ([self.m_delegate respondsToSelector:@selector(onClickDatePickerSelectBgView)]) {
        [self.m_delegate onClickDatePickerSelectBgView];
    }
    
    NSDate *selectDate = _datePicker.date;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectDate];
    NSString *year = [NSString stringWithFormat:@"%2ld",(long)[components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld",(long)[components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld",(long)[components day]];
    
    if ([self.m_delegate respondsToSelector:@selector(datePickerViewDidSelected:mob:dob:)]) {
        [self.m_delegate datePickerViewDidSelected:year mob:month dob:day];
    }
}

@end
