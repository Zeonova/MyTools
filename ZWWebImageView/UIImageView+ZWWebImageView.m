//
//  UIImageView+ZWWebImageView.m
//  ZWWebImage
//
//  Created by 疯兔 on 15/4/16.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "UIImageView+ZWWebImageView.h"
#import <objc/runtime.h>
#import "ZWWebimageManager.h"

@implementation UIImageView (ZWWebImageView)

-(void)setWebImageFromURL:(NSString *)URLString
{
    if ([self.urlString isEqualToString:URLString]) {
        NSLog(@"downing..");
        return;
    }
    if (self.urlString) {
        [[ZWWebimageManager sharedManger]cancelDownURLString:URLString];
        self.image = nil;
    }
    self.urlString = URLString;
    __weak typeof(self)weakSelf = self;
    [[ZWWebimageManager sharedManger]downloadImageFromURLString:URLString completion:^(UIImage *image) {
        weakSelf.image = image;
    }];
}
#pragma mark - 关联对象
const void *URLStringKey = "URLKEY";

-(void)setUrlString:(NSString *)urlString
{
    objc_setAssociatedObject(self, URLStringKey, urlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)urlString
{
    return objc_getAssociatedObject(self, URLStringKey);
}
@end
