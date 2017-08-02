//
//  MFCustomerDiagnosticRecordsItemView.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/13.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticRecordsItemView.h"

@interface MFCustomerDiagnosticRecordsItemView ()
{
    
    __weak IBOutlet UILabel *_lineNumberLabel;
    
    __weak IBOutlet UILabel *_DiagnosticDateLabel;
    __weak IBOutlet UILabel *_entityNameLabel;
    
    __weak IBOutlet UILabel *_shopingGuideNameLabel;
    
    __weak IBOutlet UIButton *_handeBtn;
}

@end

@implementation MFCustomerDiagnosticRecordsItemView
@synthesize delegate,indexPath;

-(void)setClickBtnColorfull
{
    [_handeBtn setTitleColor:[UIColor hx_colorWithHexString:@"EE5C37"] forState:UIControlStateNormal];
}

-(void)setLabelColor:(UIColor *)color
{
    _lineNumberLabel.textColor = color;
    _DiagnosticDateLabel.textColor = color;
    _entityNameLabel.textColor = color;
    _shopingGuideNameLabel.textColor = color;
    [_handeBtn setTitleColor:color forState:UIControlStateNormal];
}

-(void)setLineNumber:(NSString *)lineNumber
      DiagnosticDate:(NSString *)DiagnosticDate
          entityName:(NSString *)entityName
    shopingGuideName:(NSString *)shopingGuideName
{
    _lineNumberLabel.text = lineNumber;
    _DiagnosticDateLabel.text = DiagnosticDate;
    _entityNameLabel.text = entityName;
    _shopingGuideNameLabel.text = shopingGuideName;
}

-(void)setHandleBtnTitle:(NSString *)title
{
    [_handeBtn setTitle:title forState:UIControlStateNormal];
}

- (IBAction)onClickHandleBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onClickDiagnosticBtn:)]) {
        [self.delegate onClickDiagnosticBtn:self.indexPath];
    }
}


@end
