//
//  MFCommonUtil.h
//  MFH
//
//  Created by 马方华 on 15/7/24.
//  Copyright (c) 2015年 马方华. All rights reserved.
//

//头像大小标准 82*82

#define MFKeyWindow [[UIApplication sharedApplication] keyWindow]
#define MFAppWindow [[UIApplication sharedApplication].delegate window]
#define MFImage(x) [UIImage imageNamed:x]
#define MFColor(r,g,b)    [UIColor colorWithRed:(double)r green:(double)g blue:(double)b alpha:1.0]
#define MFRGB(r,g,b)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:1.0]
#define MFRGBa(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]
#define MFPink  MFColor(219,36,131)

#define MFOnePixHeigtht 1/[UIScreen mainScreen].scale

#define MFImageStretch(image,width,height) [image stretchableImageWithLeftCapWidth:(float)width topCapHeight:(float)height]

#define MFImageStretchCenter(image) [MFImage(image) stretchableImageWithLeftCapWidth:MFImage(image).size.width/2 topCapHeight:MFImage(image).size.height/2]

#define MFStoryBoard(name) [UIStoryboard storyboardWithName:name bundle:nil]
#define BBMainStoryBoard [UIStoryboard storyboardWithName:@"BloomBeauty" bundle:nil]
#define BBCreateStoryBoard [UIStoryboard storyboardWithName:@"BloomBeauty_Create" bundle:nil]
#define BBInStoreGoodstoryBoard [UIStoryboard storyboardWithName:@"BloomBeauty_InStoreGoods" bundle:nil]
#define BBestCollocationStoryBoard [UIStoryboard storyboardWithName:@"BloomBeauty_BestCollocation" bundle:nil]
#define BBSuitableWearStoryBoard [UIStoryboard storyboardWithName:@"BloomBeauty_SuitableWearLibrary" bundle:nil]
#define BBDiagnosisHistoryStoryBoard [UIStoryboard storyboardWithName:@"BloomBeauty_DiagnosisHistory" bundle:nil]
#define BloomBeautyFavorites [UIStoryboard storyboardWithName:@"BloomBeauty_Favorites" bundle:nil]


#define BBDefaultColor [UIColor hx_colorWithHexString:@"e93871"]
#define BBDefaultBgBlackColor [UIColor hx_colorWithHexString:@"232733"]
#define BBDefaultLineColor [UIColor hx_colorWithHexString:@"e0e0e0"]
#define MFDarkTextColor MFDarkGrayColor
#define MFLightTextColor [UIColor hx_colorWithHexString:@"888888"]

#define MFDarkGrayColor [UIColor hx_colorWithHexString:@"2d2c2c"]
#define MFMiddleGrayColor [UIColor hx_colorWithHexString:@"555555"]
#define MFLightGrayColor [UIColor hx_colorWithHexString:@"aeaeae"]

#import <CoreText/CoreText.h>
#import "MFThirdPartyHeaders.h"
#import "MFUIView.h"
#import "MFOnePixLayoutConstraint.h"
#import "MFUIButton.h"
#import "MFUIImageView.h"
#import "MFObject.h"
#import "MFNavigationController.h"
#import "MFViewController.h"
#import "MFTableViewCell.h"
#import "MFUICollectionReusableView.h"
#import "MFCollectionViewCell.h"
#import "MFUIImageView.h"
#import "MFUICollectionView.h"
#import "MFUITableView.h"
#import "MFUILongPressImageView.h"
#import "MFUnderLineButton.h"
#import "MFSwitch.h"
#import "MFDateUtil.h"
#import "MFHTTPUtil.h"
#import "MFApiUtil.h"
#import "MFUIWindow.h"
#import "MFRoundTextField.h"
#import "MFPageControl.h"
#import "UIViewController+MFNavigationRightView.h"
#import "UIViewController+FullScreen.h"
#import "MFCategorys.h"
#import "MFSelecedButton.h"

#import "MFCommodityUrlHelper.h"
#import "CommonUtil.h"
#import "MFFileUtil.h"
#import "UserDefaultsUtil.h"
#import "PlistUtil.h"
#import "ImageSanBoxUtil.h"
#import "MFDatabaseUtil.h"

#import "WCActionSheet.h"


