//
//  MFDiagnosticSelectView.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/15.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"
#import "MFDiagnosticModel.h"

@class MFDiagnosticSelectView;

@protocol MFDiagnosticSelectViewDelegate <NSObject>

@optional
-(BOOL)shouldSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)indexPath;

-(void)shouldNotSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)indexPath;

-(void)didSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)indexPath;

-(void)didDeselectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)indexPath;

@end

@interface MFDiagnosticSelectView : MFUIView
{
    BOOL _selected;
}

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<MFDiagnosticSelectViewDelegate> delegate;

-(void)setSelected:(BOOL)selected;
-(NSMutableAttributedString *)_textWithString:(NSString *)text;
-(NSMutableAttributedString *)_textWithString:(NSString *)text WithRemarkColor:(UIColor *)remarkColor;
-(NSMutableAttributedString *)_textWithString:(NSString *)text
                              WithRemarkColor:(UIColor *)remarkColor
                                  normalColor:(UIColor *)normolColor;

@end
