//
//  WCActionSheet.m
//  BloomBeauty
//
//  Created by EEKA on 2017/1/10.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "WCActionSheet.h"

#define kButtonHeight 48.f
#define kSeparatorHeight .5f

@interface WCActionSheet ()
{
    NSMutableArray *_buttons;
}

@end

@implementation WCActionSheet
@synthesize delegate = _delegate;

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<WCActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,...
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        
        _cancelButtonTitle = cancelButtonTitle;
        
        _buttons = [NSMutableArray array];
        _buttonTitleList = [NSMutableArray array];
        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *title = otherButtonTitles; title != nil; title = va_arg(args, NSString*))
        {
            [_buttonTitleList addObject:title];
        }
        va_end(args);
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    return NSNotFound;
}

-(UIView *)makeTitleViewWithTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    view.backgroundColor = [UIColor redColor];
    
    return view;
}

- (UIView *)makePannelViewWithButtonList:(NSMutableArray *)buttonTitleList withCancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0f;
    view.frame = CGRectMake(0, 0, [[self class] getActionSheetWidth], 0);
    
    [_buttons removeAllObjects];
    CGFloat orignY = 0;
    for (int i = 0; i < buttonTitleList.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        itemButton.frame = CGRectMake(0, orignY, CGRectGetWidth(view.frame), kButtonHeight);
        [itemButton setTitle:buttonTitleList[i] forState:UIControlStateNormal];
        [itemButton addTarget:self action:@selector(OnDefaultButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemButton.frame), CGRectGetWidth(view.frame), kSeparatorHeight)];
        lineView.backgroundColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:0.5];
        
        [view addSubview:itemButton];
        
        [_buttons addObject:itemButton];
        
        orignY += CGRectGetHeight(itemButton.frame);
        
        if (i != buttonTitleList.count - 1) {
            [view addSubview:lineView];
            orignY += CGRectGetHeight(lineView.frame);
        }
    }
    
    if (cancelButtonTitle) {
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, CGRectGetWidth(view.frame), 6)];
        sepView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.82 alpha:0.3];
        [view addSubview:sepView];
        orignY += CGRectGetHeight(sepView.frame);
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(0, orignY, CGRectGetWidth(view.frame), kButtonHeight);
        [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(OnCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:cancelButton];
        orignY += CGRectGetHeight(cancelButton.frame);
    }
    
    CGRect viewFrame = view.frame;
    viewFrame.size.height = orignY;
    [view setFrame:viewFrame];
    
    
    return view;
}

- (void)OnDefaultButtonTapped:(UIButton *)button
{
    NSInteger tapBtnIndex = [_buttons indexOfObject:button];
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:tapBtnIndex];
    }
    
    [self dismissWithClickedButtonIndex:tapBtnIndex animated:YES];
    
}

- (void)dismissWithClickedButtonIndex:(NSInteger)index animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:index];
    }
    
    if (animated) {
        
        if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
            [self.delegate actionSheet:self didDismissWithButtonIndex:index];
        }
    }
    
    else
    {
        if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
            [self.delegate actionSheet:self didDismissWithButtonIndex:index];
        }
    }
    
    [self setHidden:YES];
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)window
{
    self.frame = window.bounds;
    
    self.windowLevel = 10000000;
    self.hidden = NO;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:_backgroundView];
    
    _titleView = [self makeTitleViewWithTitle:_title];
    _pannelView = [self makePannelViewWithButtonList:_buttonTitleList withCancelButtonTitle:_cancelButtonTitle];
    _pannelView.center = self.center;
    [self addSubview:_pannelView];

    [self addTapRecognizer];
    
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [self.delegate willPresentActionSheet:self];
    }
    
    [window addSubview:self];
}

- (void)addTapRecognizer
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnCancel:)];
    [_backgroundView addGestureRecognizer:tapGes];
}

-(void)OnCancel:(id *)sender
{
    [self setHidden:YES];
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [self.delegate actionSheetCancel:self];
    }
}

+ (NSInteger)getActionSheetWidth
{
    return CGRectGetWidth([[UIApplication sharedApplication].delegate window].bounds) - 360;
}

- (double)heightOfWholeSheet
{
    return _pannelView.frame.size.height + _titleView.frame.size.height;
}

-(NSMutableArray *)buttonTitleList
{
    if (!_buttonTitleList) {
        _buttonTitleList = [NSMutableArray array];
    }
    return _buttonTitleList;
}

@end
