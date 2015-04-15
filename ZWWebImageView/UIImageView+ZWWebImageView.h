//
//  UIImageView+ZWWebImageView.h
//  ZWWebImage
//
//  Created by 疯兔 on 15/4/16.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZWWebImageView)
- (void)setWebImageFromURL:(NSString *)URLString;
@property (nonatomic,copy)NSString *urlString;
@end
