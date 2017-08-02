//
//  WCActionSheet.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/10.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCActionSheet;
@protocol WCActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(WCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(WCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(WCActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)actionSheetCancel:(WCActionSheet *)actionSheet;
- (void)didPresentActionSheet:(WCActionSheet *)actionSheet;
- (void)willPresentActionSheet:(WCActionSheet *)actionSheet;
@end


@interface WCActionSheet : UIWindow
{
    NSString *_cancelButtonTitle;
    NSMutableArray *_buttonTitleList;
    
    UIView *_pannelView;
    UIView *_titleView;
    UIView *_backgroundView;
    UIView *_containerView;
    
    __weak id<WCActionSheetDelegate> _delegate;
    NSString *_title;
    
    NSInteger _destructiveButtonIndex;
    NSInteger _firstOtherButtonIndex;
    NSInteger _cancelButtonIndex;
    
    UIColor *_cancelBtnTextColor;
    NSInteger _numberOfButtons;
    
    UIView *_customView;
}

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) NSMutableArray *buttonTitleList;
@property (nonatomic,strong) UIColor *cancelBtnTextColor;
@property (nonatomic,assign) NSInteger cancelButtonIndex;
@property (nonatomic,strong) NSString *cancelButtonTitle;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIView *customView;
@property (nonatomic,weak) id<WCActionSheetDelegate> delegate;
@property (nonatomic,assign) NSInteger destructiveButtonIndex;
@property (nonatomic,assign) NSInteger numberOfButtons;
@property (nonatomic,strong) UIView *pannelView;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIView *titleView;

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<WCActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

- (void)showInView:(UIView *)view;

@end
