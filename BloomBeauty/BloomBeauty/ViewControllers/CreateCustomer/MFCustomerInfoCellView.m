//
//  MFCustomerInfoCellView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/5.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoCellView.h"
#import "MFCustomerInfoManager.h"
#import "MFCustomerInputTextFieldEx.h"
#import "MFCustomerCreateLogicController.h"
#import "MFRegionCitySelectView.h"
#import "MFCustomerInfoCoverSelectView.h"
#import "MFCustomerInfoDatePickView.h"
#import "MFCustomerInfoOccupationSelectView.h"

@interface MFCustomerInfoCellView ()<MFCustomerInputTextFieldExDelegate,MFRegionCitySelectViewDelegate,MFCustomerInfoCoverSelectViewDataSource,MFCustomerInfoCoverSelectViewDelegate,MFCustomerInfoDatePickViewDelegate,MFCustomerInfoOccupationSelectViewDelegate>
{
    __weak IBOutlet MFCustomerInputTextFieldEx *_infoContentView;
    MFCustomerInfoShowObject *m_object;
    BOOL _editing;
    
    MFRegionCitySelectView *_regionCitySelectView;
    MFCustomerInfoCoverSelectView *_coverSelectView;
    MFCustomerInfoDatePickView *_datePicker;
    MFCustomerInfoOccupationSelectView *_occupationSelectView;
    
    NSMutableArray *_tempSelectedKeys;
}

@end

@implementation MFCustomerInfoCellView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _infoContentView.m_delegate = self;
    _tempSelectedKeys = [NSMutableArray array];
}

-(void)setCustomerInfoShowObject:(MFCustomerInfoShowObject *)object
{
    [self setCustomerInfoShowObject:object editing:YES];
}

-(void)setCustomerInfoShowObject:(MFCustomerInfoShowObject *)object editing:(BOOL)editing
{
    m_object = object;
    _editing = editing;
    
    [_infoContentView setShowType:object.type editing:_editing canEdit:object.canEdit];
    [_infoContentView setTitle:object.showingTitle desc:object.showingContentString];
    
    if ([CommonUtil isNull:object.showingContentString]) {
        [_infoContentView setPlaceHolder:object.showingPlaceHolder hidden:!_editing];
    }
    
    if ([m_object.valueKey isEqualToString:@"birthDay"])
    {
        NSString *isLunar = m_object.valueInfo[@"isLunar"];
        NSString *yob = m_object.valueInfo[@"yob"];
        NSString *mob = m_object.valueInfo[@"mob"];
        NSString *dob = m_object.valueInfo[@"dob"];
        
        NSString *dateDesc = [MFCustomerCreateLogicController dateDescYob:yob mob:mob dob:dob];
        if (_editing) {
            [_infoContentView setBirthDayView:dateDesc IsLunar:[MFCustomerCreateLogicController isLunar:isLunar]];
        }
        else
        {
            m_object.showingContentString = [MFCustomerCreateLogicController dateDescYob:yob mob:mob dob:dob isLunar:isLunar];
            [_infoContentView setContentDesc:m_object.showingContentString];
        }
    }
    
}

-(void)onTapEditing
{
    if (!_editing || !m_object.canEdit) {
        return;
    }
        
    [_infoContentView onClickInputingShowType:m_object.type];
}

-(void)showTimePicker
{
    if (!_datePicker) {
        _datePicker = [MFCustomerInfoDatePickView viewWithNib];
        _datePicker.m_delegate = self;
    }
    _datePicker.frame = MFAppWindow.bounds;
    [MFAppWindow addSubview:_datePicker];
    
    NSString *yob = m_object.valueInfo[@"yob"];
    NSString *mob = m_object.valueInfo[@"mob"];
    NSString *dob = m_object.valueInfo[@"dob"];
    [_datePicker setDatePickerView:yob mob:mob dob:dob];
}

-(void)datePickerViewDidSelected:(NSString *)yob mob:(NSString *)mob dob:(NSString *)dob
{
    if ([m_object.valueKey isEqualToString:@"birthDay"])
    {
        [m_object.valueInfo setObject:yob forKey:@"yob"];
        [m_object.valueInfo setObject:mob forKey:@"mob"];
        [m_object.valueInfo setObject:dob forKey:@"dob"];
        
        NSString *isLunar = m_object.valueInfo[@"isLunar"];
        
        NSString *dateDesc = [MFCustomerCreateLogicController dateDescYob:yob mob:mob dob:dob];
        if (_editing) {
            [_infoContentView setBirthDayView:dateDesc IsLunar:[MFCustomerCreateLogicController isLunar:isLunar]];
        }
        else
        {
            m_object.showingContentString = [MFCustomerCreateLogicController dateDescYob:yob mob:mob dob:dob isLunar:isLunar];
            [_infoContentView setContentDesc:m_object.showingContentString];
        }
    }
}

