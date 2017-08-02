//
//  MFUIButton.h
//  装扮灵
//
//  Created by Administrator on 15/10/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFUIButton : UIButton <XXNibBridge>

+ (id)viewWithNib;

+ (id)viewWithNibName:(NSString *)nibName;

@end
