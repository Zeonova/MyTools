//
//  ZWWebimageManager.h
//  ZWWebImage
//
//  Created by 疯兔 on 15/4/16.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWWebOperation.h"
@interface ZWWebimageManager : NSObject
+(instancetype)sharedManger;
-(void)downloadImageFromURLString:(NSString *)URLString completion:(completionBlock)completion;
-(void)cancelDownURLString:(NSString *)URLString;
@end
