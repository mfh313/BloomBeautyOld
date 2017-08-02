//
//  MFCustomerSearchBar.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@class MFCustomerSearchBar;

@protocol MFCustomerSearchBarDelegate <NSObject>

@optional
-(void)searchBar:(MFCustomerSearchBar *)searchBar searchText:(NSString *)text;
-(void)searchBarOnClickCancelSearch:(MFCustomerSearchBar *)searchBar;

@end

@interface MFCustomerSearchBar : MFUIView

@property (nonatomic,strong) id<MFCustomerSearchBarDelegate> delegate;
@property (nonatomic,assign) BOOL cancelBtnAlwaysShow;

- (void)clearContent;
- (BOOL)resignFirstResponder;
- (void)setPlaceHolder:(NSString *)placeHolder;
- (NSString*)getSearchText;
- (void)setText:(NSString *)text;


@end
