//
//  LoopPageScrollView.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/24.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoopPageScrollViewDataSourceDelegate <NSObject>

@optional
- (void)didTapPageAtNum:(NSInteger)index;
- (void)didChangeToPage:(NSInteger)page;
- (int)totalNumOfPage;
- (UIView *)viewForPage:(UIView *)view pageNum:(NSInteger)number;
@end


@interface LoopPageScrollView : UIView <UIScrollViewDelegate>
{
    UIScrollView *m_scrollView;
    
    __weak id <LoopPageScrollViewDataSourceDelegate> m_delegate;
    int m_curPageNum;
    
    UILabel *_bottomLabel;
}

@property (nonatomic,weak) id<LoopPageScrollViewDataSourceDelegate> m_delegate;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;

- (void)reloadData;

@end
