//
//  ZOEBaseNetWorkRequest.m
//  TestAPIModel
//
//  Created by zhangwei on 16/4/28.
//  Copyright © 2016年 qiushi. All rights reserved.
//

#import "ZOEBaseNetWorkRequest.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

#import "ZOEBaseNetWorkRequest+Encryption.h"

#import "XcodeColorLogTools.h"

@interface ZOEBaseNetWorkRequest()
@property(nonatomic,strong)AFHTTPSessionManager *baseManager;
@property(nonatomic,strong)MBProgressHUD *mbpHUD;
@end
@implementation ZOEBaseNetWorkRequest

-(NSString *)baseURL
{
    return nil;
}

+(void)load
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            if ([UIApplication sharedApplication].keyWindow == nil) {
                return;
            }
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.labelText = @"失去网络连接";
            [hud setMode:MBProgressHUDModeText];
            [hud setYOffset:120];
            [hud hide:YES afterDelay:0.5];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
-(void)start
{

    if (self.hiddenHUD == NO) {
        [self mbpHUD];
    }
    switch ([self ZOERequestMethod]) {
        case ZOERequestMethodPost:
            [self startPOST];
            break;
        case ZOERequestMethodHead:
            [self startHEAD];
            break;
        default:
            [self startGET];
            break;
    }
}
-(void)startPOST
{
    [self.baseManager POST:[self requestURL] parameters:self.parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                   self.successBlock(task,responseObject);
                   [self hudHideAndCleadBlockWithResponse:responseObject];

               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   self.failureBlock(task,error);
                   [self hudHideAndCleadBlockWithResponse:nil];
               }];
}
-(void)startGET
{
    [self.baseManager GET:[self requestURL] parameters:self.parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  self.successBlock(task,responseObject);
                  [self hudHideAndCleadBlockWithResponse:responseObject];
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  self.failureBlock(task,error);
                  [self hudHideAndCleadBlockWithResponse:nil];
                  
              }];
}
-(void)startHEAD
{
    [self.baseManager HEAD:[self requestURL] parameters:self.parameters
               success:^(NSURLSessionDataTask * _Nonnull task) {
                   self.successBlock(task,nil);
                   [self hudHideAndCleadBlockWithResponse:nil];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   self.failureBlock(task,error);
                   [self hudHideAndCleadBlockWithResponse:nil];
               }];
}


-(void)hudHideAndCleadBlockWithResponse:(id)responseObject
{
    [self blockClear];
    [_mbpHUD hide:YES afterDelay:1.0];
}
-(void)startWithCompletionBlockWithSuccess:(ZOE_successBlock)success
                                    failure:(ZOE_failureBlock)failure
{
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}
-(void)setCompletionBlockWithSuccess:(ZOE_successBlock)success
                              failure:(ZOE_failureBlock)failure
{
    self.successBlock = success;
    self.failureBlock = failure;
}
-(void)blockClear
{
    _successBlock = nil;
    _failureBlock = nil;
}

-(NSDictionary *)requestParameters
{
    if (self.parameters) {
        return  self.parameters;
    }
    return nil;
}
-(NSString *)requestURL
{
    return nil;
}
-(ZOERequestMethod)ZOERequestMethod
{
    return ZOERequestMethodPost;
}

-(MBProgressHUD *)mbpHUD
{
    if (_mbpHUD == nil) {
        _mbpHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    return _mbpHUD;
}
-(AFHTTPSessionManager *)baseManager
{
    static AFHTTPSessionManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[self baseURL]]];
        NSMutableSet *newSet = [NSMutableSet set];
        newSet.set = _shareManager.responseSerializer.acceptableContentTypes;
        [newSet addObject:@"text/plain"];
        [newSet addObject:@"text/html"];
        [newSet addObject:@"application/pdf"];
        _shareManager.responseSerializer.acceptableContentTypes = newSet;
        [_shareManager.requestSerializer setTimeoutInterval:10];
    });
    return _shareManager;
}
-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
-(BOOL)hiddenHUD
{
    return YES;
}
-(BOOL)ignoreErrors
{
    return NO;
}
-(void)dealloc
{
#if DEBUG
    ZLogLightYellow(@"%@%@|%s|",self.baseURL, self.requestURL,__FUNCTION__);
#endif
}
@end
