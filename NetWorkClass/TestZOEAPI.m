//
//  TestZOEAPI.m
//  TestAPIModel
//
//  Created by zhangwei on 16/4/29.
//  Copyright © 2016年 qiushi. All rights reserved.
//

#import "TestZOEAPI.h"

@implementation TestZOEAPI
-(NSDictionary *)requestParameters
{
    return nil;
}
-(ZOERequestMethod)ZOERequestMethod
{
    return ZOERequestMethodGet;
}
-(NSString *)requestURL
{
    return @"/getToken";
}
-(void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
@end
