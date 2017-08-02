//
//  MFCustomerDiagnosticLogic.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/14.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"
#import "MFDiagnosticModel.h"

typedef void(^MFCustomerDiagnosticLogicLoadCompletedBlock)(NSMutableArray *dataArray);
typedef void(^MFCustomerDiagnosticLogicLoadProgressBlock)(NSString *message);
typedef void(^MFCustomerDiagnosticLogicLoadFailureBlock)(NSError *error);
typedef void(^MFCustomerDiagnosticLogicCheckLoadBlock)(BOOL needReload);

@interface MFCustomerDiagnosticLogic : MFObject
{
    NSMutableArray *_diagnosticDataItemArray;
    CGFloat _maxLayOutWidth;
}

+(MFCustomerDiagnosticLogic *)sharedLogic;
+(void)getDiagnosticData:(MFCustomerDiagnosticLogicLoadCompletedBlock)completedBlock
                progress:(MFCustomerDiagnosticLogicLoadProgressBlock)progressBlock
               failBlock:(MFCustomerDiagnosticLogicLoadFailureBlock)failBlock;
-(void)needLoadQuestions:(MFCustomerDiagnosticLogicCheckLoadBlock)loadBlock;

-(NSMutableArray *)diagnosticQuestions;


@end
