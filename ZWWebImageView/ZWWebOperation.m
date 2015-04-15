//
//  ZWWebOperation.m
//  ZWWebImage
//
//  Created by 疯兔 on 15/4/16.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "ZWWebOperation.h"
#import "NSString+SandboxPath.h"
@interface ZWWebOperation()
@property(nonatomic,copy)NSString *urlSting;
@property(nonatomic,copy)completionBlock completion;

@end
@implementation ZWWebOperation
+(instancetype)webImageOperationWithURLSting:(NSString *)string completion:(completionBlock)completion
{
    ZWWebOperation *op = [ZWWebOperation new];
    op.urlSting = string;
    op.completion = completion;
    return op;
}

-(void)main
{
    @autoreleasepool {
        NSLog(@"download this URL: %@",self.urlSting);
        if (self.isCancelled) return;
        NSURL *url = [NSURL URLWithString:self.urlSting];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (self.isCancelled) return;
        if (data != nil) {
            [data writeToFile:self.urlSting.appendCacheDir atomically:YES];
            NSLog(@"sandbox into -- %@",self.urlSting.appendCacheDir);
        }
        if (self.isCancelled) return;
        if (self.completion && data != nil) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.completion([UIImage imageWithData:data]);
            }];
        }
        
    }
}

@end