-(void)onClickDatePickerSelectBgView
{
    [_datePicker removeFromSuperview];
}

-(void)onDidSelectIsLunar:(BOOL)isLunar
{
    if ([m_object.valueKey isEqualToString:@"birthDay"]) {
        if (isLunar) {
            [m_object.valueInfo setObject:@"Y" forKey:@"isLunar"];
        }
        else
        {
            [m_object.valueInfo setObject:@"N" forKey:@"isLunar"];
        }
    }
}

-(void)onDidSelectOccupation:(NSString *)key occupation:(NSString *)occupation
{
    if ([m_object.valueKey isEqualToString:@"occupationType"]) {
        
        m_object.showingContentString = occupation;
        m_object.valueInfo[@"occupationType"] = key;
        
        [_infoContentView setContentDesc:m_object.showingContentString];
        
        if ([CommonUtil isNull:m_object.showingContentString]) {
            [_infoContentView setPlaceHolder:m_object.showingPlaceHolder hidden:NO];
        }
    }
}

-(void)showCoverSelectView
{
    if ([m_object.valueKey isEqualToString:@"birthDay"])
    {
        [self showTimePicker];
    }
    else if ([m_object.valueKey isEqualToString:@"occupationType"]) {
        [self showOccupationSelectView];
    }
    else if ([m_object.valueKey isEqualToString:@"regionCity"])
    {
        [self showRegionCitySelectView];
    }
    else if ([m_object.valueKey isEqualToString:@"oftenEnterOccation"])
    {
        [self showCoverSelectViewWithKey:m_object.valueKey];
    }
    else if ([m_object.valueKey isEqualToString:@"oftenAccompanyPerson"])
    {
        [self showCoverSelectViewWithKey:m_object.valueKey];
    }
    else if ([m_object.valueKey isEqualToString:@"customerMentality"])
    {
        [self showCoverSelectViewWithKey:m_object.valueKey];
    }
}

-(void)showCoverSelectViewWithKey:(NSString *)viewKey
{
    if (!_coverSelectView) {
        _coverSelectView = [MFCustomerInfoCoverSelectView viewWithNib];
        _coverSelectView.m_delegate = self;
        _coverSelectView.m_dataSource = self;
    }
    
    _coverSelectView.viewKey = viewKey;
    _coverSelectView.frame = MFAppWindow.bounds;
    [MFAppWindow addSubview:_coverSelectView];
}

#pragma mark - MFCustomerInfoCoverSelectViewDataSource
-(NSInteger)numberOfRowsWithViewKey:(NSString *)viewKey
{
    if ([m_object.valueKey isEqualToString:@"oftenEnterOccation"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenEnterOccation];
        return infoDic.allKeys.count;
    }
    else if ([m_object.valueKey isEqualToString:@"oftenAccompanyPerson"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenAccompanyPerson];
        return infoDic.allKeys.count;
    }
    else if ([m_object.valueKey isEqualToString:@"customerMentality"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] customerMentality];
        return infoDic.allKeys.count;
    }
    
    return 0;
}

-(NSString *)titleWithViewKey:(NSString *)viewKey forIndex:(NSInteger)index
{
    if ([m_object.valueKey isEqualToString:@"oftenEnterOccation"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenEnterOccation];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        return infoDic[key];
    }
    else if ([m_object.valueKey isEqualToString:@"oftenAccompanyPerson"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenAccompanyPerson];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        return infoDic[key];
    }
    else if ([m_object.valueKey isEqualToString:@"customerMentality"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] customerMentality];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        return infoDic[key];
    }
    
    return nil;
}

-(BOOL)isSelectedWithViewKey:(NSString *)viewKey forIndex:(NSInteger)index
{
    if ([viewKey isEqualToString:@"oftenEnterOccation"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenEnterOccation];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];

        return [_tempSelectedKeys containsObject:key];
    }
    else if ([viewKey isEqualToString:@"oftenAccompanyPerson"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenAccompanyPerson];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        
        return [_tempSelectedKeys containsObject:key];
    }
    else if ([viewKey isEqualToString:@"customerMentality"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] customerMentality];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        
        return [_tempSelectedKeys containsObject:key];
    }
    
    return NO;
}

