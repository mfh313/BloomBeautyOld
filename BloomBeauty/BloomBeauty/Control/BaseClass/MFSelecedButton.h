//
//  MFSelecedButton.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/12.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIButton.h"

@class MFSelecedButton;
@protocol MFSelecedButtonDelegate <NSObject>

@optional
- (void)OnTouchUp:(MFSelecedButton*)btn;
- (void)OnTouchDown:(MFSelecedButton*)btn;
- (void)OnLongPress:(MFSelecedButton*)btn;
- (void)OnPress:(MFSelecedButton*)btn;
@end

@interface MFSelecedButton : MFUIButton

@property (weak, nonatomic) IBOutlet UILabel *textlabel;

@property(nonatomic,weak) id<MFSelecedButtonDelegate> touchDelegate;
@property(nonatomic,strong) UIImage *normalImage;
@property(nonatomic,strong) UIImage *selectedImage;
@property(nonatomic,strong) UIImage *normalBackgroundImage;
@property(nonatomic,strong) UIImage *selectedBackgroundImage;
@property(nonatomic,strong) UIColor *normalTextColor;
@property(nonatomic,strong) UIColor *selectedTextColor;

-(void)setText:(NSString *)text;
-(void)setTextEdgeInsets:(UIEdgeInsets)inset;

@end
