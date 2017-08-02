//
//  MFCustomerDiagnosticApi.h
//  BloomBeauty
//
//  Created by EEKA on 16/10/8.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFNetworkRequest.h"

@interface MFCustomerDiagnosticApi : MFNetworkRequest
{
    NSString *_employeeId;
    NSString *_entityId;
    NSString *_questionJson;
    NSString *_questionVersion;
}

@property (nonatomic,strong) NSString *entityId;
@property (nonatomic,strong) NSString *employeeId;
@property (nonatomic,strong) NSString *questionJson;
@property (nonatomic,strong) NSString *questionVersion;

@end
