//
//  SOXMapUtil.m
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//
#import "UpgradeInfoUtil.h"
#import "UpgradeInfo.h"
#import "AFNetworking.h"

@implementation UpgradeInfoUtil
@synthesize upgradeInfo;

+ (UpgradeInfoUtil *)sharedUtil
{
    static UpgradeInfoUtil *upgradeInfoUtil = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        upgradeInfoUtil = [[self alloc] init];
    });
    
    return upgradeInfoUtil;
}

+ (NSString*)getNowShowVersion
{
    NSString *strVersion = [UpgradeInfoUtil getNowVersion];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[a-z0-9]+\\.[a-z0-9]+" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    NSRange firstRange = [regex rangeOfFirstMatchInString:strVersion options:0 range:NSMakeRange(0, strVersion.length)];
    if (firstRange.location != NSNotFound) {
        NSString *showString = [strVersion substringWithRange:firstRange];
        
        if ([MFApiUtil packageTest]) {
            return [NSString stringWithFormat:@"测试版本: %@",showString];
        }
        return [NSString stringWithFormat:@"当前版本: %@",showString];
    }
    
    return strVersion;
}

+ (NSString*)getNowStrVersion
{
    NSString *strVersion = [NSString stringWithFormat:@"%@",[UpgradeInfoUtil getNowVersion]];
    return strVersion;
}

+ (NSString *)getNowVersion
{
    NSString *nowBundleVersion =  [CommonUtil getNowBundleVersion];
    return nowBundleVersion;
}

- (void)checkUpgradeInfo:(void (^)(UpgradeInfo *info))success
{
    [[AFHTTPSessionManager manager] POST:MFApiCheckUpgradeURL
                              parameters:nil
                                progress:^(NSProgress * uploadProgress) {

    } success:^(NSURLSessionDataTask * task, id  responseObject)
    {
        if (!responseObject || [responseObject isKindOfClass:[NSNull class]]) {
            return;
            
        }
        
        UpgradeInfo *apiObj = [UpgradeInfo objectWithKeyValues:responseObject];
        
        NSString *strNewVersion = apiObj.version;
        NSString *strupgradeUrl = apiObj.iosUrl;
        NSString *nowVersion = [UpgradeInfoUtil getNowVersion];
        
        strupgradeUrl = [CommonUtil decodeString:strupgradeUrl];
        
        if (![strNewVersion isEqualToString:nowVersion])
        {
            apiObj.isNeedUprade = true;
        }
        else
        {
            apiObj.isNeedUprade = false;
        }
        
        apiObj.lastUrl = strupgradeUrl;
        self.upgradeInfo = apiObj;
        
        if (success) {
            success(upgradeInfo);
        }

    } failure:^(NSURLSessionDataTask * task, NSError *  error) {
        NSLog(@"error=%@",error.localizedDescription);
    }];
}

@end
