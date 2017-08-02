//
//  MFCustomerInfoOccupationSelectView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/6.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"


@protocol MFCustomerInfoOccupationSelectViewDelegate <NSObject>

@optional
-(void)onDidSelectOccupation:(NSString *)key occupation:(NSString *)occupation;

@end

@interface MFCustomerInfoOccupationSelectView : MFUIView

@property (nonatomic,weak) id<MFCustomerInfoOccupationSelectViewDelegate> m_delegate;

-(void)setSelectOccupation:(NSString *)key;

@end
