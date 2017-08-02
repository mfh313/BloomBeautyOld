//
//  MFSearchBar.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFSearchBar;

@protocol MFSearchBarDelegate <NSObject>

@optional
-(void)searchBar:(MFSearchBar *)searchBar searchText:(NSString *)text;
-(void)searchBarCancelButtonClicked:(MFSearchBar *)searchBar;
-(BOOL)searchBar:(MFSearchBar *)searchBar shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

@interface MFSearchBar : MFUIView

@property (nonatomic,strong) id<MFSearchBarDelegate> delegate;

- (void)clearContent;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (void)setPlaceHolder:(NSString *)placeHolder;
- (NSString*)searchText;

@end
