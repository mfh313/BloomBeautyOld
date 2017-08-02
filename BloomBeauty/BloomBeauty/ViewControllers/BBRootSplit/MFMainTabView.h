//
//  MFMainTabView.h
//  BloomBeauty
//
//  Created by EEKA on 16/7/7.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFTabItemButton.h"


@protocol MFMainTabViewDataSource <NSObject>

@optional

-(NSMutableArray *)MFMainTabItems;
-(NSInteger)selectedTabItemIndex;

@end

@protocol MFMainTabViewDelegate <NSObject>

@optional
-(void)setTabItemIndex:(NSInteger)index;

-(void)onTapTabIndex:(NSInteger)index;
-(void)onTapQuitLogin;
-(void)onTapSwitchUser;

@end

@interface MFMainTabView : MFUIView

@property (nonatomic,weak) id<MFMainTabViewDelegate> delegate;
@property (nonatomic,weak) id<MFMainTabViewDataSource> dataSource;

-(void)setGuideName:(NSString *)guideName;
-(void)layoutTabContentViewSubview;

@end
