//
//  MFImageSaveHelper.m
//  BloomBeauty
//
//  Created by EEKA on 16/9/26.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFImageSaveHelper.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface MFImageSaveHelper () {
    ALAssetsLibrary * assetsLibrary_;
    NSMutableArray  * photoURLs_;
}

@end


@implementation MFImageSaveHelper

- (ALAssetsLibrary *)assetsLibrary
{
    if (assetsLibrary_) {
        return assetsLibrary_;
    }
    assetsLibrary_ = [[ALAssetsLibrary alloc] init];
    return assetsLibrary_;
}

-(void)saveImage:(UIImage *)image
{
    void (^completion)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"%s: Write the image data to the assets library (camera roll): %@",
                  __PRETTY_FUNCTION__, [error localizedDescription]);
        }
        
        
    };
    
    void (^failure)(NSError *) = ^(NSError *error) {
        if (error) NSLog(@"%s: Failed to add the asset to the custom photo album: %@",
                         __PRETTY_FUNCTION__, [error localizedDescription]);
    };
    
    [[self assetsLibrary] saveImage:image toAlbum:@"装扮灵" completion:completion failure:failure];
}

@end

