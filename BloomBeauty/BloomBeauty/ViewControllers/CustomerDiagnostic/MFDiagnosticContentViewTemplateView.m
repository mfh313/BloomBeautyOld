//
//  MFDiagnosticContentViewTemplateView.m
//  BloomBeauty
//
//  Created by EEKA on 16/4/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFDiagnosticContentViewTemplateView.h"
#import "MFDiagnosticItemSelectView.h"

@implementation MFDiagnosticContentViewTemplateView

-(id)initWithDiagnosticDataItem:(MFDiagnosticQuestionDataItem *)oDataItem
{
    self = [super initWithDiagnosticDataItem:oDataItem];
    if (self) {
        _diagnosticDataItemViewArray = [NSMutableArray array];
        
        _imageGridView = [[MFImageGridView alloc] init];
        _imageGridView.m_arrOfViews = [NSMutableArray array];
        [self addSubview:_imageGridView];
        
        for (int i = 0; i < 10; i++) {
            MFDiagnosticItemSelectView *contentSelectView = [self templateGridItemView];
            contentSelectView.hidden = YES;
            [_diagnosticDataItemViewArray addObject:contentSelectView];
        }
        
        [self initViewsWithQuestionDataItem:oDataItem];
        
    }
    
    return self;
}

-(MFDiagnosticItemSelectView *)templateGridItemView
{
    MFDiagnosticItemSelectView *contentSelectView = [[MFDiagnosticItemSelectView alloc] initWithFrame:CGRectZero];
    
    MFDiagnosticImageView *imageSelectView = [contentSelectView imageSelectView];
    imageSelectView.delegate = self;
    
    MFDiagnosticTextSelectView *textSelectView = [contentSelectView textSelectView];
    textSelectView.delegate = self;
    
    [_imageGridView addSubview:contentSelectView];
    
    return contentSelectView;
}


-(void)initViewsWithQuestionDataItem:(MFDiagnosticQuestionDataItem *)oDataItem
{
    _oDataItem = oDataItem;
    
    int columnCount =  (int)_oDataItem.columnCount;
    CGFloat stepX = _oDataItem.itemHorizontalSpace;
    CGFloat stepY = _oDataItem.itemVerticalSpace;
    
    for (UIView *view in _diagnosticDataItemViewArray) {
        [view setHidden:YES];
    }
    
    [_imageGridView.m_arrOfViews removeAllObjects];
    for (NSUInteger i = 0; i < _oDataItem.diagnosticContentArray.count; i++)
    {
        MFDiagnosticItemSelectView *contentSelectView = nil;
        if (i < _diagnosticDataItemViewArray.count) {
            contentSelectView = _diagnosticDataItemViewArray[i];
        }
        else
        {
            contentSelectView = [self templateGridItemView];
            [_diagnosticDataItemViewArray addObject:contentSelectView];
        }
        
        [_imageGridView.m_arrOfViews addObject:contentSelectView];
    }
    
    _imageGridView.m_columnCount = columnCount;
    _imageGridView.m_stepX = stepX;
    _imageGridView.m_stepY = stepY;
    
    [self setNeedsLayout];
}


-(void)layoutSubviews
{
    _imageGridView.backgroundColor = [UIColor whiteColor];
    
    int columnCount =  (int)_oDataItem.columnCount;
    NSInteger itemHeight =  _oDataItem.contentImageHeight;
    NSInteger stepX = _oDataItem.itemHorizontalSpace;
    NSInteger stepY = _oDataItem.itemVerticalSpace;
    
    for (NSUInteger i = 0; i < _oDataItem.diagnosticContentArray.count; i++)
    {
        MFDiagnosticItemSelectView *contentSelectView = _imageGridView.m_arrOfViews[i];
        
        contentSelectView.hidden = NO;
        
        [contentSelectView setType:_oDataItem.itemType];
        MFDiagnosticQuestionContentDataItem *contentModel = _oDataItem.diagnosticContentArray[i];
        
        NSString *itemType = _oDataItem.itemType;
        
        if ([itemType isEqualToString:MFDiagnosticTypeKeyImage]) {
            
            CGFloat maxItemWidth = CGRectGetWidth(self.bounds) / columnCount - stepX;
            NSInteger realWidth = MIN(_oDataItem.itemWidth, maxItemWidth);
            contentSelectView.frame = CGRectMake(0, 0, realWidth, _oDataItem.itemHeight);
            
            MFDiagnosticImageView *imageSelectView = [contentSelectView imageSelectView];
            imageSelectView.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [imageSelectView setImageWidthLayout:_oDataItem.contentImageWidth height:_oDataItem.contentImageHeight];
            [imageSelectView setImageUrl:contentModel.imageUrl contentDescription:contentModel.contentDescription];
            
            BOOL isSelected = contentModel.isSelected;
            [imageSelectView setSelected:isSelected];
            
        }
        else if ([itemType isEqualToString:MFDiagnosticTypeKeyString])
        {
            contentSelectView.frame = CGRectMake(0, 0, _oDataItem.itemWidth, _oDataItem.itemHeight);
            
            MFDiagnosticTextSelectView *textSelectView = [contentSelectView textSelectView];
            textSelectView.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [textSelectView setTextContent:contentModel.contentDescription];
            
            BOOL isSelected = contentModel.isSelected;
            [textSelectView setSelected:isSelected];
            if (contentModel.desNormalHexColor || contentModel.desSelectedHexColor) {
                [textSelectView setTextSelected:isSelected
                                 normalHexColor:contentModel.desNormalHexColor
                               selectedHexColor:contentModel.desSelectedHexColor];
            }
            else
            {
                [textSelectView setSelected:isSelected];
            }
        }
    }
    
    _imageGridView.frame = self.bounds;
    [_imageGridView layoutSubviews];
    
}

+(float)heightForQuestionDataItem:(MFDiagnosticQuestionDataItem *)oDataItem
{
    CGFloat stepY = oDataItem.itemVerticalSpace;
    int viewsCount = (int)oDataItem.diagnosticContentArray.count;
    int columms =  (int)oDataItem.columnCount;
    CGFloat itemHeight =  (int)oDataItem.itemHeight;
    CGFloat height = [MFImageGridView getLayoutHeightForViews:viewsCount columms:columms unitHeight:itemHeight + stepY] - stepY;
    
    return height;
}

@end
