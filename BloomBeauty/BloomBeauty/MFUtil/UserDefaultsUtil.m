//
//  SOXMapUtil.m
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import "UserDefaultsUtil.h"
#import "CommonUtil.h"
//#import "SOXEncryption.h"
@implementation UserDefaultsUtil


#define G_STR_YES @"1"
#define G_STR_NO @"0"

#define G_INT_YES 1
#define G_INT_NO 0
//检测当前是否 需要更新   以大为主
+ (BOOL)chkIsNeedUpdateByFloat:(NSString *)key :(float) value{
     BOOL flag = false;
    float now = value;
    float ori = 0.0f; 
    NSString *strSaveVal=[UserDefaultsUtil loadInfo:key];
    if ([CommonUtil isNotNull:strSaveVal]  ){
        ori =[strSaveVal floatValue];
    } 
    if (now > ori){
        flag = true;
    }
    return flag;
}


+ (BOOL)chkIsNeedUpdateByInt:(NSString *)key :(int) value{
    int now = value;
    int ori = 0; 
    BOOL flag = false;
    NSString *strSaveVal=[UserDefaultsUtil loadInfo:key];
    if ([CommonUtil isNotNull:strSaveVal]){
        ori =[strSaveVal intValue];
    } 
    if (now > ori){
        flag = true;
    }
    return flag;
}
+ (BOOL)chkIsNeedUpdateByDouble:(NSString *)key :(double) value{
    double now = value;
    double ori = 0;
    BOOL flag = false;
    NSString *strSaveVal=[UserDefaultsUtil loadInfo:key];
    if ([CommonUtil isNotNull:strSaveVal]){
        ori =[strSaveVal doubleValue];
    }
    if (now > ori){
        flag = true;
    }
    return flag;
}


//更新 根据 最新 最大 覆盖 返回是否更新了
+ (BOOL)updateInfoByInt:(NSString *)key :(int) value{
    bool isNeedUpdate = [UserDefaultsUtil chkIsNeedUpdateByInt:key :value];
    if(isNeedUpdate){
        NSString *strValue = [CommonUtil intToString:value];
        [UserDefaultsUtil saveInfo:key :strValue]; 
    }
    return isNeedUpdate;
}
//更新 根据 最新 最大 覆盖  返回是否更新了
+ (BOOL)updateInfoByFloat:(NSString *)key :(float) value{
    bool isNeedUpdate = [UserDefaultsUtil chkIsNeedUpdateByFloat:key :value];
    if(isNeedUpdate){ 
        NSString *strValue = [CommonUtil floatToString:value];
        [UserDefaultsUtil saveInfo:key :strValue];
    }
    return isNeedUpdate;
}
+ (BOOL)updateInfoByDouble:(NSString *)key :(double) value{
    bool isNeedUpdate = [UserDefaultsUtil chkIsNeedUpdateByDouble:key :value];
    if(isNeedUpdate){
        NSString *strValue = [CommonUtil doubleToString:value];
        [UserDefaultsUtil saveInfo:key :strValue];
    }
    return isNeedUpdate;
}

//save 用户数据
+ (void)saveInfo:(NSString *)key :(NSString *) value{
    //Save
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    //此处需要注意 设置可以为空的 情况  可能会影响之前的 保存为空代码
    if(value!=nil){// && ![value isEqualToString:@""]
//        NSData *data=  [SOXEncryption Encrypt:value];//添加加密
        [saveDefaults setObject:value forKey:key];
    }
}
//load 用户数据
+ (NSString *)loadInfo:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData  *data = [userDefaults objectForKey:key];//str
    NSString *str= @"";
    if(data!=nil){
        str= data;// [SOXEncryption Decrypt:data]; //添加解密
    } 
    return str;
}
//加载返回 int类型
+ (int)loadInfoReturnInt:(NSString *)key{  
     NSString  *str = [UserDefaultsUtil loadInfo:key];
    int val = 0;
    if([CommonUtil isNotNull:str]){
        val = [str intValue];
    }
    return val;
}
//加载返回 double类型
+ (double)loadInfoReturnDouble:(NSString *)key{
    NSString  *str = [UserDefaultsUtil loadInfo:key];
    double val = 0;
    if([CommonUtil isNotNull:str]){
        val = [str doubleValue];
    }
    return val;
}
//加载返回 bool类型
+ (BOOL)loadInfoReturnBool:(NSString *)key{ 
     int  val = [UserDefaultsUtil loadInfoReturnInt:key];  
    if(val>0){
        return true;
    }else{
        return false;
    } 
}

+ (void)updateInfoByBool:(NSString *)key :(BOOL) value{
    if(value == true){
        [UserDefaultsUtil saveInfo:key :G_STR_YES];
    }else{
        [UserDefaultsUtil saveInfo:key :G_STR_NO];
    }
}

@end
