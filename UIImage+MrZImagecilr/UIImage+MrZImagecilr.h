

#import <UIKit/UIKit.h>

@interface UIImage (MrZImagecilr)
///将图片处理成圆形，可以保存在本地，或者直接使用
+ (UIImage *)clipImage:(NSString *)imageName writeToFile:(BOOL)write;
@end
