//
//  ZOEBaseNetWorkRequest+Encryption.m
//  qiushi
//
//  Created by zhangwei on 16/6/2.
//  Copyright © 2016年 秋实财富. All rights reserved.
//

#import "ZOEBaseNetWorkRequest+Encryption.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation ZOEBaseNetWorkRequest (Encryption)

-(NSString *) AES_encryptString:(NSString *)input withKey:(NSString *)key
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    //对数据进行加密
    NSData *result = [self aes_encryptData:data withKey:key];
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}
- (NSData *)aes_encryptData:(NSData *)inputData  withKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [inputData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [inputData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
-(NSString *) AES_DecryptWithKey:(NSString *)key inTheString:(NSString *)string
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:string.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [self aes_decrypt:key inTheData:data];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}


- (NSData *)aes_decrypt:(NSString *)key  inTheData:(NSData *)data //解密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
    }
    free(buffer);
    return nil;
}
- (NSString *)SHA1_encryptString:(NSString *)input andKey:(NSString *)key
{
    NSData *secretData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1,
           [secretData bytes], [secretData length],
           [clearTextData bytes], [clearTextData length],
           digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
