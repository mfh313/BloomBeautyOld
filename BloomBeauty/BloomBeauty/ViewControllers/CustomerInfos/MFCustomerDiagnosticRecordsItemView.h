//
//  MFCustomerDiagnosticRecordsItemView.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/13.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFCustomerDiagnosticRecordsItemViewDelegate <NSObject>

-(void)onClickDiagnosticBtn:(NSIndexPath *)indexPath;

@end

@interface MFCustomerDiagnosticRecordsItemView : MFUIView

@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,weak) id<MFCustomerDiagnosticRecordsItemViewDelegate> delegate;

-(void)setClickBtnColorfull;
-(void)setLabelColor:(UIColor *)color;

-(void)setHandleBtnTitle:(NSString *)title;

-(void)setLineNumber:(NSString *)lineNumber
      DiagnosticDate:(NSString *)DiagnosticDate
          entityName:(NSString *)entityName
    shopingGuideName:(NSString *)shopingGuideName;

@end
