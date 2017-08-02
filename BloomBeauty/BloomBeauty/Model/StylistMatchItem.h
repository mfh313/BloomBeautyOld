//
//  StylistMatchItem.h
//  BloomBeauty
//
//  Created by EEKA on 16/6/12.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString * const stylistMatchItemName;
FOUNDATION_EXPORT NSString * const stylistMatchItemCode;

@interface StylistMatchItem : NSObject

@property (nonatomic,copy) NSString *codeA;
@property (nonatomic,copy) NSString *codeB;
@property (nonatomic,copy) NSString *codeC;
@property (nonatomic,copy) NSString *nameA;
@property (nonatomic,copy) NSString *nameB;
@property (nonatomic,copy) NSString *nameC;
@property (nonatomic,copy) NSString *hasOccasion;
@property (nonatomic,copy) NSString *occasion;
@property (nonatomic,copy) NSString *matachWay;
@property (nonatomic,copy) NSString *pictureUrl;
@property (nonatomic,copy) NSString *smallPictureUrl;
@property (nonatomic,strong) NSMutableArray *codesInfo;

-(void)makeCodesInfo;

@end
