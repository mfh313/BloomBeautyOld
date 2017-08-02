//
//  MFLoginCenter.m
//  装扮灵
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "CKRadialMenuManager.h"
#import "FileManager.h"
#import "MFSuitableWearLibraryViewController.h"
#import "MFSalingProdouctViewController.h"
#import "MFFavoritesMainViewController.h"
#import "MFCustomerDiagnosticReportViewController.h"


@implementation CKRadialMenuManager

+ (CKRadialMenuManager *)sharedManager
{
    static CKRadialMenuManager *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        [sharedObject initMenu:MFAppWindow];
    });
    
    return sharedObject;
}

- (void)initMenu:(UIView*)view
{
    self.menu = [[CKRadialMenu alloc] initWithFrame:CGRectMake(view.frame.size.width - 100,view.frame.size.height - 150, 50, 50)];
    _menu.delegate = self;
   
    [_menu addPopoutView:[CKRadialMenu createCKRadialMenuBtn:@"Favourites.png"] withIndentifier:@"favorite"];
    [_menu addPopoutView:[CKRadialMenu createCKRadialMenuBtn:@"report_icon.png"] withIndentifier:@"diagnosticReport"];
    [_menu addPopoutView:[CKRadialMenu createCKRadialMenuBtn:@"fit.png"] withIndentifier:@"suitable"];
   
}

- (void)showMenu 
{
    [MFAppWindow addSubview:self.menu];
}

- (void)hiddenMenu
{
    [_menu retract];
    [self.menu removeFromSuperview];
}

-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier
{
    if([identifier isEqualToString:@"favorite"])
    {
        MFFavoritesMainViewController *con = [BloomBeautyFavorites instantiateViewControllerWithIdentifier:@"MFFavoritesMainViewController"];
        [self.nowNav pushViewController:con animated:YES];
        
    }else if([identifier isEqualToString:@"suitable"])
    {
        MFSuitableWearLibraryViewController *con = [BBSuitableWearStoryBoard instantiateViewControllerWithIdentifier:@"MFSuitableWearLibraryViewController"];
        [self.nowNav pushViewController:con animated:YES];
        
    }else if([identifier isEqualToString:@"diagnosticReport"])
    {
        UIStoryboard *storyBoard = BBCreateStoryBoard;
        MFCustomerDiagnosticReportViewController *diagnosticReport = [storyBoard instantiateViewControllerWithIdentifier:@"MFCustomerDiagnosticReportViewController"];
        diagnosticReport.diagnosisResultId = [MFLoginCenter sharedCenter].currentCustomerInfo.lastDiagnosisResultId;
        diagnosticReport.diagnosticReportCustomerInfo = [MFLoginCenter sharedCenter].currentCustomerInfo;
        [self.nowNav pushViewController:diagnosticReport animated:YES];
    }
}

@end
