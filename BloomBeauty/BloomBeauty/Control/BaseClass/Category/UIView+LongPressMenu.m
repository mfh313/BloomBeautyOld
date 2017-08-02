//
//  UIView+LongPressGes.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "UIView+LongPressMenu.h"
#import "objc/runtime.h"

@interface UIView ()

@property (nonatomic,retain) UILongPressGestureRecognizer *MF_LongPressGesture;
@property (nonatomic,strong) NSArray *MF_menuTitles;
@property (nonatomic,strong) id MF_sendObject;
@property (nonatomic,strong) NSArray *MF_SELArray;

@end


@implementation UIView (LongPressMenu)

- (void)setMF_LongPressGestureTitles:(NSArray *)MF_menuTitles
                              object:(id)MF_sendObject
                            SELArray:(NSArray *)array
{
    self.MF_menuTitles = MF_menuTitles;
    self.MF_sendObject = MF_sendObject;
    self.MF_SELArray = array;
}

- (void)addMF_LongPressGesture
{
    self.userInteractionEnabled = YES;
    if (!self.MF_LongPressGesture) {
        self.MF_LongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(MF_handleLongPress:)];
        self.MF_LongPressGesture.minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.MF_LongPressGesture];
    }
    
}

-(void)setMF_LongPressGesture:(UILongPressGestureRecognizer *)MF_LongPressGesture
{
    objc_setAssociatedObject(self, [self getKeyFromString:@"MF_LongPressGesture"], MF_LongPressGesture, OBJC_ASSOCIATION_RETAIN);
}

-(UILongPressGestureRecognizer *)MF_LongPressGesture
{
    return (UILongPressGestureRecognizer *)objc_getAssociatedObject(self, [self getKeyFromString:@"MF_LongPressGesture"]);
}

-(void)setMF_menuTitles:(NSArray *)MF_menuTitles
{
    objc_setAssociatedObject(self, [self getKeyFromString:@"MF_menuTitles"], MF_menuTitles, OBJC_ASSOCIATION_RETAIN);
}

-(NSArray *)MF_menuTitles
{
    return (NSArray *)objc_getAssociatedObject(self, [self getKeyFromString:@"MF_menuTitles"]);
}

-(void)setMF_sendObject:(id)MF_sendObject
{
    objc_setAssociatedObject(self, [self getKeyFromString:@"setMF_sendObject"], MF_sendObject, OBJC_ASSOCIATION_RETAIN);
}

-(id)MF_sendObject
{
    return (NSArray *)objc_getAssociatedObject(self, [self getKeyFromString:@"setMF_sendObject"]);
}

-(void)setMF_SELArray:(NSArray *)MF_SELArray
{
    if (self.MF_LongPressGesture) {
        objc_setAssociatedObject(self, [self getKeyFromString:@"setMF_SELArray"], MF_SELArray, OBJC_ASSOCIATION_RETAIN);
    }
}

-(NSArray *)MF_SELArray
{
    return (NSArray *)objc_getAssociatedObject(self, [self getKeyFromString:@"setMF_SELArray"]);
}

-(void)MF_handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        if (![window isKeyWindow])
        {
            [window becomeKeyWindow];
            [window makeKeyAndVisible];
        }
        
        if (self.MF_menuTitles.count == 0 || self.MF_SELArray.count == 0) {
            return;
        }
        
        NSMutableArray *menuItems = [NSMutableArray array];
        for (int i = 0; i < self.MF_menuTitles.count; i++) {
            NSString *title = self.MF_menuTitles[i];
            NSString *str = self.MF_SELArray[i];
            SEL selector = NSSelectorFromString(str);
            UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:title action:selector];
            item.action = NSSelectorFromString(str);
            [menuItems addObject:item];
        }
        
        [[UIMenuController sharedMenuController] setMenuItems:menuItems];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        
    }
}

-(BOOL)canBecomeFirstResponder{
    
    if (self.MF_LongPressGesture) {
        return YES;
    }
    
    return [super canBecomeFirstResponder];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    BOOL canPerformAction = [super canPerformAction:action withSender:sender];
    
    NSArray *selArray = self.MF_SELArray;
    if ([selArray containsObject:NSStringFromSelector(action)]) {
        canPerformAction = YES;
    }
    
    return canPerformAction;
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.MF_sendObject respondsToSelector:aSelector]) {
        return self.MF_sendObject;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

- (const char*)getKeyFromString:(NSString *)string
{
    return sel_getName(NSSelectorFromString(string));
}

@end


//static void *tagMenuItemKey;
//@interface UIMenuItem (tagMenuItem)
//
//@property (nonatomic,assign) SEL tagSEL;
//
//@end
//
//@implementation UIMenuItem (tagMenuItem)
//
//
//-(void)setTagSEL:(SEL)tagSEL
//{
//    objc_setAssociatedObject(self, tagMenuItemKey, NSStringFromSelector(tagSEL), OBJC_ASSOCIATION_RETAIN);
//}
//
//-(SEL)tagSEL
//{
//    return NSSelectorFromString((NSString *)objc_getAssociatedObject(self, tagMenuItemKey));
//}
//
//@end
