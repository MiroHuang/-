//
//  KImageDownloader.m
//  新濠城
//
//  Created by XHC on 2017/11/7.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KImageDownloader.h"

#define FileName @"DownloadImages"

@interface KImageDownloader()
@property (nonatomic, copy) void(^kCompletedBlock)(UIImage *image);
@end
@implementation KImageDownloader

+ (KImageDownloader *)shareInstance {
    static KImageDownloader *kImageDownloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kImageDownloader = [[KImageDownloader alloc] init];
    });
    return kImageDownloader;
}

- (void)dealloc {
    self.imageUrl = nil;
    self.kCompletedBlock = nil;
}

#pragma mark - 异步加载
- (void)startDownloadImageWithImageUrl:(NSString *)imageUrl completion:(void (^)(UIImage *))completion {
    _kCompletedBlock = completion;
    self.imageUrl = imageUrl;
    
    // 先判断本地沙盒是否已经存在图像，存在直接获取，不存在再下载，下载后保存
    // 存在沙盒的Caches的子文件夹DownloadImages中
    UIImage *image = [self loadLocalImage:imageUrl];
    if (image == nil) {
        // 沙盒中没有，下载
        // 异步下载,分配在程序进程缺省产生的并发队列
        kWeakfy(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 多线程中下载图像--->方便简洁写法
            kStrongfy(kWeakSelf);
            __block NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            // 缓存图片
            [imageData writeToFile:[kStrongSelf imageFilePath:imageUrl] atomically:YES];
            // 回到主线程完成UI设置
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                if (image) {
                    kStrongfy(kWeakSelf);
                    if (kStrongSelf.kCompletedBlock) {
                        kStrongSelf.kCompletedBlock(image);
                    }
                }
            });
        });
    }else{
        if (_kCompletedBlock) {
            _kCompletedBlock(image);
        }
    }
}
- (void)startDownloadImageWithVideoUrl:(NSString *)imageUrl completion:(void (^)(UIImage *))completion {
    _kCompletedBlock = completion;
    self.imageUrl = imageUrl;
    
    // 先判断本地沙盒是否已经存在图像，存在直接获取，不存在再下载，下载后保存
    // 存在沙盒的Caches的子文件夹DownloadImages中
    UIImage *image = [self loadLocalImage:imageUrl];
    if (image == nil) {
        // 沙盒中没有，下载
        // 异步下载,分配在程序进程缺省产生的并发队列
        kWeakfy(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 多线程中下载图像--->方便简洁写法
            kStrongfy(kWeakSelf);
            __block NSData *imageData = UIImageJPEGRepresentation([UIImage getVideoPreViewImageWithVideoPath:[NSURL URLWithString:imageUrl]], 1);
            // 缓存图片
            [imageData writeToFile:[kStrongSelf imageFilePath:imageUrl] atomically:YES];
            // 回到主线程完成UI设置
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                if (image) {
                    kStrongfy(kWeakSelf);
                    if (kStrongSelf.kCompletedBlock) {
                        kStrongSelf.kCompletedBlock(image);
                    }
                }
            });
        });
    }else{
        if (_kCompletedBlock) {
            _kCompletedBlock(image);
        }
    }
}
#pragma mark - 加载本地图像
- (UIImage *)loadLocalImage:(NSString *)imageUrl {
    self.imageUrl = imageUrl;
    // 获取图像路径
    NSString *filePath = [self imageFilePath:self.imageUrl];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (image != nil) {
        return image;
    }
    return nil;
    
}

#pragma mark - 清空缓存
+ (void)clearCaches {
    NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * downloadImagesPath = [cachesPath stringByAppendingPathComponent:FileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadImagesPath]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:downloadImagesPath error:nil];
    }
}

#pragma mark - 获取图像路径
- (NSString *)imageFilePath:(NSString *)imageUrl {
    // 获取caches文件夹路径
    NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSLog(@"caches = %@",cachesPath);
    
    // 创建DownloadImages文件夹
    NSString * downloadImagesPath = [cachesPath stringByAppendingPathComponent:FileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:downloadImagesPath]) {
        
        [fileManager createDirectoryAtPath:downloadImagesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
#pragma mark 拼接图像文件在沙盒中的路径,因为图像URL有"/",要在存入前替换掉,随意用"_"代替
    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [downloadImagesPath stringByAppendingPathComponent:imageName];
    
    return imageFilePath;
}
@end
