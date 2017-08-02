//
//  MFSmallCellSizeCacheManger.h
//  BloomBeauty
//
//  Created by EEKA on 16/10/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MFSmallCellSizeCacheMangerCompletionBlock)(NSString *url);

@interface MFSmallCellSizeCacheManger : NSObject
{
    NSMutableDictionary *_cellSizeCaches;
}

+ (instancetype)sharedManager;
- (CGSize)smallItemsSizeForUrl:(NSString *)url
             blockWithSuccess:(MFSmallCellSizeCacheMangerCompletionBlock)success
                      failure:(MFSmallCellSizeCacheMangerCompletionBlock)failure;

@end
