//
//  XcodeColorLogTools.h
//  EASYMONIT-Family
//
//  Created by 疯兔 on 15/7/10.
//  Copyright (c) 2015年 ZW. All rights reserved.
//

#import <Foundation/Foundation.h>
#define XCODECOLORS 10
#if XCODECOLORS
#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"
#define ZLog(fmt,...) NSLog((@"\n %s - [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__,##__VA_ARGS__);
#define ZLogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define ZLogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,238,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define ZLogLightSlateBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg132,112,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define ZLogLightYellow(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define ZLogLavenderBlush(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,100,245;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#else
#define ZLog(fmt,...) NSLog((@"\n %s - [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__,##__VA_ARGS__);
#define ZLogRed(frmt, ...) NSLog((frmt), ##__VA_ARGS__)
#define ZLogGreen(frmt, ...) NSLog((frmt), ##__VA_ARGS__)
#define ZLogLightSlateBlue(frmt, ...) NSLog((frmt), ##__VA_ARGS__)
#define ZLogLightYellow1(frmt, ...) NSLog((frmt), ##__VA_ARGS__)
#define ZLogLavenderBlush(frmt, ...) NSLog((frmt), ##__VA_ARGS__)

#endif

@interface XcodeColorLogTools : NSObject

@end
