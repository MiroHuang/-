//
//  KAliyunOSSManager.h
//  新濠城
//
//  Created by XHC on 2017/11/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

@interface KAliyunOSSManager : NSObject
+ (KAliyunOSSManager *)shareInstance;
#pragma mark - Method
- (void)startAliyunOSSWithUploadData:(NSData *)uploadData ofType:(NSString *)ext success:(void (^)(NSString *correctnessStr))success failure:(void (^)(NSString *errorStr))failure;
@end
