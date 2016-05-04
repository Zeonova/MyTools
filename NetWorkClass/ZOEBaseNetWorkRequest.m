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
@interface ZOEBaseNetWorkRequest()
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)MBProgressHUD *mbpHUD;
@end

@implementation ZOEBaseNetWorkRequest

-(NSString *)baseURL
{
#if DEBUG
    NSLog(@"begin DEBUG");
    return @"http://192.168.1.236";
#endif
    return @"http://licai.qiushibao.cn";
}

+(void)load
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
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
    [self mbpHUD];
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
    [self.manager POST:[self requestURL] parameters:[self requestParameters] progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   self.successBlock(task,responseObject);
                   [self hudHideAndCleadBlock];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   self.failureBlock(task,error);
                   [self hudHideAndCleadBlock];
               }];
}
-(void)startGET
{
    [self.manager GET:[self requestURL] parameters:[self requestParameters] progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  self.successBlock(task,responseObject);
                  [self hudHideAndCleadBlock];
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  self.failureBlock(task,error);
                  [self hudHideAndCleadBlock];
                  
              }];
}
-(void)startHEAD
{
    [self.manager HEAD:[self requestURL] parameters:[self requestParameters]
               success:^(NSURLSessionDataTask * _Nonnull task) {
                   self.successBlock(task,nil);
                   [self hudHideAndCleadBlock];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   self.failureBlock(task,error);
                   [self hudHideAndCleadBlock];
               }];
}

-(void)hudHideAndCleadBlock
{
    [self blockClear];
    [self.mbpHUD hide:YES afterDelay:0.5];
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
    return nil;
}
-(NSString *)requestURL
{
    return nil;
}
-(ZOERequestMethod)ZOERequestMethod
{
    return ZOERequestMethodGet;
}

-(MBProgressHUD *)mbpHUD
{
    if (_mbpHUD == nil) {
        _mbpHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
    }
    return _mbpHUD;
}
-(AFHTTPSessionManager *)manager
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
        
    });
    return _shareManager;
}
-(void)dealloc
{
#if DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
}
@end
