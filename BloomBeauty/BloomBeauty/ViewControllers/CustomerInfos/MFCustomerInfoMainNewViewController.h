//
//  MFCustomerInfoMainNewViewController.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/13.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFViewController.h"

@interface MFCustomerInfoMiddleBtnObject : MFObject

@property (nonatomic,strong) NSString *key;
@property (nonatomic,weak) Class viewClass;
@property (nonatomic,strong) NSString *title;

+(instancetype)objectWith:(NSString *)key class:(Class)viewClass btnTitle:(NSString *)title;

@end


#pragma mark - MFCustomerInfoMainNewViewController
@interface MFCustomerInfoMainNewViewController : MFViewController

@property (strong, nonatomic) NSString *individualNo;

@end
