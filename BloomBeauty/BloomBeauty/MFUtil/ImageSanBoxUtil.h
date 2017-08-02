//
//  SOXMapUtil.h
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import <Foundation/Foundation.h> 

#define SANBOX_CUSTOMER_PIC_PRE @"customer_"

@interface ImageSanBoxUtil : NSObject


+ (ImageSanBoxUtil *)sharedUtil; 
- (UIImage*)getImage:(NSString*)userDir fileName:(NSString*)fileName;
- (BOOL)setImage:(NSString*)userDir fileName:fileName image:(UIImage*)image;
- (UIImage*)getImageById:(NSString*)userDir objectId:(NSString*)objectId;
- (BOOL)setImageById:(NSString*)userDir objectId:(NSString*)objectId image:(UIImage*)image;

- (UIImage*)getImageByLoginUser:(NSString*)objectId;
- (BOOL)setImageByLoginUser:(NSString*)objectId image:(UIImage*)image;

- (NSString *)getCurrentUserDir;
- (void)setCurrentUserDir:(NSString *)str;
@end
