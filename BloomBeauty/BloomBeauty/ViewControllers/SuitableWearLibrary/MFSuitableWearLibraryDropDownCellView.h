//
//  MFSuitableWearLibraryDropDownCellView.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFSuitableWearLibraryDropDownCellViewDelegate <NSObject>

-(void)onClickDropDownCellView:(NSIndexPath *)indexPath;

@end

@interface MFSuitableWearLibraryDropDownCellView : MFUIView

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<MFSuitableWearLibraryDropDownCellViewDelegate> m_delegate;

-(void)setCellViewSelected:(BOOL)selected;
-(void)setBrandTitle:(NSString *)title;

@end
