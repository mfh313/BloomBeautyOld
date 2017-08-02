//
//  MFCustomerConsumptionRecordItemContentView.m
//  BloomBeauty
//
//  Created by EEKA on 16/4/22.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerConsumptionRecordItemContentView.h"
#import "PosVoucherDetail.h"

@interface MFCustomerConsumptionRecordItemContentView ()
{
    
    __weak IBOutlet UILabel *_itemCodeLabel;
    
    __weak IBOutlet UILabel *_categoryNameLabel;
    
    __weak IBOutlet UILabel *_colorNameLabel;
    
    __weak IBOutlet UILabel *_listPriceLabel;
    
    __weak IBOutlet UILabel *_quantityLabel;
    
    __weak IBOutlet UIImageView *_imageView;
    
    PosVoucherDetail *_detail;
}

@end

@implementation MFCustomerConsumptionRecordItemContentView
@synthesize m_delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    _categoryNameLabel.textColor = MFLightTextColor;
    _colorNameLabel.textColor = MFLightTextColor;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)setPosVoucherDetail:(PosVoucherDetail *)detail
{
    _detail = detail;
    
    _itemCodeLabel.text = [NSString stringWithFormat:@"款号： %@",detail.itemCode];
    _categoryNameLabel.text = [NSString stringWithFormat:@"品类： %@",detail.categoryName];
    _colorNameLabel.text = [NSString stringWithFormat:@"颜色： %@",detail.colorName];
    _listPriceLabel.text = [NSString stringWithFormat:@"%@",detail.listPrice];
    _quantityLabel.text = [NSString stringWithFormat:@"%@",detail.quantity];
    
    NSURL *imageUrl = [NSURL URLWithString:detail.smallItemUrl];
    [_imageView sd_setImageWithURL:imageUrl placeholderImage:MFImage(@"zbl55") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_main_async_safe(^{
            if (image) {
                _imageView.image = image;
            }
        });
    }];
}

- (IBAction)onClickRecordDetail:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickConsumptionRecordItem:detail:)]) {
        [self.m_delegate onClickConsumptionRecordItem:self detail:_detail];
    }
}



@end
