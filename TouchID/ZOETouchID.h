//
//  NETWork.h
//  TestURL
//
//  Created by 疯兔 on 15/5/25.
//  Copyright (c) 2015年 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const userNameKey;
extern NSString *const userPWDKey;
typedef void(^completionBlock)(BOOL success,NSError *error);
@interface ZOETouchID : NSObject
@property(strong,nonatomic)NSString *localAuthenticationString;
+ (instancetype)sharedManager;
- (void)saveUserinfoForKey:(NSString *)key withObject:(NSString *)object;
- (NSString *)loadUserinfoForKey:(NSString *)key;
/**
 *  指纹识别
 *
 *  @param callBack 指纹识别是否成功以及错误信息
 */
- (void)localAuthenticationCompletion:(completionBlock)callBack;
@end
