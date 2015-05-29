//
//  WLDeviceInfoModel.h
//  Wuliao
//
//  Created by 疯兔 on 15/5/28.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLDeviceInfoModel : NSObject
@property(nonatomic,readonly)NSString *osName;
@property(nonatomic,readonly)NSString *osVersion;
@property(nonatomic,readonly)NSNumber *width;
@property(nonatomic,readonly)NSNumber *height;
@property(nonatomic,readonly)NSString *net;
@property(nonatomic,readonly)NSString *language;
@property(nonatomic,readonly)NSString *country;
@property(nonatomic,readonly)NSString *imsi;
@property(nonatomic,readonly)NSString *imei;
@property(nonatomic,readonly)NSString *mac;
@property(nonatomic,readonly)NSString *manufacturer;
@property(nonatomic,readonly)NSString *model;
@end
