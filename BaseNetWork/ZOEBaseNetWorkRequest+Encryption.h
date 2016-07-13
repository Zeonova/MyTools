//
//  ZOEBaseNetWorkRequest+Encryption.h
//  qiushi
//
//  Created by zhangwei on 16/6/2.
//  Copyright © 2016年 秋实财富. All rights reserved.
//

#import "ZOEBaseNetWorkRequest.h"
#define RESIP 192.168.1.78:8088

@interface ZOEBaseNetWorkRequest (Encryption)
/**
 *  加密
 *
 *  @param input 需要加密的String
 *  @param key   Key
 *
 *  @return 加密后的String
 */
-(NSString *) AES_encryptString:(NSString *)input withKey:(NSString *)key;
/**
 *  解密
 *
 *  @param key    Key
 *  @param string 需要解密的String
 *
 *  @return 解密后的String
 */
-(NSString *) AES_DecryptWithKey:(NSString *)key inTheString:(NSString *)string;
/**
 *  SHA1加密
 *
 *  @param input 需要加密的String
 *  @param key   Key
 *
 *  @return SHA1加密结果
 */
- (NSString *)SHA1_encryptString:(NSString *)input andKey:(NSString *)key;
@end
