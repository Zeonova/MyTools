//
//  WLProvingNetWork.m
//  Wuliao
//
//  Created by 疯兔 on 15/5/28.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "WLProvingNetWork.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation WLProvingNetWork

+ (NSString *)networkType
{
    NSString *networkTypeString = nil;
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    UIView *view;
    for (UIView *subView in subviews) {
        if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            view = subView;
        }
    }
    NSInteger networkTypeIntger = [[view valueForKey:@"dataNetworkType"] integerValue];
    
    switch (networkTypeIntger) {
        case 0:
            networkTypeString = @"not service";
            break;
        case 1:
            networkTypeString = @"GPRS";
            break;
        case 2:
            networkTypeString = @"3G";
            break;
        case 3:
            networkTypeString = @"4G";
            break;
        case 4:
            networkTypeString = @"LTE";
            break;
        case 5:
            networkTypeString = @"WIFI";
            break;
        default:
            break;
    }
//    NSLog(@"netWork is :%@ !",networkTypeString);
    return networkTypeString;
}
+ (NSString *)getCarriercurrentCountry
{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier isoCountryCode];
//    NSLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    return currentCountry;
}
@end
