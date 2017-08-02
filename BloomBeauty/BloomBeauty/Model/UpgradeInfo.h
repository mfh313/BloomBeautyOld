//
//  LoginUserInfo.h
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"


@interface UpgradeInfo : MFObject

@property (nonatomic,strong) NSString *androidUrl;
@property (nonatomic,strong) NSString *iosUrl;
@property (nonatomic,strong) NSString *forcedUpgrade;
@property (nonatomic,strong) NSString *upgradeDesc;
@property (nonatomic,strong) NSString *version;

//业务处理 不是实体内容
@property  BOOL isNeedUprade;//是否需要升级
//@property (nonatomic,strong) NSString *lastVersion;
@property (nonatomic,strong) NSString *lastUrl;

@end
