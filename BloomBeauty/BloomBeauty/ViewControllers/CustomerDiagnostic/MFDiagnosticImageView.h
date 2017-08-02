//
//  MFDiagnosticImageView.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/15.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFDiagnosticSelectView.h"

@interface MFDiagnosticImageView : MFDiagnosticSelectView

-(void)setSelected:(BOOL)selected;
-(void)setImageUrl:(NSString *)imageUrl contentDescription:(NSString *)contentDescription;
-(void)setImage:(UIImage *)image remark:(NSMutableAttributedString *)remark;
-(void)setImageUrl:(NSString *)imageUrl remark:(NSMutableAttributedString *)remark;
-(void)setImageWidthLayout:(CGFloat)widthConstant height:(CGFloat)heightConstant;

@end
