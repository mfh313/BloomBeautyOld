//
//  MFTabItemButton.h
//  BloomBeauty
//
//  Created by EEKA on 16/7/7.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIButton.h"

@interface MFTabItemDataItem : NSObject

@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highlightImage;
@property (nonatomic,strong) NSString *normalTitle;
@property (nonatomic,strong) UIColor *normalTitleColor;
@property (nonatomic,strong) NSString *highlightTitle;
@property (nonatomic,strong) UIColor *highlightTitleColor;

@end


#pragma mark - MFTabItemButton
@interface MFTabItemButton : MFUIButton

@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highlightImage;
@property (nonatomic,strong) NSString *normalTitle;
@property (nonatomic,strong) UIColor *normalTitleColor;
@property (nonatomic,strong) NSString *highlightTitle;
@property (nonatomic,strong) UIColor *highlightTitleColor;
@property (nonatomic,assign) BOOL isTouchHighlighted;

@end
