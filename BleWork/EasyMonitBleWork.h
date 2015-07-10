//
//
//  Created by 疯兔 on 15/7/10.
//  Copyright (c) 2015年 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define XCODECOLORS 10  //如果安装了xcodecolors插件就可以打开，如果没有不需要打开
#if XCODECOLORS
#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"
#define ZLog(fmt,...) NSLog((@"\n %s - [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__,##__VA_ARGS__);
#define ZLogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define ZLogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,238,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define ZLogLightSlateBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg132,112,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#else
#define ZLog(fmt,...) NSLog((@"\n %s - [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__,##__VA_ARGS__);
#define ZLogRed(frmt, ...) NSLog((frmt), ##__VA_ARGS__)
#define ZLogGreen(frmt, ...) NSLog((frmt), ##__VA_ARGS__)
#define ZLogLightSlateBlue(frmt, ...) NSLog((frmt), ##__VA_ARGS__)
#endif
typedef void(^dataCollectionBlock)(NSData *bleData);
@interface EasyMonitBleWork : NSObject
/**
 *  蓝牙数据采集方法
 *
 *  @param peripheralName  外部设备名称
 *  @param completionBlock 数据采集回调
 */
-(void)BletoothDataCollectionFormName:(NSString *)peripheralName backData:(dataCollectionBlock)completionBlock;
@end
