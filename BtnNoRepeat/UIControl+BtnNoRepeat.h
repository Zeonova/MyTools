//
//  UIControl+BtnNoRepeat.h
//  TestRuntime
//
//  Created by 疯兔 on 15/9/23.
//  Copyright © 2015年 DYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (BtnNoRepeat)
@property(nonatomic,assign)NSTimeInterval amc_acceptEventInerval;
@property(nonatomic,assign)BOOL amc_ignoreEvent;
@end
