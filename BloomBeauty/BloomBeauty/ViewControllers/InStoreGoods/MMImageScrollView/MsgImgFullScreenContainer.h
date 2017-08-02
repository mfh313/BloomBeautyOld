//
//  MsgImgFullScreenContainer.h
//  Spring
//
//  Created by EEKA on 16/3/23.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"

@class MFCommodityDetailModel;
@interface MsgImgFullScreenContainer : UIScrollView <UIScrollViewDelegate>
{
    ImageScrollView *_imgScrollView;
    UIImageView *_contentImageView;
}

-(void)initWithCommodityDetailModel:(MFCommodityDetailModel *)commodityDetailModel;

@end
