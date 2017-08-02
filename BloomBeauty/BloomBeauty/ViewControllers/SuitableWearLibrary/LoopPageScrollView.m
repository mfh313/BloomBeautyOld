//
//  LoopPageScrollView.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/24.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "LoopPageScrollView.h"

@implementation LoopPageScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        m_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        m_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        m_scrollView.delegate = self;
        m_scrollView.backgroundColor = [UIColor whiteColor];
        m_scrollView.pagingEnabled = YES;
        [self addSubview:m_scrollView];
        
        m_curPageNum = 0;
        
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 50, CGRectGetWidth(self.bounds), 30)];
        _bottomLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _bottomLabel.textColor = [UIColor blackColor];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomLabel];
        
    }
    
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(m_scrollView.frame);
    m_curPageNum = (scrollView.contentOffset.x + width * 0.5) / width;
    
    NSInteger viewsCount = 0;
    if ([self.m_delegate respondsToSelector:@selector(totalNumOfPage)]) {
        viewsCount = [self.m_delegate totalNumOfPage];
        _bottomLabel.text = [NSString stringWithFormat:@"第 %d / %lu 组",m_curPageNum+1,viewsCount];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    CGFloat width = CGRectGetWidth(m_scrollView.frame);
//    m_curPageNum = (scrollView.contentOffset.x + width * 0.5) / width;
//    
//    NSInteger viewsCount = 0;
//    if ([self.m_delegate respondsToSelector:@selector(totalNumOfPage)]) {
//        viewsCount = [self.m_delegate totalNumOfPage];
//        _bottomLabel.text = [NSString stringWithFormat:@"(%d / %lu)",m_curPageNum+1,viewsCount];
//    }
}

- (int)getRealPageNum:(int)number
{
    return number;
}

- (void)changeToNextPage
{
    
}

- (void)reloadData
{
    NSInteger viewsCount = 0;
    NSInteger pageCount = 0;
    if ([self.m_delegate respondsToSelector:@selector(totalNumOfPage)]) {
        viewsCount = [self.m_delegate totalNumOfPage];
        //TODO:性能优化
        /*
        if (viewsCount > 2) {
            pageCount = 3;
        }
         */
        
        pageCount = viewsCount;
    }
    
    m_scrollView.contentSize = CGSizeMake(pageCount * CGRectGetWidth(m_scrollView.bounds), CGRectGetHeight(m_scrollView.bounds));
    [m_scrollView removeAllSubViews];
    
    for (int i = 0; i < viewsCount; i++) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(m_scrollView.bounds), CGRectGetHeight(m_scrollView.bounds));
        UIView *subView = [[UIView alloc] initWithFrame:CGRectOffset(frame, i * CGRectGetWidth(m_scrollView.bounds), 0)];
        
        if ([self.m_delegate respondsToSelector:@selector(viewForPage:pageNum:)]) {
            subView  = [self.m_delegate viewForPage:subView pageNum:i];
        }
        
        [m_scrollView addSubview:subView];
    }
    
    _bottomLabel.text = [NSString stringWithFormat:@"第 %d / %lu 组",m_curPageNum+1,viewsCount];
    
    [m_scrollView setContentOffset:CGPointZero animated:NO];
    
}

- (void)layoutSubviews
{
    
}

@end
