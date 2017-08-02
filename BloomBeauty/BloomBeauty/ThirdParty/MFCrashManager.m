//
//  MFCrashManager.m
//  BloomBeauty
//
//  Created by EEKA on 16/1/19.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCrashManager.h"
#import <CrashReporter/CrashReporter.h>

/* 看帖子
http://www.cnblogs.com/lancidie/archive/2013/04/13/3019353.html

PLCrashReporter

同类 HockeySDK-iOS
 */

@implementation MFCrashManager

//[self enableCrashFrameWorks];
//
////    NSMutableArray *testArray = [NSMutableArray arrayWithObjects:@"1",@"2"];
////    id test = testArray[3];


-(void)enableCrashFrameWorks
{
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    NSError *error;
    if ([crashReporter hasPendingCrashReport])
    {
        [self handleCrashReport];
    }
    
    if (![crashReporter enableCrashReporterAndReturnError: &error])
    {
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    }
    
    //    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
    //                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    //    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    //
    //    NSData *data = [crashReporter generateLiveReport];
    //    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    //    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
    //                                                              withTextFormat:PLCrashReportTextFormatiOS];
    //
    //    NSLog(@"------------\n%@\n------------", report);
}

- (void) handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
    if (report == nil) {
        NSLog(@"Could not parse crash report");
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    NSLog(@"Crashed on %@", report.systemInfo.timestamp);
    NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
          report.signalInfo.code, report.signalInfo.address);
    
    NSString *stringRepresentation = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
    [self sendDataOnLatestCrashToServer:stringRepresentation];
    //    [crashReporter purgePendingCrashReport];
    
}

- (void)sendDataOnLatestCrashToServer:(NSString *)crashString
{
    /* NSDictionary *params = @{
     @"StackTrace" : crashString
     // Add more parameters as you want
     };
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
     
     NSURL *url = [NSURL URLWithString:@"http://www.YOURRESTSERVER.com"];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
     
     [request setHTTPMethod:@"POST"];
     [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:jsonData];
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
     
     }];
     */
}



@end
