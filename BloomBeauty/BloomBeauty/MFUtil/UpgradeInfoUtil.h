//
//  SOXMapUtil.h
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import <Foundation/Foundation.h> 
#import "UpgradeInfo.h"

@interface UpgradeInfoUtil : NSObject

@property (nonatomic,strong)UpgradeInfo *upgradeInfo;

+ (UpgradeInfoUtil *)sharedUtil;
+ (NSString *)getNowVersion;
+ (NSString*)getNowStrVersion;
+ (NSString*)getNowShowVersion;

- (void)checkUpgradeInfo:(void (^)(UpgradeInfo *info))success;

@end
