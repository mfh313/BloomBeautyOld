//
//  MFSmallCellSizeCacheManger.m
//  BloomBeauty
//
//  Created by EEKA on 16/10/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFSmallCellSizeCacheManger.h"
#import "MFImageInfoApi.h"
#import "YTKKeyValueStore.h"

@interface MFSmallCellSizeCacheManger ()
{
    YTKKeyValueStore *m_keyValueStore;
    NSString *m_tableName;
}

@end

@implementation MFSmallCellSizeCacheManger

+ (instancetype)sharedManager
{
    static MFSmallCellSizeCacheManger *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _cellSizeCaches = [NSMutableDictionary dictionary];
        
        m_tableName = @"smallCellSize";
        m_keyValueStore = [[YTKKeyValueStore alloc] initDBWithName:@"zbl_smallCellSize.db"];
        [m_keyValueStore createTableWithName:m_tableName];
    }
    
    return self;
}

-(CGSize)smallItemsSizeForUrl:(NSString *)url
             blockWithSuccess:(MFSmallCellSizeCacheMangerCompletionBlock)success
                      failure:(MFSmallCellSizeCacheMangerCompletionBlock)failure
{
    NSDictionary *info = [_cellSizeCaches objectForKey:url];
    if (info) {
        NSInteger width = ((NSNumber *)info[@"width"]).integerValue;
        NSInteger height = ((NSNumber *)info[@"height"]).integerValue;
        return CGSizeMake(width, height);
    }

        
    NSDictionary *infoDic = [m_keyValueStore getObjectById:url fromTable:m_tableName];
    if (infoDic)
    {
        [_cellSizeCaches setObject:infoDic forKey:url];
        
        NSInteger width = ((NSNumber *)infoDic[@"width"]).integerValue;
        NSInteger height = ((NSNumber *)infoDic[@"height"]).integerValue;
        return CGSizeMake(width, height);
    }
    else
    {
        MFImageInfoApi *imageInfoAPi = [MFImageInfoApi new];
        imageInfoAPi.imageUrl = url;
        [imageInfoAPi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSMutableDictionary *responseObject = request.responseJSONObject;
            if (!responseObject) {
                return;
            }
            
            [_cellSizeCaches setObject:responseObject forKey:url];
            
            [m_keyValueStore putObject:responseObject withId:url intoTable:m_tableName];
            
            if (success) {
                success(url);
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
        }];
    }
    
    
    return CGSizeMake(468, 702);
}

@end
