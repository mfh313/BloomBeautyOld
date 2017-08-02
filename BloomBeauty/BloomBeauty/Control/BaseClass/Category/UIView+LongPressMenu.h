//
//  UIView+LongPressMenu.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LongPressMenu)

- (void)setMF_LongPressGestureTitles:(NSArray *)MF_menuTitles
                             object:(id)MF_sendObject
                           SELArray:(NSArray *)array;

- (void)addMF_LongPressGesture;

@end
