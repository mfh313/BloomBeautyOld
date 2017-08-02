//
//  MFStylistMatchItemView.m
//  BloomBeauty
//
//  Created by EEKA on 16/6/17.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFStylistMatchItemView.h"
#import "StylistMatchItem.h"
#import "MFStylistMatchItemCoverView.h"

@interface MFStylistMatchItemView ()
{
    __weak IBOutlet MFUILongPressImageView *_imageview;
    __weak IBOutlet MFStylistMatchItemCoverView *_infoView;
}

@end

@implementation MFStylistMatchItemView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _imageview.contentMode = UIViewContentModeCenter;
    [_imageview setShowActivityIndicatorView:YES];
    [_imageview setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

-(void)setStylistMatchItem:(StylistMatchItem *)item
{
    [_infoView setStylistMatchItem:item];
    
    [_imageview sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                          placeholderImage:MFImage(@"zbl55")
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                     dispatch_main_async_safe(^{
                                         if (image) {
                                             _imageview.contentMode = UIViewContentModeScaleAspectFit;
                                         }
                                     });
                                 }];

}

@end
