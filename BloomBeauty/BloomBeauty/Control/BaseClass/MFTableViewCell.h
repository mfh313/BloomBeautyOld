//
//  MFTableViewCell.h
//  装扮灵
//
//  Created by Administrator on 15/10/18.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFTableViewCell : UITableViewCell <XXNibBridge>
{
   UIView* m_subContentView;
}

@property(strong, nonatomic) UIView* m_subContentView;
+ (id)getCellAttributeDetailTextHightlightedColor;
+ (id)getCellAttributeTextHightlightedColor;
+ (id)getCellTextHightlightedColor;
- (void)addBackgroundView;
- (void)addCustomArrow;
- (void)setAccessoryType:(int)type;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)init;

@end
