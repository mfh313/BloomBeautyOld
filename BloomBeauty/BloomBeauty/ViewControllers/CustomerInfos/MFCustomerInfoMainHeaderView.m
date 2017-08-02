//
//  MFCustomerInfoMainHeaderView.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/15.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFCustomerInfoMainHeaderView.h"
#import "MFCustomerInfoMainNavBarView.h"
#import "MFCustomerInfoMainHeader.h"
#import "MFCustomerInfoMainNewViewController.h"

@interface MFCustomerInfoMainHeaderView ()<MFCustomerInfoMainNavBarViewDelegate,MFCustomerInfoMainHeaderDelegate,MFSelecedButtonDelegate>
{
    __weak IBOutlet MFCustomerInfoMainNavBarView *_customerInfoNavBar;
    
    __weak IBOutlet MFCustomerInfoMainHeader *_infoHeader;
    
    __weak IBOutlet UIView *_tabButtonsView;
    
    UIView *_currentSelectedIndexView;
    NSMutableArray *_middleBtnArray;
    NSInteger _selecedIndex;
}

@end

@implementation MFCustomerInfoMainHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _customerInfoNavBar.m_delegate = self;
    _infoHeader.delegate = self;
    
    _middleBtnArray = [NSMutableArray array];
}

-(void)setNavBarTitle:(NSString *)title
{
    [_customerInfoNavBar setNavBarTitle:title];
}

-(void)setCustomerInfoEditing:(BOOL)editing
{
    [_customerInfoNavBar setDiagnosisButton:editing];
    if (editing) {
        [_customerInfoNavBar setEditButtonTitle:@"提交资料"];
    }
    else
    {
        [_customerInfoNavBar setEditButtonTitle:@"编辑资料"];
    }
}

-(void)setCustomerInfo:(CustomerInfo *)customerInfo
{
    [_infoHeader setName:[customerInfo getFullName]];
    [_infoHeader setHeadImageByUrl:customerInfo];
    
    BOOL isDiagnosis = NO;
    if ([self.m_dataSource respondsToSelector:@selector(isDiagnosis)]) {
        isDiagnosis = [self.m_dataSource isDiagnosis];
    }
    
    [_infoHeader setAnalysisStatus:isDiagnosis];
    
    [self layoutTabButtons];
}

-(void)setMiddleBtnSelectIndex:(NSInteger)index
{
    _selecedIndex = index;
    [self layoutTabButtons];
}

-(void)layoutTabButtons
{
    NSMutableArray *middleBtnObjects = nil;
    if ([self.m_dataSource respondsToSelector:@selector(middleBtnObjects)]) {
        middleBtnObjects = [self.m_dataSource middleBtnObjects];
    }
    
    [_tabButtonsView removeAllSubViews];
    [_middleBtnArray removeAllObjects];
    
    CGFloat btnWidth = 185;
    CGFloat btnHeight = 48;
    CGFloat btnVSpace = 0;
    CGFloat btnCount = middleBtnObjects.count;
    
    CGFloat MiddleBtnsWidth = btnCount * btnWidth + (btnCount - 1) * btnVSpace;
    CGFloat btnOrignX = (CGRectGetWidth(_tabButtonsView.bounds) - MiddleBtnsWidth) / 2;
    
    UIView *btnView = [UIView new];
    btnView.frame = CGRectMake(btnOrignX, 0, MiddleBtnsWidth, btnHeight);
    btnView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_tabButtonsView addSubview:btnView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_tabButtonsView.frame) - MFOnePixHeigtht, CGRectGetWidth(_tabButtonsView.frame), MFOnePixHeigtht)];
    line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    line.backgroundColor = [UIColor hx_colorWithHexString:@"e3e5e8"];
    [_tabButtonsView addSubview:line];
    
    for (int i = 0; i < btnCount; i++)
    {
        MFCustomerInfoMiddleBtnObject *middlebject = middleBtnObjects[i];
        
        CGRect btnFrame = CGRectMake(i * (btnWidth + btnVSpace), 0, btnWidth, btnHeight);
        MFSelecedButton *btn = [MFSelecedButton viewWithNibName:@"MFSelecedButton"];
        btn.touchDelegate = self;
        btn.normalTextColor = [UIColor hx_colorWithHexString:@"2d2c2c"];
        btn.selectedTextColor = BBDefaultColor;
        [btn setText:middlebject.title];
        btn.tag = i;
        btn.frame = btnFrame;
        [btn setSelected:NO];
        [btnView addSubview:btn];
        
        [_middleBtnArray addObject:btn];
    }
    
    _currentSelectedIndexView = [UIView new];
    _currentSelectedIndexView.backgroundColor = BBDefaultColor;
    [btnView addSubview:_currentSelectedIndexView];
    
    MFSelecedButton *selectedBtn = _middleBtnArray[_selecedIndex];
    [selectedBtn setSelected:YES];
    _currentSelectedIndexView.frame = CGRectMake(selectedBtn.frame.origin.x, CGRectGetHeight(btnView.frame) - 3 * MFOnePixHeigtht, CGRectGetWidth(selectedBtn.frame), 3 * MFOnePixHeigtht);
}

