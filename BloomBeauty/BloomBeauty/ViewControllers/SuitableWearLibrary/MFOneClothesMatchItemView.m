//
//  MFOneClothesMatchItemView.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFOneClothesMatchItemView.h"
#import "MFCommodityDetailModel.h"
#import "MFOneClothesMatchLayoutLogic.h"

@interface MFOneClothesMatchItemView () <MFLongPressImageViewDelegate>
{
    MFOneClothesMatchLayoutLogic *m_layoutLogic;
    BOOL _revtColor;
    UIImageView *_collocationBackgroundView;
}

@end

@implementation MFOneClothesMatchItemView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _matchsViewArray = [NSMutableArray array];
        _matchsArray = [NSMutableArray array];
        _showingViews = [NSMutableArray array];
        
        _collocationBackgroundView = [[UIImageView alloc] initWithImage:MFImage(@"collocationBackground")];
        _collocationBackgroundView.frame = self.bounds;
//        [self addSubview:_collocationBackgroundView];
        
        for (int i = 0; i < 3; i++) {
            MFUILongPressImageView *imageView = [[MFUILongPressImageView alloc] initWithImage:nil];
            imageView.delegate = self;
            [self addSubview:imageView];
            
            [_matchsViewArray addObject:imageView];
        }
        
        [self sendSubviewToBack:_matchsViewArray[2]];
        
        m_layoutLogic = [MFOneClothesMatchLayoutLogic new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeColor:) name:@"ChangeColor" object:nil];
    }
    
    return self;
}

- (void)onChangeColor:(NSNotification *)note
{
    _revtColor = !_revtColor;
    
    MFUILongPressImageView *imageView0 = _matchsViewArray[0];
    MFUILongPressImageView *imageView1 = _matchsViewArray[1];
    MFUILongPressImageView *imageView2 = _matchsViewArray[2];
    
    if (_revtColor) {
        imageView0.backgroundColor = [UIColor redColor];
        imageView1.backgroundColor = [UIColor greenColor];
        imageView2.backgroundColor = [UIColor blueColor];
    }
    else
    {
        imageView0.backgroundColor = [UIColor grayColor];
        imageView1.backgroundColor = [UIColor purpleColor];
        imageView2.backgroundColor = [UIColor yellowColor];
    }
}

- (void)OnPress:(MFUILongPressImageView*)imgView
{
    if ([self.m_delegate respondsToSelector:@selector(didTapMatchDataItem:)]) {
        
        NSInteger tapIndex = [_showingViews indexOfObject:imgView];
        MFOneClothesMatchDataItem *dataItem = _matchsArray[tapIndex];
        [self.m_delegate didTapMatchDataItem:dataItem];
    }
}

-(void)setClothesMatchInfo:(NSArray *)infoArray
{
    for (UIView *subView in _matchsArray) {
        [subView setHidden:YES];
    }
    
    if (infoArray.count > 3) {
        return;
    }
    
    [_matchsArray removeAllObjects];;
    for (id object in infoArray) {
        if ([object isKindOfClass:[MFOneClothesMatchDataItem class]]) {
            [_matchsArray addObject:object];
        }
    }
    
    [_showingViews removeAllObjects];
    for (int i = 0; i < _matchsArray.count; i++) {
        MFOneClothesMatchDataItem *dataModel = _matchsArray[i];
        MFUILongPressImageView *imageView = _matchsViewArray[i];
        
        [_showingViews addObject:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:dataModel.smallItemUrl]
                     placeholderImage:MFImage(@"zbl55")
                              options:SDWebImageRetryFailed
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                dispatch_main_async_safe(^{
                    if (image) {
                        imageView.image = image;
                        [self setNeedsLayout];
                    }
                });
                                
        }];
    }

}

-(void)layoutSubviews
{
    if (_showingViews.count != _matchsArray.count) {
        return;
    }
    
    if (_showingViews.count == 2) {
        [self sendSubviewToBack:_showingViews[1]];
    }
    else
    {
        [self sendSubviewToBack:_showingViews[2]];
    }
    
    NSMutableArray *originSourceSize = [NSMutableArray array];
    for (int i = 0; i < _showingViews.count; i++) {
        MFUILongPressImageView *imageView = _showingViews[i];
        [originSourceSize addObject:[NSValue valueWithCGSize:imageView.image.size]];
    }
    
    m_layoutLogic.contextSize = self.frame.size;
    
    BOOL isUpMiddleMatch = NO;
    if (_matchsArray.count == 2)
    {
        if ([_matchsArray[0] isKindOfClass:[MFOneClothesMatchDataItem class]]
            && [_matchsArray[1] isKindOfClass:[MFOneClothesMatchDataItem class]])
        {
            MFOneClothesMatchDataItem *up = (MFOneClothesMatchDataItem *)_matchsArray[0];
            MFOneClothesMatchDataItem *middle = (MFOneClothesMatchDataItem *)_matchsArray[1];
            if ([up.itemkey isEqualToString:@"upperItem"]
                && [middle.itemkey isEqualToString:@"middleItem"]) {
                isUpMiddleMatch = YES;
            }
        }
    }
    
    m_layoutLogic.isUpMiddleMatch = isUpMiddleMatch;

    NSMutableArray *layoutFrame = [m_layoutLogic layoutFrames:originSourceSize];
    for (int i = 0; i < layoutFrame.count; i++) {
        MFUILongPressImageView *imageView = _showingViews[i];

        NSValue *rectValue = layoutFrame[i];
        imageView.frame = rectValue.CGRectValue;
        
    }
    
    [self sendSubviewToBack:_collocationBackgroundView];
}

@end
