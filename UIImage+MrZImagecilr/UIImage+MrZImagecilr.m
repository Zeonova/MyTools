

#import "UIImage+MrZImagecilr.h"

@implementation UIImage (MrZImagecilr)
///将图片处理为圆形
+ (UIImage *)clipImage:(NSString *)imageName writeToFile:(BOOL)write
{
    NSLog(@"%s",__FUNCTION__);
    //1.加载图片
    UIImage *oldImage = [UIImage imageNamed:imageName];
    NSLog(@"image.size %@",NSStringFromCGSize(oldImage.size));
    //2.开始上下文
    UIGraphicsBeginImageContextWithOptions(oldImage.size, NO, 0.0);
    //3.取得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //4.画圆
    CGRect cirleRect = CGRectMake(0, 0, oldImage.size.width,  oldImage.size.height);
    CGContextAddEllipseInRect(ctx, cirleRect);//圆形绘制方法
    //5.按照当前形状裁剪
    CGContextClip(ctx);
    //6.画图
    [oldImage drawInRect:cirleRect];
    //7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //8.结束
    UIGraphicsEndImageContext();
    //9.写出文件
    if (write) {
        NSData *data = UIImagePNGRepresentation(newImage);
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *writePath = [[path lastObject] stringByAppendingPathComponent:@"new.png"];
        NSLog(@"writePath: %@", writePath);
        [data writeToFile:writePath atomically:YES];
    }
    //10.将处理后的圆形图片返回
    return newImage;
}
@end
