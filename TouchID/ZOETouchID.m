//
//  NETWork.m
//  TestURL
//
//  Created by 疯兔 on 15/5/25.
//  Copyright (c) 2015年 ZW. All rights reserved.
//

#import "ZOETouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>
NSString *const userNameKey = @"userName";
NSString *const userPWDKey  = @"userPWD";
@implementation ZOETouchID

+(instancetype)sharedManager
{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance;
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}
-(void)saveUserinfoForKey:(NSString *)key withObject:(NSString *)object
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:object forKey: key];
    [user synchronize];
}
-(NSString *)loadUserinfoForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey: key];
}
#pragma mark - 指纹识别
-(void)localAuthenticationCompletion:(completionBlock)callBack
{
    BOOL Local;
    Local = [UIDevice currentDevice].systemVersion.floatValue >= 8.0;
    if (Local == NO) return;
    LAContext *context = [[LAContext alloc]init];
    [context setLocalizedFallbackTitle:@"输入手势密码"];
    NSLog(@"%@",context.localizedFallbackTitle);
    Local = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    if (Local == NO) return;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:self.localAuthenticationString reply:^(BOOL success, NSError *error) {
        callBack(success,error);
    }];
}
-(NSString *)localAuthenticationString
{
    if (_localAuthenticationString == nil) {
        _localAuthenticationString = @"通过Home键验证已有手机指纹";
    }
    return _localAuthenticationString;
}

@end
