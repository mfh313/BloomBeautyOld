//
//  MFSuitableWearLibraryDropDownView.h
//  BloomBeauty
//
//  Created by EEKA on 16/5/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFUIView.h"

@protocol MFSuitableWearLibraryDropDownViewDataSource <NSObject>

-(NSString *)brandTitleForIndex:(NSUInteger)index;
-(BOOL)isSeletedBrandForIndex:(NSUInteger)index;
-(NSInteger)numberOfBrand;

@end

@protocol MFSuitableWearLibraryDropDownViewDelegate <NSObject>

-(void)didSelectBrandForIndex:(NSUInteger)index;

@end


@interface MFSuitableWearLibraryDropDownView : MFUIButton

@property (nonatomic,weak) id<MFSuitableWearLibraryDropDownViewDataSource> m_dataSource;
@property (nonatomic,weak) id<MFSuitableWearLibraryDropDownViewDelegate> m_delegate;

-(void)setBrandCount:(NSInteger)count;
-(void)reloadView;
@end
