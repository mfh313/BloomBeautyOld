//
//  MFOneClothesMatchLayoutLogic.h
//  BloomBeauty
//
//  Created by EEKA on 2017/3/8.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFOneClothesMatchLayoutLogic : NSObject
{
    CGSize _contextSize;
    NSMutableArray *_originSourceSize;
}

@property (nonatomic,assign) CGSize contextSize;
@property (nonatomic,assign) BOOL isUpMiddleMatch;

-(NSMutableArray *)layoutFrames:(NSMutableArray *)originSourceSize;

@end