#pragma mark - MFCustomerInfoCoverSelectViewDelegate
-(void)didSelectIndexViewKey:(NSString *)viewKey forIndex:(NSInteger)index
{
    if ([viewKey isEqualToString:@"oftenEnterOccation"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenEnterOccation];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        
        NSInteger maxSelectCount = [MFCustomerCreateLogicController maxOftenEnterOccation];
        
        if ([_tempSelectedKeys containsObject:key]) {
            [_tempSelectedKeys removeObject:key];
        }
        else if (_tempSelectedKeys.count < maxSelectCount)
        {
            [_tempSelectedKeys addObject:key];
        }
        else if (_tempSelectedKeys.count == maxSelectCount)
        {
            NSString *tips = [NSString stringWithFormat:@"最多允许选择%@项",@(maxSelectCount)];
            NSLog(@"%@",tips);
        }
        
    }
    else if ([viewKey isEqualToString:@"oftenAccompanyPerson"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenAccompanyPerson];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        
        if ([_tempSelectedKeys containsObject:key]) {
            [_tempSelectedKeys removeObject:key];
        }
        else
        {
            [_tempSelectedKeys addObject:key];
        }
    }
    else if ([viewKey isEqualToString:@"customerMentality"])
    {
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] customerMentality];
        NSArray *keys = infoDic.allKeys;
        NSString *key = keys[index];
        
        if ([_tempSelectedKeys containsObject:key]) {
            [_tempSelectedKeys removeAllObjects];
        }
        else
        {
            [_tempSelectedKeys removeAllObjects];
            [_tempSelectedKeys addObject:key];
        }
    }
    
    [_coverSelectView reloadContentTable];
}

-(void)onClickCoverSelectBgView:(NSString *)viewKey
{
    [_coverSelectView removeFromSuperview];
    if ([CommonUtil isNull:m_object.showingContentString]) {
        [_infoContentView setPlaceHolder:m_object.showingPlaceHolder hidden:NO];
    }
}

-(void)onClickCancelButton:(NSString *)viewKey
{
    [_coverSelectView removeFromSuperview];
    if ([CommonUtil isNull:m_object.showingContentString]) {
        [_infoContentView setPlaceHolder:m_object.showingPlaceHolder hidden:NO];
    }
}

-(void)onClickDoneButton:(NSString *)viewKey
{
    [_coverSelectView removeFromSuperview];
    
    if ([viewKey isEqualToString:@"oftenEnterOccation"])
    {
        NSString *valueString = [_tempSelectedKeys componentsJoinedByString:@","];
        m_object.valueInfo[@"oftenEnterOccation"] = valueString;
        
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenEnterOccation];
        m_object.showingContentString = [self showingContentString:infoDic view:viewKey];
        
    }
    else if ([viewKey isEqualToString:@"oftenAccompanyPerson"])
    {
        NSString *valueString = [_tempSelectedKeys componentsJoinedByString:@","];
        m_object.valueInfo[@"oftenAccompanyPerson"] = valueString;
        
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] oftenAccompanyPerson];
        m_object.showingContentString = [self showingContentString:infoDic view:viewKey];
    }
    else if ([viewKey isEqualToString:@"customerMentality"])
    {
        NSString *valueString = [_tempSelectedKeys componentsJoinedByString:@","];
        m_object.valueInfo[@"customerMentality"] = valueString;
        
        NSMutableDictionary *infoDic = [[MFCustomerInfoManager sharedManager] customerMentality];
        m_object.showingContentString = [self showingContentString:infoDic view:viewKey];
    }
    
    [_infoContentView setContentDesc:m_object.showingContentString];
}

-(NSString *)showingContentString:(NSMutableDictionary *)infoDic view:(NSString *)viewKey
{
    NSMutableArray *stringArray = [NSMutableArray array];
    for (int i = 0; i < _tempSelectedKeys.count; i++) {
        NSString *key = _tempSelectedKeys[i];
        [stringArray addObject:infoDic[key]];
    }
    
    NSString *string = [stringArray componentsJoinedByString:@","];
    
    if (!string || [string isEqualToString:@""])
    {
        if ([viewKey isEqualToString:@"oftenEnterOccation"]) {
            string = [[MFCustomerInfoManager sharedManager] oftenEnterOccationDescForkey:nil];
        }
        else if ([viewKey isEqualToString:@"oftenAccompanyPerson"])
        {
            string = [[MFCustomerInfoManager sharedManager] oftenAccompanyPersonDescForkey:nil];;
        }
        else if ([viewKey isEqualToString:@"customerMentality"])
        {
            string = [[MFCustomerInfoManager sharedManager] customerMentalityDescForkey:nil];
        }
    }
    
    return string;
}

-(void)onKeyBoardWillShow:(NSNumber *)duration curve:(NSNumber *)curve needOffet:(CGFloat)yOffest
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    
    CGFloat currentOffset = self.superScrollView.contentOffset.y;
    [self.superScrollView setContentOffset:CGPointMake(0, currentOffset - yOffest + 20) animated:NO];
    
    [UIView commitAnimations];
}

