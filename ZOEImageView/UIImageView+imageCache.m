//
//  UIImageView+imageCache.m
//  TestImageView
//
//  Created by 疯兔 on 16/3/23.
//  Copyright © 2016年 ZOE. All rights reserved.
//
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#import "UIImageView+imageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>

NSString *const kFileName = @"image.plist";
NSString *const kEtag = @"Etag";
NSString *const kHTTPHeaderFieldKey = @"If-None-Match";

static char kImgURLKey;

@implementation UIImageView (imageCache)
@dynamic imgURL;
-(void)zoe_setImageFromURLString:(NSString *)URLString
{
    self.imgURL = URLString;
    [self downloadImage];
}
-(void)downloadImage
{
    BOOL dictBool;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self filePathName] stringByAppendingPathComponent: kFileName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.imgURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    if ([fileManager fileExistsAtPath:filePath] && [fileManager fileExistsAtPath:[self imagePath]]){
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (dict[[self URLmd5]]) {
            [request addValue:dict[[self URLmd5]] forHTTPHeaderField:kHTTPHeaderFieldKey];
            dictBool = YES;
        }
    }
    __weak __typeof(self)wself = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_main_async_safe(^{
            if ( [(NSHTTPURLResponse *)response statusCode] == 304 ||([fileManager fileExistsAtPath:[self imagePath]] && !dictBool) ) {
                NSData *caCheData = [NSData dataWithContentsOfFile:[self imagePath]];
                UIImage *image;
                NSString *imageContentType = [self test:caCheData];
                if ([imageContentType isEqualToString:@"image/gif"]) {
                    image = [self zoe_animatedGIFWithData:caCheData];
                }else{
                    image = [UIImage imageWithContentsOfFile:[self imagePath]];
                }
                [wself setImage:image];
//                NSLog(@"file");
            }else{
                UIImage *image;
                NSString *imageContentType = [self test:data];
                if ([imageContentType isEqualToString:@"image/gif"]) {
                    image = [self zoe_animatedGIFWithData:data];
                }else{
                    image = [UIImage imageWithData:data];
                }
                
                [wself setImage:image];
                [self saveImageData:data andResponse:(NSHTTPURLResponse *)response];
//                NSLog(@"no file");
            }
        });
    }];
    [task resume];
}
-(NSString *)test:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
    }
    return nil;
}


- (UIImage *)zoe_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self zoe_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}
- (float)zoe_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}
-(void)saveImageData:(NSData *)data andResponse:(NSHTTPURLResponse  *)response
{
    [data writeToFile:[self imagePath] atomically:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self filePathName] stringByAppendingPathComponent: kFileName];
    NSMutableDictionary *mDict;
    if([fileManager fileExistsAtPath:filePath]){
        mDict = [NSMutableDictionary dictionaryWithContentsOfFile: filePath];
    }else{
        mDict = [NSMutableDictionary dictionary];
    }
    if (response.allHeaderFields[kEtag]) {
        [mDict setObject:response.allHeaderFields[kEtag] forKey:[self URLmd5]];
        [mDict writeToFile:filePath atomically:YES];
    }
}


-(NSString *)filePathName
{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *zoe_path = [cachePath stringByAppendingPathComponent:@"ZOEImage"];
    if (![fileManager fileExistsAtPath:zoe_path]) {
        [fileManager createDirectoryAtPath:zoe_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return zoe_path;
}
-(NSString *)imagePath
{
    NSString *imgPath = [[self filePathName] stringByAppendingPathComponent:[self URLmd5]];
    return imgPath;
}
-(NSString *)URLmd5
{
    const char *cStr = [self.imgURL UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - imgURL
-(void)setImgURL:(NSString *)imgURL
{
    objc_setAssociatedObject(self, &kImgURLKey, imgURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)imgURL
{
    return objc_getAssociatedObject(self, &kImgURLKey);
}
@end
