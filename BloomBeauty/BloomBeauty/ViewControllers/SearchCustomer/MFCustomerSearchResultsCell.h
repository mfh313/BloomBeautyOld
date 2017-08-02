//
//  MFCustomerSearchResultsCell.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MFCustomerSearchResultsCellDelegate <NSObject>

@optional
- (void)onClickAnalysis:(NSIndexPath *)indexPath;

- (void)onClickSetCurrentCustomer:(NSIndexPath *)indexPath;

- (void)onClickHeadImage:(NSIndexPath *)indexPath;

@end

@interface MFCustomerSearchResultsCell : MFTableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<MFCustomerSearchResultsCellDelegate> delegate;
@property (nonatomic,strong) CustomerInfo *customerInfo;
@property (nonatomic,copy)  void(^clickPathBlock)(UIView *animationView);


@end
