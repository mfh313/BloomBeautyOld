//
//  MFCustomerBodyMadeCollectionHeaderView.h
//  BloomBeauty
//
//  Created by EEKA on 2016/12/7.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFCustomerBodyMadeCollectionNormalHeaderView;
@interface MFCustomerBodyMadeCollectionHeaderView : UICollectionReusableView
{
    MFCustomerBodyMadeCollectionNormalHeaderView *_contentLabel;
}

- (void)setTitle:(NSString *)title;

@end
