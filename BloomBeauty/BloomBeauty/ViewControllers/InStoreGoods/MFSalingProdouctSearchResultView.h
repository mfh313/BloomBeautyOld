//
//  MFSalingProdouctSearchResultView.h
//  BloomBeauty
//
//  Created by EEKA on 2017/4/16.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@interface MFSalingProdouctSearchResultView : MFUIView

@property (nonatomic,strong) NSString *itemStyleColor;
@property (nonatomic,strong) NSString *itemOriginalItemUrl;

-(void)queryAvailableDetail;

@end
