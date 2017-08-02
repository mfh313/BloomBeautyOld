//
//  MFCustomerDiagnosticReportEmailSendViewController.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/22.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"

@protocol MFCustomerDiagnosticReportEmailSendDelegate <NSObject>

-(void)onClickDiagnosticReportEmailSend:(NSString *)emailAddress;

-(void)onClickDismissWindow;

@end

@interface MFCustomerDiagnosticReportEmailSendViewController : MFViewController

@property (nonatomic,strong) NSString *emailAddress;
@property (nonatomic,weak) id<MFCustomerDiagnosticReportEmailSendDelegate> delegate;

@end
