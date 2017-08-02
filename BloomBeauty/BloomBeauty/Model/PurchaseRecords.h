//
//  LoginUserInfo.h
//  装扮灵
//
//  Created by Administrator on 15/11/4.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h" 


@interface PurchaseRecords : MFObject

@property (nonatomic,strong) NSString *entityName;
@property (nonatomic,strong) NSString *posVoucherCode;
@property (nonatomic,strong) NSString *posVoucherDate;
@property (nonatomic,strong) NSMutableArray *posVoucherDetailList;//PosVoucherDetail

@end
