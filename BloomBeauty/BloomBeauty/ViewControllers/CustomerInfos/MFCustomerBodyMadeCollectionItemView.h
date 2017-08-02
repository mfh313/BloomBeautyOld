//
//  MFCustomerBodyMadeCollectionItemView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/11/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFCustomerBodyMadeModel;

@protocol MFCustomerBodyMadeCollectionItemViewDelegate <NSObject>

@optional
-(void)onClickInputBodyMade:(MFCustomerBodyMadeModel *)bodyMadeItem;
-(void)onFinishEndEditingBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem string:(NSString *)value;

@end


@interface MFCustomerBodyMadeCollectionItemView : MFUIView
@property (nonatomic,weak) id<MFCustomerBodyMadeCollectionItemViewDelegate> m_delegate;
@property (nonatomic,weak) UIScrollView *superScrollView;

-(void)setBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem editing:(BOOL)editing;
+(CGSize)sizeForBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem;

@end
