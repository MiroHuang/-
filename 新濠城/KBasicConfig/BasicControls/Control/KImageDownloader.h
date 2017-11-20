//
//  KImageDownloader.h
//  新濠城
//
//  Created by XHC on 2017/11/7.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KImageDownloader : NSObject
+ (KImageDownloader *)shareInstance;
@property (nonatomic,copy) NSString * imageUrl;
- (void)startDownloadImageWithImageUrl:(NSString *)imageUrl completion:(void (^)(UIImage *))completion;
- (void)startDownloadImageWithVideoUrl:(NSString *)imageUrl completion:(void (^)(UIImage *))completion;
- (UIImage *)loadLocalImage:(NSString *)imageUrl;
@end
