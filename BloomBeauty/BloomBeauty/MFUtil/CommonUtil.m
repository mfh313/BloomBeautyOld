//
//  SOXMapUtil.m
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import "CommonUtil.h"
@implementation CommonUtil
+ (NSString*)intToString:(int)i{
    return [NSString stringWithFormat:@"%d",i];
}
+ (NSString*)floatToString:(float)f{
    return [NSString stringWithFormat:@"%f",f];
}

+ (NSString*)doubleToString:(double)d{
    return [NSString stringWithFormat:@"%f",d];
}

+ (int)floatToInt:(float)f{
    return [[CommonUtil floatToString:f]intValue];
}

+ (float)intToFloat:(int)i{
    return [[CommonUtil intToString:i]floatValue];
}
+ (double)intToDouble:(int)i{
    return [[CommonUtil intToString:i]doubleValue];
}
+ (double)strToDouble:(NSString*)str{
    double val = 0;
    if([CommonUtil isNotNull:str]){
        val = [str doubleValue];
    }
    return val;
}


+ (BOOL)isNull:(NSString *)str{
    if(str==nil || [str isEqualToString:@""]){
        return true;
    }
    return false;
}
+ (BOOL)isNotNull:(NSString *)str{
    if(str!=nil && ![str isEqualToString:@""]){
        return true;
    }
    return false; 
}
   
+ (NSString *)getFormatTimeStr:(int)time{
    NSString *strSecond = @"";
    if (time < 10) {
        strSecond= [NSString stringWithFormat:@"0%d",time] ;// strSecond = ""
    } else {
        strSecond= [NSString stringWithFormat:@"%d",time] ;
    }
    return strSecond;
}
+ (NSString *)getFormatAllTimeStr:(float)time{
    NSString *strReturn = @"";
    NSNumber *n_minute=[NSNumber numberWithFloat:time/60];
    NSNumber *n_second=[NSNumber numberWithFloat:time];
    int minute=[n_minute intValue];
    int second=[n_second intValue]%60;
    NSString *strMinute=[CommonUtil getFormatTimeStr:minute];
    NSString *strSecond=[CommonUtil getFormatTimeStr:second];
    strReturn=[NSString stringWithFormat:@"%@:%@",strMinute, strSecond];
    return strReturn;
}
+ (NSString *)getFormatAllDistanceStr:(float)time{
    NSString *strReturn = @"";
    NSNumber *n_minute=[NSNumber numberWithFloat:time/60];
    NSNumber *n_second=[NSNumber numberWithFloat:time];
    int minute=[n_minute intValue];
    int second=[n_second intValue]%60;
    NSString *strMinute=[CommonUtil getFormatTimeStr:minute];
    NSString *strSecond=[CommonUtil getFormatTimeStr:second];
    strReturn=[NSString stringWithFormat:@"%@:%@",strMinute, strSecond];
    return strReturn;
}

+ (NSString *)notRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


+ (int)getRandomByDict :(NSMutableDictionary*)dict{
   // srand(time(NULL));
    if(dict == nil){
        return 0;
    }
    NSArray *keyArray = [dict allKeys];
    if(keyArray.count == 0){
        return 0;
    }
    int i = arc4random()%keyArray.count;
    return [[keyArray objectAtIndex:i] intValue];
}



//注意 生产的 总是尽量是 原始char的 +2  或以上  否则 如果+1 默认之后加在最后面 。。。
+ (NSString*)createRandomCharList :(NSString*)strChar :(int)createCnt{
    if(createCnt <= strChar.length ){
        return strChar;
    }
    NSString *lastVal = @"";
    int _insertCount = createCnt - strChar.length ;
  //  if(_insertCount == 0){
   //     return strChar;
  //  }
    for (int i = 0; i < [strChar length]; i++){
        //找拼接
        int nowInesrtCnt = arc4random()%_insertCount;
        _insertCount = _insertCount-nowInesrtCnt;
        NSString *insertStr= [CommonUtil getRandomCharList:strChar :nowInesrtCnt];
        //取出初始值
        NSString *strOri = [strChar substringWithRange:NSMakeRange(i, 1)];
        //第一个参数 往前面插入
        if(i == 0){
            lastVal = [NSString stringWithFormat:@"%@%@%@",lastVal,insertStr,strOri];
        }else{
            //第一个之后  往后面插入
            lastVal = [NSString stringWithFormat:@"%@%@%@",lastVal,strOri,insertStr];
        }
    }
    //把剩余 没有生成的 补上
    if(_insertCount>0){
        NSString *insertStr= [CommonUtil getRandomCharList:strChar :_insertCount];
        lastVal = [NSString stringWithFormat:@"%@%@",lastVal,insertStr];
    }
    return lastVal;
}

+ (NSString*)getRandomCharList :(NSString*)strChar :(int )insertCnt{
    NSString *newVal = @"";
    for (int i=0; i<insertCnt; i++) {
        NSString *randomStr= [CommonUtil getRandomChar:strChar];
        newVal = [NSString stringWithFormat:@"%@%@",randomStr,newVal];
    }
    return newVal;
}/*
//between -1 and 1
+ (float)getRandomMinus1_1{
    return CCRANDOM_MINUS1_1() ;
}
//returns a random float between 0 and 1
+ (float)getRandom0_1{
    return CCRANDOM_0_1() ;
}*/

+ (NSString*)getRandomChar :(NSString*)strChar{
    NSString *nowVal = @"";
    if(strChar!=nil && [strChar length] > 0){
        int i =arc4random()%[strChar length];
        nowVal = [strChar substringWithRange:NSMakeRange(i, 1)];
    }
    return nowVal;
}


+(void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+ (NSString *)getNowBundleVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_Version;
}

+ (NSString *)ecodeString:(NSString *)inputVal
{
    NSString *result =  (CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)inputVal, NULL, (CFStringRef)@"+", kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)decodeString:(NSString*)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}



+ (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9]))\\d{8}$";
    
//    if(!/^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\d{8}$/i.test(mobile)){ alert('error');}
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
    
}
+ (BOOL)checkNumber:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^[1-9]\\d*$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkHanzhi:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"[\u4e00-\u9fa5]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
    
}

+ (NSString*)getAddZeroNum:(NSNumber *)number
{
    if( [number integerValue] >= 10 )
    {
        return  [number stringValue];
    }else
    {
        return  [NSString stringWithFormat:@"0%@",[number stringValue]];
    }
}



+ (NSString*)getRandomNumber:(NSNumber *)number
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}


//邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



-(NSString*)listToIds:(NSArray*)array
{
    NSMutableString *Nos = [[NSMutableString alloc]init];
    NSString *ret = @"";
    for (NSString *str in array) {
            [Nos appendString:str];
            [Nos appendString:@","];
    }
    if(Nos.length > 0)
    {
        ret = [Nos substringWithRange:NSMakeRange(0,Nos.length-1)];
    }
    return ret;
}


@end
