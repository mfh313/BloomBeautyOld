//
//  MFSelectGuideView.h
//  装扮灵
//
//  Created by Administrator on 15/10/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MFSelectGuideViewDelegate <NSObject>

-(void)didSelectedEmployee:(BBEmployeeInfo *)employee;

@end


@class BBEmployeeInfo;
@interface MFSelectGuideView : MFUIView
{
    NSString *_selectedEmployeeId;
}
@property (nonatomic,strong) NSString *selectedEmployeeId;
@property (nonatomic,strong) BBEmployeeInfo *selectedEmployeeInfo;
@property (nonatomic,weak) id<MFSelectGuideViewDelegate> delegate;

-(void)queryEmployee:(NSNumber *)entityId;

@end