-(void)onKeyBoardWillHide:(NSNumber *)duration curve:(NSNumber *)curve keyboardEndFrame:(CGRect)keyboardEndFrame
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    [self.superScrollView setContentOffset:CGPointZero animated:NO];
    
    [UIView commitAnimations];
}

-(void)showRegionCitySelectView
{
    if (![m_object.valueKey isEqualToString:@"regionCity"])
    {
        return;
    }
    
    if (!_regionCitySelectView) {
        _regionCitySelectView = [MFRegionCitySelectView viewWithNib];
        _regionCitySelectView.m_delegate = self;
    }
    _regionCitySelectView.frame = MFAppWindow.bounds;
    
    [MFAppWindow addSubview:_regionCitySelectView];
    
    NSString *regionCode = m_object.valueInfo[@"regionCode"];
    NSString *cityCode = m_object.valueInfo[@"cityCode"];
    NSString *zoneCode = m_object.valueInfo[@"zoneCode"];
    
    [_regionCitySelectView setSelectViewRegionCode:regionCode cityCode:cityCode zoneCode:zoneCode];
}

-(void)onClickSelectRegionCity
{
    [_regionCitySelectView removeFromSuperview];
}

-(void)onCancelSelectRegionCity
{
    [_regionCitySelectView removeFromSuperview];
    
    if ([CommonUtil isNull:m_object.showingContentString]) {
        [_infoContentView setPlaceHolder:m_object.showingPlaceHolder hidden:NO];
    }
}

-(void)onClickSelectRegionCode:(NSString *)regionCode
                      cityCode:(NSString *)cityCode
                      zoneCode:(NSString *)zoneCode
            regionCityZoneName:(NSString *)reginDesc
{
    if (![m_object.valueKey isEqualToString:@"regionCity"])
    {
        return;
    }
    
    if (regionCode) {
        m_object.valueInfo[@"regionCode"] = regionCode;
    }
    
    if (cityCode) {
        m_object.valueInfo[@"cityCode"] = cityCode;
    }
    
    if (zoneCode) {
        m_object.valueInfo[@"zoneCode"] = zoneCode;
    }
    
    m_object.showingContentString = reginDesc;
    [_infoContentView setContentDesc:m_object.showingContentString];
}

-(BOOL)textField:(MFCustomerInputTextFieldEx *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *containTextField = [textField containTextField];
    NSString *text = containTextField.text;
        
    if ([m_object.valueKey isEqualToString:@"phoneNumber"])
    {
        NSString *regex = @"^[0-9]*$"; //只能输入数字
        NSString *phoneNumberRegex = @"1[3|4|5|7|8][0-9]\\d{8}$"; //手机号码
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", regex];
        NSPredicate *phoneNumberPredicate = [NSPredicate predicateWithFormat:@"self matches %@", phoneNumberRegex];
        
        NSMutableString *resultString = [NSMutableString stringWithString:text];
        if (range.location <= resultString.length) {
            [resultString insertString:string atIndex:range.location];
        }
        
        BOOL result = [predicate evaluateWithObject:resultString];
        
        if ([phoneNumberPredicate evaluateWithObject:resultString]) {
            return YES;
        }
        
        return result;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(MFCustomerInputTextFieldEx *)textField
{
    UITextField *containTextField = [textField containTextField];
    NSString *text = containTextField.text;
    
    NSString *valueKey = m_object.valueKey;
    
    if (text && ![text isEqualToString:@""]) {
        m_object.valueInfo[valueKey] = text;
        m_object.showingContentString = text;
        [_infoContentView setContentDesc:m_object.showingContentString];
    }
    else
    {
        [m_object.valueInfo removeObjectForKey:valueKey];
        m_object.showingContentString = nil;
        [_infoContentView setContentDesc:m_object.showingContentString];
    }
    
    if ([CommonUtil isNull:m_object.showingContentString]) {
        [_infoContentView setPlaceHolder:m_object.showingPlaceHolder hidden:NO];
    }
}

-(void)showOccupationSelectView
{
    if (!_occupationSelectView) {
        _occupationSelectView = [MFCustomerInfoOccupationSelectView viewWithNib];
        _occupationSelectView.m_delegate = self;
    }
    _occupationSelectView.frame = MFAppWindow.bounds;
    [MFAppWindow addSubview:_occupationSelectView];
    
    NSString *occupation = m_object.valueInfo[@"occupationType"];
    [_occupationSelectView setSelectOccupation:occupation];
}

@end
