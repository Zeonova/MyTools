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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self filePathName] stringByAppendingPathComponent: kFileName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.imgURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];

    if ([fileManager fileExistsAtPath:filePath] && [fileManager fileExistsAtPath:[self imagePath]]){
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (dict[[self URLmd5]]) {
            [request addValue:dict[[self URLmd5]] forHTTPHeaderField:kHTTPHeaderFieldKey];
        }
    }
    __weak __typeof(self)wself = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_main_async_safe(^{
            if ( [(NSHTTPURLResponse *)response statusCode] == 304 ) {
                [wself setImage:[UIImage imageWithContentsOfFile:[self imagePath]]];
                NSLog(@"file");
            }else{
                [wself setImage:[UIImage imageWithData:data]];
                [self saveImageData:data andResponse:(NSHTTPURLResponse *)response];
                NSLog(@"no file");
            }
        });
    }];
    [task resume];
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
    [mDict setObject:response.allHeaderFields[kEtag] forKey:[self URLmd5]];
    [mDict writeToFile:filePath atomically:YES];
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
