//
//  ZOEBaseNetWorkRequest.h
//  TestAPIModel
//
//  Created by zhangwei on 16/4/28.
//  Copyright © 2016年 qiushi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger , ZOERequestMethod) {
    ZOERequestMethodGet = 0,
    ZOERequestMethodPost,
    ZOERequestMethodHead,
    //以下未实现
    ZOERequestMethodPut __attribute__((unavailable("warning"))),
    ZOERequestMethodDelete __attribute__((unavailable("warning"))),
    ZOERequestMethodPatch __attribute__((unavailable("warning")))
};
typedef void (^ZOE_successBlock)(NSURLSessionDataTask *  dataTask,id responseObject);
typedef void (^ZOE_failureBlock)(NSURLSessionDataTask *  dataTask,NSError * error);

@interface ZOEBaseNetWorkRequest : NSObject
@property(nonatomic,copy)ZOE_successBlock successBlock;
@property(nonatomic,copy)ZOE_failureBlock failureBlock;


@property(nonatomic,strong)NSDictionary *parameters;
@property(nonatomic,assign)BOOL hiddenHUD;
-(void)startWithCompletionBlockWithSuccess:(ZOE_successBlock)success
                                   failure:(ZOE_failureBlock)failure;
/**
 *  默认为ZOERequestMethodPost
 *
 *  @return 请求的类型
 */
-(ZOERequestMethod)ZOERequestMethod;

/// 建议头位携带/
-(NSString *)requestURL;
/**
 *  如非必要，不要在子类修改baseURL
 *
 *  @return 基本域名，建议末尾不携带/
 */
-(NSString *)baseURL;


-(BOOL)ignoreErrors;

-(void)hudHideAndCleadBlockWithResponse:(id)responseObject;
@end
