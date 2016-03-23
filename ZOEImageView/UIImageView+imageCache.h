//
//  UIImageView+imageCache.h
//  TestImageView
//
//  Created by 疯兔 on 16/3/23.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (imageCache)
@property(nonatomic,copy)NSString *imgURL;
-(void)zoe_setImageFromURLString:(NSString *)URLString;
@end
