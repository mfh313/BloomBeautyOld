//
//  LoginUserInfo.h
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"

@interface CustomerFavorite : MFObject

@property NSInteger ID;//	自增id
@property (nonatomic,strong) NSString* individualNo;//	 顾客编号
@property (nonatomic,strong) NSString* favoriteCommodity;//

@end
