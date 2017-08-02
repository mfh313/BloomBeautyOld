//
//  MFOneClothesMatchLayoutLogic.m
//  BloomBeauty
//
//  Created by EEKA on 2017/3/8.
//  Copyright © 2017年 EEKA. All rights reserved.
//

#import "MFOneClothesMatchLayoutLogic.h"

@implementation MFOneClothesMatchLayoutLogic
@synthesize contextSize = _contextSize;

-(NSMutableArray *)layoutFrames:(NSMutableArray *)originSourceSize
{
    _originSourceSize = originSourceSize;
    
    NSMutableArray *frames = [NSMutableArray array];
    
    if (originSourceSize.count == 3)
    {
        frames = [self threeImageLayout];
    }
    else if (originSourceSize.count == 2)
    {
        if (self.isUpMiddleMatch)
        {
            frames = [self upMiddleImageLayout];
        }
        else
        {
           frames = [self twoImageLayout];
        }
    }
    
    return frames;
}

-(NSMutableArray *)threeImageLayout
{
    NSValue *leftValue = _originSourceSize[0];
    CGSize leftSize = leftValue.CGSizeValue;
    
    NSValue *middleValue = _originSourceSize[1];
    CGSize middleSize = middleValue.CGSizeValue;
    
    NSValue *rightValue = _originSourceSize[2];
    CGSize rightSize = rightValue.CGSizeValue;
    
    CGFloat hspace = 5;  //水平重叠
    CGFloat vspace = 30;  //右边垂直重叠
    
    CGFloat lHeight = leftSize.height;
    CGFloat rHeight = middleSize.height + rightSize.height - vspace;
    
    CGFloat maxAllowHeight = (_contextSize.height - 120);
    CGFloat maxHeight = MAX(lHeight, rHeight);
    
    CGFloat scale = 1.0;
    
    if (maxHeight > maxAllowHeight)
    {
        scale = maxAllowHeight / maxHeight;
        maxHeight = maxAllowHeight;
    }
    
    //先建立两个虚拟框
    CGRect leftVirtualSpaceRect = CGRectMake(0, 0, leftSize.width * scale, maxHeight);
    CGRect rightVirtualSpaceRect = CGRectMake(0, 0, MAX(middleSize.width * scale, rightSize.width * scale), maxHeight);
    
    CGFloat spaceItemWidth = CGRectGetWidth(leftVirtualSpaceRect) + CGRectGetWidth(rightVirtualSpaceRect) - hspace;
    CGFloat leftSpaceOrignX = (_contextSize.width - spaceItemWidth) / 2;
    CGFloat spaceOrignY = (_contextSize.height - maxHeight) / 2;
    
    leftVirtualSpaceRect.origin.x = leftSpaceOrignX;
    leftVirtualSpaceRect.origin.y = spaceOrignY;
    rightVirtualSpaceRect.origin.x = CGRectGetMaxX(leftVirtualSpaceRect) - hspace;
    rightVirtualSpaceRect.origin.y = spaceOrignY;
    
    //第一个
    CGRect leftNewRect = CGRectMake(CGRectGetMinX(leftVirtualSpaceRect), CGRectGetMinY(leftVirtualSpaceRect) + (CGRectGetHeight(leftVirtualSpaceRect) - leftSize.height * scale) / 2, leftSize.width * scale, leftSize.height * scale);
    
    CGFloat rightHeights = middleSize.height * scale + rightSize.height * scale;
    
    //第二个
    CGFloat middleNewRectX = CGRectGetMinX(rightVirtualSpaceRect) + (CGRectGetWidth(rightVirtualSpaceRect) - middleSize.width * scale) / 2;
    CGFloat middleNewRectY = CGRectGetMinY(rightVirtualSpaceRect) + (CGRectGetHeight(rightVirtualSpaceRect) - rightHeights) / 2;
    CGRect middleNewRect = CGRectMake(middleNewRectX, middleNewRectY, middleSize.width * scale, middleSize.height * scale);
    
    //第三个
    CGFloat rightNewRectX = CGRectGetMinX(rightVirtualSpaceRect) + (CGRectGetWidth(rightVirtualSpaceRect) - rightSize.width * scale) / 2;
    CGFloat rightNewRectY = CGRectGetMaxY(middleNewRect) - vspace;
    CGRect rightNewRect = CGRectMake(rightNewRectX, rightNewRectY, rightSize.width * scale, rightSize.height * scale);
    
    CGFloat leftDownSpace = 100;
    
    CGRect rectLeft = leftNewRect;
    CGRect rectMiddle = middleNewRect;
    CGRect rectRight = rightNewRect;
    
    rectLeft.origin.y = rectMiddle.origin.y + leftDownSpace;
    if (CGRectGetMaxY(rectLeft) > CGRectGetMaxY(leftVirtualSpaceRect)) {
        rectLeft.origin.y = CGRectGetMinY(leftVirtualSpaceRect);
        rectMiddle.origin.y = CGRectGetMinY(rightVirtualSpaceRect);
        rectRight.origin.y = CGRectGetMaxY(rectMiddle) - vspace;
    }
    
    leftNewRect = rectLeft;
    middleNewRect = rectMiddle;
    rightNewRect = rectRight;
    
    NSMutableArray *frames = [NSMutableArray array];
    [frames addObject:[NSValue valueWithCGRect:leftNewRect]];
    [frames addObject:[NSValue valueWithCGRect:middleNewRect]];
    [frames addObject:[NSValue valueWithCGRect:rightNewRect]];
    
    return frames;

}

