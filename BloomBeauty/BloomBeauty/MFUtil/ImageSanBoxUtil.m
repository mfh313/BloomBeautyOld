//
//  SOXMapUtil.m
//  SoxFrame
//
//  Created by jason yang on 13-5-27.
//
//

#import "ImageSanBoxUtil.h"
#import "FileManager.h"

@interface ImageSanBoxUtil ()
{
    NSString *currentUserDir ;
}
@end

@implementation ImageSanBoxUtil


+ (ImageSanBoxUtil *)sharedUtil
{
    static ImageSanBoxUtil *imageSanBoxUtil = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        imageSanBoxUtil = [[self alloc] init];
    });
    return imageSanBoxUtil;
}



- (UIImage*)getImage:(NSString*)userDir fileName:(NSString*)fileName
{
    NSString *newFileName = [NSString stringWithFormat:@"%@%@",SANBOX_CUSTOMER_PIC_PRE,fileName];
    NSString *imageSanBoxUrl = [MFFileUtil getSanboxPath:userDir fileName:newFileName];
    UIImage *image = [UIImage imageWithContentsOfFile:imageSanBoxUrl];
    return image;
}

- (NSString *)getCurrentUserDir
{
    if(currentUserDir != nil)
    {
        return currentUserDir;
    }
    return nil;
}

- (void)setCurrentUserDir:(NSString *)str
{
     currentUserDir = str;
}

- (UIImage*)getImageByLoginUser:(NSString*)objectId
{
    NSString *fileName = [NSString stringWithFormat:@"%@.png",objectId];
    NSString *userDir = currentUserDir;
    return [self getImage:userDir fileName:fileName];
}


- (UIImage*)getImageById:(NSString*)userDir objectId:(NSString*)objectId
{
    NSString *fileName = [NSString stringWithFormat:@"%@.png",objectId];
    return [self getImage:userDir fileName:fileName];
}


- (BOOL)setImageByLoginUser:(NSString*)objectId image:(UIImage*)image
{
    NSString *fileName = [NSString stringWithFormat:@"%@.png",objectId];
    NSString *userDir = currentUserDir; 
    return [self setImage:userDir fileName:fileName image:image];
}

- (BOOL)setImageById:(NSString*)userDir objectId:(NSString*)objectId image:(UIImage*)image
{
    NSString *fileName = [NSString stringWithFormat:@"%@.png",objectId];
    return [self setImage:userDir fileName:fileName image:image];
}

- (BOOL)setImage:(NSString*)userDir fileName:(UIImage*)fileName image:(UIImage*)image
{
    NSString *newFileName = [NSString stringWithFormat:@"%@%@",SANBOX_CUSTOMER_PIC_PRE,fileName];
    NSString *imageSanBoxUrl = [MFFileUtil getSanboxPath:userDir fileName:newFileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    // 将图片写入文件
    [imageData writeToFile:imageSanBoxUrl atomically:NO];
    return YES;
}

@end
