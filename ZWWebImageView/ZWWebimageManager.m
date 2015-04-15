//
//  ZWWebimageManager.m
//  ZWWebImage
//
//  Created by 疯兔 on 15/4/16.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "ZWWebimageManager.h"
#import "ZWWebOperation.h"
#import "NSString+SandboxPath.h"
@interface ZWWebimageManager()<NSCacheDelegate>
@property (nonatomic,strong)NSOperationQueue *queue;
@property (nonatomic,strong)NSCache *operationCache;
@property (nonatomic,strong)NSCache *imageCache;
@end

@implementation ZWWebimageManager
+(instancetype)sharedManger
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
-(void)downloadImageFromURLString:(NSString *)URLString completion:(completionBlock)completion
{
    if ([self.operationCache objectForKey:URLString]) {
        NSLog(@"isDownloading.....");
        return;
    }
    UIImage *image = [self checkCacheWithURLString:URLString];
    if (image && completion) {
        completion(image);
        return;
    }
    ZWWebOperation *op = [ZWWebOperation webImageOperationWithURLSting:URLString completion:^(UIImage *image) {
        
        [self.operationCache removeObjectForKey:URLString];
        [self.imageCache setObject:image forKey:URLString];
        
        
        if (completion) {
            completion(image);
        }
    }];
    [self.operationCache setObject:op forKey:URLString];
    [self.queue addOperation:op];
    
}
-(void)cancelDownURLString:(NSString *)URLString
{
    ZWWebOperation *op = [self.operationCache objectForKey:URLString];
    if (op) {
        [op cancel];
        [self.operationCache removeObjectForKey:URLString];
    }
}

- (UIImage *)checkCacheWithURLString:(NSString *)urlString {
    
    UIImage *image;
    if ((image =[self.imageCache objectForKey:urlString])) {
        NSLog(@"从内存加载");
        return image;
    }
    // 判断沙盒
    image = [UIImage imageWithContentsOfFile:urlString.appendCacheDir];
    if (image != nil) {
        NSLog(@"从沙盒返回");
        // 将图像添加到图像缓冲池
        [self.imageCache setObject:image forKey:urlString];
 
        return image;
    }
    return nil;
}

-(void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"remove %@",obj);
}


#pragma mark - lazy
-(NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [NSOperationQueue new];
    }
    return _queue;
}
-(NSCache *)operationCache
{
    if (_operationCache == nil) {
        _operationCache = [NSCache new];
        _operationCache.delegate = self;
        _operationCache.countLimit = 3;
    }
    return _operationCache;
}
-(NSCache *)imageCache
{
    if (_imageCache == nil) {
        _imageCache = [NSCache new];
        _imageCache.countLimit = 10;
        _imageCache.delegate = self;
    }
    return _imageCache;
}
@end