-(NSMutableArray *)upMiddleImageLayout
{
    NSMutableArray *frames = [NSMutableArray array];

    CGFloat layoutScale = 0.5;
    CGFloat HSpace = 20.0f;
    CGFloat contentViewsWidth = (_originSourceSize.count - 1) * HSpace;

    CGFloat topMargin = 40.0f;
    layoutScale = [self reComputeScale:topMargin HSpace:HSpace];

    for (int i = 0; i < _originSourceSize.count; i++) {

        NSValue *imageSizeValue = _originSourceSize[i];
        CGSize imageSize = imageSizeValue.CGSizeValue;

        contentViewsWidth += imageSize.width * layoutScale;
    }

    CGFloat orignX = (_contextSize.width - contentViewsWidth)/2;
    CGFloat preMaxX = orignX - HSpace;
    for (int i = 0; i < _originSourceSize.count; i++) {

        NSValue *imageSizeValue = _originSourceSize[i];
        CGSize imageSize = imageSizeValue.CGSizeValue;


        CGFloat imageWidth = imageSize.width * layoutScale;
        CGFloat imageHeight = imageSize.height * layoutScale;

        CGFloat orignY = topMargin;
        CGRect frame = CGRectMake(preMaxX + HSpace, orignY, imageWidth, imageHeight);

        [frames addObject:[NSValue valueWithCGRect:frame]];
        
        preMaxX = CGRectGetMaxX(frame);
        
    }
    
    return frames;
}

-(NSMutableArray *)twoImageLayout
{
    NSValue *upValue = _originSourceSize[0];
    CGSize upSize = upValue.CGSizeValue;
    
    
    NSValue *downValue = _originSourceSize[1];
    CGSize downSize = downValue.CGSizeValue;
    
    CGFloat vspace = 25;  //右边垂直重叠
    
    CGFloat maxAllowHeight = (_contextSize.height - 80);
    CGFloat maxHeight = upSize.height + downSize.height - vspace;
    
    CGFloat scale = 1.0;
    if (maxHeight > maxAllowHeight)
    {
        scale = maxAllowHeight / maxHeight;
        maxHeight = maxAllowHeight;
    }
    
    //先建立虚拟框
    CGFloat spaceItemWidth = MAX(upSize.width * scale, downSize.width * scale);
    
    CGRect virtualSpaceRect = CGRectMake(0, 0, spaceItemWidth, maxHeight);
    virtualSpaceRect.origin.x = (_contextSize.width - spaceItemWidth) / 2;
    virtualSpaceRect.origin.y = (_contextSize.height - maxHeight) / 2;
    
    //上面
    CGFloat upNewRectX = CGRectGetMinX(virtualSpaceRect) + (CGRectGetWidth(virtualSpaceRect) - upSize.width * scale) / 2;
    CGFloat upNewRectY = CGRectGetMinY(virtualSpaceRect);
    CGRect upNewRect = CGRectMake(upNewRectX, upNewRectY, upSize.width * scale, upSize.height * scale);

    //下面
    CGFloat downNewRectX = CGRectGetMinX(virtualSpaceRect) + (CGRectGetWidth(virtualSpaceRect) - downSize.width * scale) / 2;
    CGFloat downNewRectY = CGRectGetMaxY(upNewRect) - vspace;
    CGRect downNewRect = CGRectMake(downNewRectX, downNewRectY, downSize.width * scale, downSize.height * scale);
    

    NSMutableArray *frames = [NSMutableArray array];
    [frames addObject:[NSValue valueWithCGRect:upNewRect]];
    [frames addObject:[NSValue valueWithCGRect:downNewRect]];

    
    return frames;
}

-(CGFloat)reComputeScale:(CGFloat)topMargin HSpace:(CGFloat)HSpace
{
    CGFloat scale = 0.7;
    CGFloat maxHeight = 0.0f;
    
    CGFloat maxAllowHeight = (_contextSize.height - topMargin - 80);
    NSInteger maxHeightIndex = 0;
    
    NSInteger leftBoxMargin = 80;
    CGFloat maxAllowWidth = _contextSize.height - 2 * leftBoxMargin;
    
    for (int i = 0; i < _originSourceSize.count; i++) {
        
        NSValue *imageSizeValue = _originSourceSize[i];
        CGSize imageSize = imageSizeValue.CGSizeValue;
        
        if (imageSize.height > maxHeight) {
            maxHeight = imageSize.height;
            maxHeightIndex = i;
        }
    }
    
    scale = maxHeight / maxAllowHeight;
    
    if (maxHeight > maxAllowHeight)
    {

        NSValue *imageSizeValue = _originSourceSize[maxHeightIndex];
        CGSize imageSize = imageSizeValue.CGSizeValue;
        
        maxHeight = maxAllowHeight;
        scale = maxAllowHeight / imageSize.height;
        
        CGFloat contentViewsWidth = (_originSourceSize.count - 1) * HSpace;
        for (int i = 0; i < _originSourceSize.count; i++) {
            
            NSValue *imageSizeValue = _originSourceSize[i];
            CGSize imageSize = imageSizeValue.CGSizeValue;
            
            contentViewsWidth += imageSize.width * scale;
        }
        
        if (contentViewsWidth > maxAllowWidth) {
            scale = MIN(scale, maxAllowWidth / contentViewsWidth);
        }
    }
    else
    {
        scale = 1.0;
        
        CGFloat contentViewsWidth = (_originSourceSize.count - 1) * HSpace;
        for (int i = 0; i < _originSourceSize.count; i++) {
            
            NSValue *imageSizeValue = _originSourceSize[i];
            CGSize imageSize = imageSizeValue.CGSizeValue;
            
            contentViewsWidth += imageSize.width * scale;
        }
        
        if (contentViewsWidth > maxAllowWidth) {
            scale = MIN(scale, maxAllowWidth / contentViewsWidth);
        }
        
    }
    
    return scale;
}

@end
