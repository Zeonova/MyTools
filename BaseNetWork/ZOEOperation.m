//
//  TestOperation.m
//  TestNetworkForOperation
//
//  Created by zhangwei on 16/7/13.
//  Copyright © 2016年 Mr.Z. All rights reserved.
//

#import "ZOEOperation.h"

@implementation ZOEOperation{
    ZOE_successBlock _successBlock;
    ZOE_failureBlock _failureBlock;
    ZOEBaseNetWorkRequest *_requestApi;

}
+ (instancetype)operationWithApi:(ZOEBaseNetWorkRequest *)requestApi
                      completion:(ZOE_successBlock)completion
                         failure:(ZOE_failureBlock)failer
{


    return [[self alloc] initOperationWithApi:requestApi completion:completion failure:failer];

}

- (instancetype)initOperationWithApi:(ZOEBaseNetWorkRequest *)requestApi
                          completion:(ZOE_successBlock)completion
                             failure:(ZOE_failureBlock)failer
{
    if (self = [super init]) {
        _requestApi   = requestApi;
        _successBlock = completion;
        _failureBlock = failer;
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        NSLog(@"begin %@ %@",_requestApi,[NSThread currentThread]);
        if (self.isCancelled){
            NSLog(@"%@ isCancellde!",_requestApi);
            return;
        }
        //TODO:  在这里进行加密
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [_requestApi startWithCompletionBlockWithSuccess:^(NSURLSessionDataTask *dataTask, id responseObject) {
                _successBlock(dataTask,responseObject);
            } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                _failureBlock(dataTask,error);
            }];
        }];
    }
}
@end