-(void)OnTouchDown:(MFSelecedButton *)btn
{
    _selecedIndex = btn.tag;
    [self setSelectedBtn:_selecedIndex];
    
    NSMutableArray *middleBtnObjects = nil;
    if ([self.m_dataSource respondsToSelector:@selector(middleBtnObjects)]) {
        middleBtnObjects = [self.m_dataSource middleBtnObjects];
    }
    
    MFCustomerInfoMiddleBtnObject *object = middleBtnObjects[_selecedIndex];
    if ([self.m_delegate respondsToSelector:@selector(didClickMiddleButton:index:)]) {
        [self.m_delegate didClickMiddleButton:object.key index:_selecedIndex];
    }
}

-(void)setSelectedBtn:(NSInteger)index
{
    [_middleBtnArray enumerateObjectsUsingBlock:^(MFSelecedButton *obj, NSUInteger idx, BOOL * stop) {
        if (obj.tag == index)
        {
            [obj setSelected:YES];
        }
        else
        {
            [obj setSelected:NO];
        }
    }];
    
    CGRect currentSelectedFrame = _currentSelectedIndexView.frame;
    MFSelecedButton *selectedBtn = _middleBtnArray[index];
    [selectedBtn setSelected:YES];
    currentSelectedFrame.origin.x = selectedBtn.frame.origin.x;
    _currentSelectedIndexView.frame = currentSelectedFrame;
}

-(CGRect)imagePickerSourceRectToView:(UIView *)view
{
    return [_infoHeader convertRect:_infoHeader.headImageView.frame toView:view];
}

-(void)setHeaderImage:(UIImage *)image
{
    [_infoHeader setHeadImage:image];
}

-(void)onClickBackBtn
{
    if ([self.m_delegate respondsToSelector:@selector(onClickBackBtn)]) {
        [self.m_delegate onClickBackBtn];
    }
}

-(void)onClickEditCustomer
{
    if ([self.m_delegate respondsToSelector:@selector(onClickEditCustomer)]) {
        [self.m_delegate onClickEditCustomer];
    }
}

-(void)onClickDiagnosticCustomer
{
    if ([self.m_delegate respondsToSelector:@selector(onClickDiagnosticCustomer)]) {
        [self.m_delegate onClickDiagnosticCustomer];
    }
}

#pragma mark - MFCustomerInfoMainHeaderDelegate
-(void)OnTouchDownHeadImage
{
    if ([self.m_delegate respondsToSelector:@selector(onTouchDownHeadImage)]) {
        [self.m_delegate onTouchDownHeadImage];
    }
}

@end
