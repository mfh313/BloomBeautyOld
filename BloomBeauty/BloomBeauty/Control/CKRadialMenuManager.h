//
//  MFLoginCenter.h
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"
#import "CKRadialMenu.h"
@interface CKRadialMenuManager : MFObject<CKRadialMenuDelegate>
{
    
}
+ (CKRadialMenuManager *)sharedManager;

@property (nonatomic,strong) CKRadialMenu *menu;
@property (nonatomic,weak) UINavigationController *nowNav;
- (void)showMenu;
- (void)hiddenMenu;
@end
