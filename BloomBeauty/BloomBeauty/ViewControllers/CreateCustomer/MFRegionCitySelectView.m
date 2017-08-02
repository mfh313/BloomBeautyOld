//
//  MFRegionCitySelectView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/12/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFRegionCitySelectView.h"
#import "MFCustomerInfoManager.h"

@interface MFRegionCitySelectView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak IBOutlet UIPickerView *_regionPickView;
    __weak IBOutlet UIImageView *_bgImageView;
    
    NSMutableArray *_regionArray;
    
    NSInteger _regionSelectIndex;
    NSInteger _citySelectIndex;
    NSInteger _zoneSelectIndex;
    
}

@end

@implementation MFRegionCitySelectView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _bgImageView.image = MFImageStretchCenter(@"round");
    self.backgroundColor = [UIColor hx_colorWithHexString:@"#000" alpha:0.3];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self setupEvents];
    
    [[MFCustomerInfoManager sharedManager] getRegions:^(NSMutableArray *regionArray) {
        if (regionArray.count == 0) {
            return;
        }
        
        _regionArray = regionArray;
        [self intDefaultRegionIndex];
        
    }];
}

-(void)intDefaultRegionIndex
{
    NSString *defaultRegionCode =[MFLoginCenter sharedCenter].loginInfo.regionCode;
    NSString *defaultCityCode =[MFLoginCenter sharedCenter].loginInfo.cityCode;
    NSString *defaultZoneCode =[MFLoginCenter sharedCenter].loginInfo.zoneCode;
    
    [self setSelectViewRegionCode:defaultRegionCode cityCode:defaultCityCode zoneCode:defaultZoneCode];
}

- (void)setupEvents
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (IBAction)onClickCancelButton:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onCancelSelectRegionCity)]) {
        [self.m_delegate onCancelSelectRegionCity];
    }
}

- (IBAction)onClickDoneButton:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickSelectRegionCity)]) {
        [self.m_delegate onClickSelectRegionCity];
    }
    [self onDidSelectedRegion];
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
    if ([self.m_delegate respondsToSelector:@selector(onCancelSelectRegionCity)]) {
        [self.m_delegate onCancelSelectRegionCity];
    }
}

-(void)onDidSelectedRegion
{
    NSString *regionCode = nil;
    NSString *cityCode = nil;
    NSString *zoneCode = nil;
    NSString *regionName = nil;
    NSString *cityName = nil;
    NSString *zoneName = nil;
    NSString *regionCityZoneName = nil;
    
    if (_regionSelectIndex < _regionArray.count) {
        MFCustomerRegionDataItem *regionDataItem = _regionArray[_regionSelectIndex];
        regionCode = regionDataItem.regionCode;
        regionName = regionDataItem.regionName;
        
        if (_citySelectIndex < regionDataItem.cityInfoArray.count) {
            MFCustomerCityDataItem *cityDataItem = regionDataItem.cityInfoArray[_citySelectIndex];
            cityCode = cityDataItem.cityCode;
            cityName = cityDataItem.cityName;
            
            if (_zoneSelectIndex < cityDataItem.zoneInfoArray.count) {
                MFCustomerZoneDataItem *zoneDataItem = cityDataItem.zoneInfoArray[_zoneSelectIndex];
                zoneCode = zoneDataItem.zoneCode;
                zoneName = zoneDataItem.zoneName;
            }
            
        }
        
    }
    
    if (regionName) {
        regionCityZoneName = regionName;
        if (cityName) {
            regionCityZoneName = [regionCityZoneName stringByAppendingString:cityName];
            if (zoneName) {
                regionCityZoneName = [regionCityZoneName stringByAppendingString:zoneName];
            }
        }
    }
    
    if ([self.m_delegate respondsToSelector:@selector(onClickSelectRegionCode:cityCode:zoneCode:regionCityZoneName:)]) {
        [self.m_delegate onClickSelectRegionCode:regionCode
                                        cityCode:cityCode
                                        zoneCode:zoneCode
                              regionCityZoneName:regionCityZoneName];
    }
}

