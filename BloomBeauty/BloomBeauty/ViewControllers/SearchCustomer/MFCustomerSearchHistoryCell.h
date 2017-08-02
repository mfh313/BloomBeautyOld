//
//  MFCustomerSearchHistoryCell.h
//  BloomBeauty
//
//  Created by Administrator on 15/12/10.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MFCustomerSearchHistoryCellDelegate <NSObject>

@optional
- (void)onClickHistory:(NSIndexPath *)indexPath;

@end

@interface MFCustomerSearchHistoryCell : MFTableViewCell

@property (nonatomic,weak) id<MFCustomerSearchHistoryCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) CustomerInfo *customerInfo;

- (void)setName:(NSString *)name;

@end
