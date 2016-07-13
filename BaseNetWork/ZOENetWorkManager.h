//
//  ZOENetWorkManager.h
//  TestNetworkForOperation
//
//  Created by zhangwei on 16/7/13.
//  Copyright © 2016年 Mr.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZOEOperation.h"
@interface ZOENetWorkManager : NSObject
+(instancetype)sharedManger;
-(void)addOperationWithApi:(ZOEBaseNetWorkRequest *)requestApi
                completion:(ZOE_successBlock)completion
                   failure:(ZOE_failureBlock)failer;
@end
