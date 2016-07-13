//
//  ZOENetWorkManager.m
//  TestNetworkForOperation
//
//  Created by zhangwei on 16/7/13.
//  Copyright © 2016年 Mr.Z. All rights reserved.
//

#import "ZOENetWorkManager.h"

@implementation ZOENetWorkManager{
    NSOperationQueue *_queue;
}
+(instancetype)sharedManger
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
-(instancetype)init
{
    if (self = [super init]) {
        _queue = [NSOperationQueue new];
    }
    return self;
}
-(void)addOperationWithApi:(ZOEBaseNetWorkRequest *)requestApi
                completion:(ZOE_successBlock)completion
                   failure:(ZOE_failureBlock)failer
{
    //TODO: 检查token
    BOOL token = NO;
    if (!token) {
//        [_queue setSuspended:YES];
    }
    
    ZOEOperation *op = [ZOEOperation operationWithApi:requestApi completion:completion failure:failer];
    [_queue addOperation:op];
}

@end
