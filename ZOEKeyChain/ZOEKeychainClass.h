//
//  ZOEKeychainClass.h
//  TestKeychain
//
//  Created by zhangwei on 16/5/3.
//  Copyright © 2016年 qiushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZOEKeychainClass : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
