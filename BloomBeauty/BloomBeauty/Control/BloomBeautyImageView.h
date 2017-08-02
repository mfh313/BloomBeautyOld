//
//  BloomBeautyImageView.h
//  BloomBeauty
//
//  Created by EEKA on 16/4/24.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BloomBeautyImageView;

@protocol BloomBeautyImageViewDelegate <NSObject>

-(void)onClickBBImage:(BloomBeautyImageView *)imageView;

@end

@interface BloomBeautyImageView : UIControl
{
    UIImageView *m_imageView;
}

@end
