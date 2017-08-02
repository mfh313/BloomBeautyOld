//
//  MFFavoriteButton.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/23.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFFavoriteButton.h"
#import "MFCommodityDetailModel.h"

@interface MFFavoriteButton ()
{
    __weak IBOutlet UIButton *_contenBtn;
}

@end

@implementation MFFavoriteButton
@synthesize indexPath;
@synthesize selected;
@synthesize delegate;

-(void)setSelected:(BOOL)isSelected
{
    _selected = isSelected;
    
    if (!_selected) {
        [_contenBtn setImage:MFImage(@"zbl11") forState:UIControlStateNormal];
        [_contenBtn setImage:MFImage(@"love") forState:UIControlStateHighlighted];
    }
    else
    {
        [_contenBtn setImage:MFImage(@"love") forState:UIControlStateNormal];
        [_contenBtn setImage:MFImage(@"zbl11") forState:UIControlStateHighlighted];
    }
    
}

-(void)setContentImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    [_contenBtn setImageEdgeInsets:imageEdgeInsets];
}

- (IBAction)onClickFavBtn:(id)sender
{
    if (self.clickBlock)
    {
        if (_selected) {
            [self didDeSelectedItemStyleColor];
        }
        else
        {
            [self didSelectItemStyleColor];
        }
    }
}

-(void)didSelectItemStyleColor
{
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    if([CommonUtil isNull:individualNo]){
        self.clickBlock(NO,self.itemStyleColor,@"当前未选中顾客");
        return;
    }
    
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    NSDictionary *parameters = @{@"individualNo": individualNo,
                                 @"token": token,
                                 @"commodityCode": self.itemStyleColor
                                 };
    [MFHTTPUtil POST:MFApiAddFavoriteURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *statusCode = responseObject[@"statusCode"];
         if ([statusCode isEqualToString:@"200"])
         {
             dispatch_main_async_safe(^{
                 [self setSelected:YES];
                 [[MFLoginCenter sharedCenter].currentCustomerInfo addFavoriteItemStyleColor:self.itemStyleColor];
                 self.clickBlock(YES,self.itemStyleColor,@"收藏成功");
             });
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

-(void)didDeSelectedItemStyleColor
{
    NSString *individualNo = [MFLoginCenter sharedCenter].currentCustomerInfo.individualNo;
    if([CommonUtil isNull:individualNo]){
        self.clickBlock(NO,self.itemStyleColor,@"当前未选中顾客");
        return;
    }
    
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    NSDictionary *parameters = @{@"individualNo": individualNo,
                                 @"token": token,
                                 @"commodityCode": self.itemStyleColor
                                 };
    [MFHTTPUtil POST:MFApiRemoveFavoriteURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *statusCode = responseObject[@"statusCode"];
         if ([statusCode isEqualToString:@"200"])
         {
             dispatch_main_async_safe(^{
                 [self setSelected:NO];
                 [[MFLoginCenter sharedCenter].currentCustomerInfo removeFavoriteItemStyleColor:self.itemStyleColor];
                 self.clickBlock(YES,self.itemStyleColor,@"取消收藏成功");
             });
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

-(void)setItemStyleColor:(NSString *)aitemStyleColor
{
    _itemStyleColor = aitemStyleColor;
    
    BOOL isFavorite = [_itemStyleColor MF_isFavorite];
    [self setSelected:isFavorite];
    
}

@end
