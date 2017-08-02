//
//  MFCustomerInfoCoverSelectView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/6.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFCustomerInfoCoverSelectViewDataSource <NSObject>

@optional
-(NSInteger)numberOfRowsWithViewKey:(NSString *)viewKey;
-(NSString *)titleWithViewKey:(NSString *)viewKey forIndex:(NSInteger)index;
-(BOOL)isSelectedWithViewKey:(NSString *)viewKey forIndex:(NSInteger)index;

@end


@protocol MFCustomerInfoCoverSelectViewDelegate <NSObject>

@optional
-(void)onClickCoverSelectBgView:(NSString *)viewKey;
-(void)onClickCancelButton:(NSString *)viewKey;
-(void)onClickDoneButton:(NSString *)viewKey;
-(void)didSelectIndexViewKey:(NSString *)viewKey forIndex:(NSInteger)index;

@end

@interface MFCustomerInfoCoverSelectView : MFUIView

@property (nonatomic,weak) id<MFCustomerInfoCoverSelectViewDataSource> m_dataSource;
@property (nonatomic,weak) id<MFCustomerInfoCoverSelectViewDelegate> m_delegate;
@property (nonatomic,strong) NSString *viewKey;

-(void)reloadContentTable;

@end