-(void)setSelectViewRegionCode:(NSString *)regionCode
                      cityCode:(NSString *)cityCode
                      zoneCode:(NSString *)zoneCode
{
    for (int i = 0; i < _regionArray.count; i++) {
        MFCustomerRegionDataItem *regionDataItem = _regionArray[i];
        if ([regionCode isEqualToString:regionDataItem.regionCode]) {
            _regionSelectIndex = i;
            
            for (int j = 0; j < regionDataItem.cityInfoArray.count; j++) {
                MFCustomerCityDataItem *cityDataItem = regionDataItem.cityInfoArray[j];
                if ([cityCode isEqualToString:cityDataItem.cityCode]) {
                    _citySelectIndex = j;
                    
                    for (int z = 0; z < cityDataItem.zoneInfoArray.count; z++) {
                        MFCustomerZoneDataItem *zoneDataItem = cityDataItem.zoneInfoArray[z];
                        if ([zoneCode isEqualToString:zoneDataItem.zoneCode]) {
                            _zoneSelectIndex = z;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    [_regionPickView reloadAllComponents];
    [_regionPickView selectRow:_regionSelectIndex inComponent:0 animated:NO];
    [_regionPickView selectRow:_citySelectIndex inComponent:1 animated:NO];
    [_regionPickView selectRow:_zoneSelectIndex inComponent:2 animated:NO];
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return (CGRectGetWidth(pickerView.bounds)) / 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _regionArray.count;
    }
    else if (component == 1) {
        
        MFCustomerRegionDataItem *regionData = _regionArray[_regionSelectIndex];
        return regionData.cityInfoArray.count;
    }
    else if (component == 2) {
        MFCustomerRegionDataItem *regionData = _regionArray[_regionSelectIndex];
        if (regionData.cityInfoArray > 0) {
            MFCustomerCityDataItem *cityData = regionData.cityInfoArray[_citySelectIndex];
            return cityData.zoneInfoArray.count;
        }
        
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    if (view == nil) {
        CGFloat width = [self pickerView:pickerView widthForComponent:component];
        CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
        
        return label;
    }
    
    return view;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    
    if (component == 0) {
        MFCustomerRegionDataItem *regionData = _regionArray[row];
        title = regionData.regionName;
    }
    else if (component == 1) {
        MFCustomerRegionDataItem *regionData = _regionArray[_regionSelectIndex];
        if (regionData.cityInfoArray > 0) {
            MFCustomerCityDataItem *cityData = regionData.cityInfoArray[row];
            title = cityData.cityName;
        }
        
    }
    else if (component == 2) {
        MFCustomerRegionDataItem *regionData = _regionArray[_regionSelectIndex];
        if (regionData.cityInfoArray > 0) {
            MFCustomerCityDataItem *cityData = regionData.cityInfoArray[_citySelectIndex];
            
            MFCustomerZoneDataItem *zoneData = cityData.zoneInfoArray[row];
            title = zoneData.zoneName;
        }
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title];
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, attString.string.length)];
    CFRelease(fontRef);
    
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _regionSelectIndex = row;
        _citySelectIndex = 0;
        _zoneSelectIndex = 0;
        
        [pickerView reloadAllComponents];
        
        [pickerView selectRow:_citySelectIndex inComponent:1 animated:NO];
        [pickerView selectRow:_zoneSelectIndex inComponent:2 animated:NO];
    }
    else if (component == 1) {
        _citySelectIndex = row;
        _zoneSelectIndex = 0;
        
        [pickerView reloadAllComponents];
        
        [pickerView selectRow:_zoneSelectIndex inComponent:2 animated:NO];
        
    }
    else if (component == 2) {
        _zoneSelectIndex = row;
    }
}

@end
