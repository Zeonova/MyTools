//
//  TestOperation.h
//  TestNetworkForOperation
//
//  Created by zhangwei on 16/7/13.
//  Copyright © 2016年 Mr.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZOEBaseNetWorkRequest.h"
@interface ZOEOperation: NSOperation
+ (instancetype)operationWithApi:(ZOEBaseNetWorkRequest *)requestApi
                      completion:(ZOE_successBlock)completion
                         failure:(ZOE_failureBlock)failer;

@end
