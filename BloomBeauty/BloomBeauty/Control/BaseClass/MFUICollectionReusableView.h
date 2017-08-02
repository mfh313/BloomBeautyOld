//
//  MFUICollectionReusableView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/1/17.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFUICollectionReusableView : UICollectionReusableView
{
    UIView* m_subContentView;
}

@property(strong, nonatomic) UIView* m_subContentView;

@end
