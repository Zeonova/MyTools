//
//  WLDeviceInfoModel.m
//  Wuliao
//
//  Created by 疯兔 on 15/5/28.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "WLDeviceInfoModel.h"
#import "WLProvingNetWork.h"
@implementation WLDeviceInfoModel

-(NSString *)osName
{
    return [UIDevice currentDevice].systemName;
}
-(NSString *)osVersion
{
    return [UIDevice currentDevice].systemVersion;
}
-(NSNumber *)width
{
    return @([UIScreen mainScreen].bounds.size.width);
}
-(NSNumber *)height
{
    return @([UIScreen mainScreen].bounds.size.height);
}
-(NSString *)net
{
    return [WLProvingNetWork networkType];
}
-(NSString *)language
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}
-(NSString *)country
{
    return [WLProvingNetWork getCarriercurrentCountry];
}
-(NSString *)imsi
{
    return @"testImsi";
}
-(NSString *)imei
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
-(NSString *)mac
{
    return @"testMac";
}
-(NSString *)manufacturer
{
    return @"Apple";
}
-(NSString *)model
{
    return [[UIDevice currentDevice] model];
}
#pragma mark -  description
//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"%@,%@,%@,%@",self.width,self.height,self.imei,self.model];
//}
@end
