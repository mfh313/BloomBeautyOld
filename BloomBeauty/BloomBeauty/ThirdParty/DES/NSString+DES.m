//
//  NSString+DES.m
//  UMC
//
//  Created by 悦讯科技  on 13-7-23.
//  Copyright (c) 2013年 shihui. All rights reserved.
//


#import "NSString+DES.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "GTMDefines.h"


#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <UIKit/UIKit.h>

@implementation NSString (DES)

// 字符串加密
- (NSString *)stringWithStrToDES
{
    return [[self class] encrypt:self encryptOrDecrypt:kCCEncrypt key:KEY];
}

// 字符串解密
- (NSString *)stringWithDESToStr
{
    return [[self class] encrypt:self encryptOrDecrypt:kCCDecrypt key:KEY];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt)
    {
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [decryptData length];
        vplainText = [decryptData bytes];
    }
    else
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [key UTF8String];
    
    ccStatus = CCCrypt(encryptOperation,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeDES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
        
    }
    else
    {
        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:data];
    }
    return result;
}



+ (NSString *)encryptWithText:(NSString *)sText
{
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:@"11223344"];
}

+ (NSString *)decryptWithText:(NSString *)sText
{
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:@"11223344"];
}


+ (NSString *)ecodeString:(NSString *)inputVal
{
    NSString *result =  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)inputVal, NULL, (CFStringRef)@"+", kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)decodeString:(NSString*)encodedString

{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


 


@end
