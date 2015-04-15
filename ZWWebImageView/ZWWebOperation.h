//
//  ZWWebOperation.h
//  ZWWebImage
//
//  Created by 疯兔 on 15/4/16.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionBlock) (UIImage *image) ;

@interface ZWWebOperation : NSOperation
+(instancetype)webImageOperationWithURLSting:(NSString *)string completion:(completionBlock)completion;

@end
