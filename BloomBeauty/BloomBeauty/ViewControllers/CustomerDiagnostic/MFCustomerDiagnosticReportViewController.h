//
//  MFCustomerDiagnosticReportViewController.h
//  BloomBeauty
//
//  Created by 马方华 on 15/12/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFViewController.h"

@interface MFCustomerDiagnosticReportViewController : MFViewController

@property (nonatomic,strong) NSNumber *diagnosisResultId;
@property (nonatomic,strong) CustomerInfo *diagnosticReportCustomerInfo;

@end
