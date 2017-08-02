//
//  MFCustomerInfoMainHeader.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/11.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"


@protocol MFCustomerInfoMainHeaderDelegate <NSObject>

@optional
-(void)OnTouchDownHeadImage;

@end

@interface MFCustomerInfoMainHeader : MFUIView

@property (nonatomic,weak) id<MFCustomerInfoMainHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet MFUILongPressImageView *headImageView;


-(void)setHeadImage:(UIImage *)image;
-(void)setHeadImageByUrl:(CustomerInfo *)customerInfo;
-(void)setName:(NSString *)name;
-(void)setAnalysisStatus:(BOOL)analysisStatus;

@end
