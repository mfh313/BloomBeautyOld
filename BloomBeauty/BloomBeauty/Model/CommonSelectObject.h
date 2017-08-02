//
//  LoginUserInfo.h
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"


@interface CommonSelectObject : MFObject


@property (nonatomic,strong) NSNumber* type;//
@property (nonatomic,strong) NSString* key;//
@property (nonatomic,strong) NSString* value;//
@property (nonatomic,strong) NSString* name;//
@property (nonatomic,strong) NSDate* date;//
@property (nonatomic,assign) BOOL isSelected;//

-(id) initInfo;

-(id) initInfo:(NSString*)name value:(NSString*)value;

@end
