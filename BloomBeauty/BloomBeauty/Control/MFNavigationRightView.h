//
//  MFNavigationRightView.h
//  BloomBeauty
//
//  Created by Administrator on 15/11/6.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "LoginUserInfo.h"
#import "CustomerInfo.h"
@interface MFNavigationRightView : MFUIButton

-(void)setHeadImage:(UIImage *)image name:(NSString *)name;

-(void)setHeadImageByUrl:(CustomerInfo *)customerInfo;

-(CGRect)headImageFrame;
-(void)setHeadImageHidden:(BOOL)hidden;

@end
