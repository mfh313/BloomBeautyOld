//
//  MFMainTabView.m
//  BloomBeauty
//
//  Created by EEKA on 16/7/7.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFMainTabView.h"

@interface MFMainTabView ()
{
    __weak IBOutlet UILabel *_guideNameLabel;
    
    __weak IBOutlet MFTabItemButton *_quiteLoginView;
    __weak IBOutlet MFTabItemButton *_switchGuideView;
    
    __weak IBOutlet UIView *_tabContentView;
    
    NSMutableArray *_tabItemViews;
    
    
    
}

@end

@implementation MFMainTabView
@synthesize delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    _quiteLoginView.normalImage = MFImage(@"nav2a");
    _quiteLoginView.normalTitle = @"退出登录";
    _quiteLoginView.highlightTitle = @"退出登录";
    _quiteLoginView.highlightImage = MFImage(@"nav2");
    
    _switchGuideView.normalImage = MFImage(@"nav1a");
    _switchGuideView.normalTitle = @"切换导购";
    _switchGuideView.highlightTitle = @"切换导购";
    _switchGuideView.highlightImage = MFImage(@"nav1");
    
    _quiteLoginView.isTouchHighlighted = YES;
    _switchGuideView.isTouchHighlighted = YES;
    
    [_quiteLoginView addTarget:self action:@selector(onTapQuitLogin) forControlEvents:UIControlEventTouchUpInside];
    [_switchGuideView addTarget:self action:@selector(onTapSwitchUser) forControlEvents:UIControlEventTouchUpInside];
    
    _tabItemViews = [NSMutableArray array];
    
}

-(void)layoutTabContentViewSubview
{
    [_tabContentView removeAllSubViews];
    
    NSMutableArray *tabDataArray = [self.dataSource MFMainTabItems];
    
    if (tabDataArray.count == 0) {
        return;
    }
    
    NSInteger selectedTabItemIndex = [self.dataSource selectedTabItemIndex];
    
    [_tabItemViews removeAllObjects];
    
    NSInteger itemVSpace = 25;
    NSInteger itemWidth = 78;
    NSInteger itemHeight = 65;
    NSInteger viewsHeight = itemHeight * tabDataArray.count + (tabDataArray.count - 1) * itemVSpace;
    NSInteger itemOrignY = (CGRectGetHeight(_tabContentView.frame) - viewsHeight) / 2;
    
    for (int i = 0; i < tabDataArray.count; i++) {
        
        MFTabItemButton *itemView = [MFTabItemButton viewWithNib];
        itemView.frame = CGRectMake(0, itemOrignY, itemWidth, itemHeight);
        [_tabContentView addSubview:itemView];
        
        [_tabItemViews addObject:itemView];
        
        MFTabItemDataItem *dataItem = tabDataArray[i];
        itemView.normalImage = dataItem.normalImage;
        itemView.normalTitle = dataItem.normalTitle;
        itemView.highlightTitle = dataItem.highlightTitle;
        itemView.highlightImage = dataItem.highlightImage;
        [itemView addTarget:self action:@selector(onClickTabButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (selectedTabItemIndex == i) {
            [itemView setSelected:YES];
        }
        else
        {
            [itemView setSelected:NO];
        }
        
        itemOrignY = itemOrignY + itemHeight + itemVSpace;
    }
}

-(void)layoutSubviews
{
    [self layoutIfNeeded];
    [self layoutTabContentViewSubview];
}

-(void)onClickTabButton:(UIButton *)btn
{
    NSInteger selectedIndex = [_tabItemViews indexOfObject:btn];
    
    if ([self.delegate respondsToSelector:@selector(setTabItemIndex:)]) {
        [self.delegate setTabItemIndex:selectedIndex];
    }
    
    if ([self.delegate respondsToSelector:@selector(onTapTabIndex:)]) {
        [self.delegate onTapTabIndex:selectedIndex];
    }
    
    for (int i = 0; i < _tabItemViews.count; i++) {
        MFTabItemButton *itemView = _tabItemViews[i];
        [itemView setSelected:NO];
        if (selectedIndex == i) {
            [itemView setSelected:YES];
        }
    }
    
}

-(void)setGuideName:(NSString *)guideName
{
    _guideNameLabel.text = guideName;
}

-(void)onTapQuitLogin
{
    if ([self.delegate respondsToSelector:@selector(onTapQuitLogin)]) {
        [self.delegate onTapQuitLogin];
    }
}

-(void)onTapSwitchUser
{
    if ([self.delegate respondsToSelector:@selector(onTapSwitchUser)]) {
        [self.delegate onTapSwitchUser];
    }
}


@end
