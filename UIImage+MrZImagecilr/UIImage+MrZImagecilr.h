//
//  UIImage+MrZImagecilr.h
//  NewApp2015
//
//  Created by 疯兔 on 15/3/22.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MrZImagecilr)
///将图片处理成圆形，可以保存在本地，或者直接使用
+ (UIImage *)clipImage:(NSString *)imageName writeToFile:(BOOL)write;
@end
