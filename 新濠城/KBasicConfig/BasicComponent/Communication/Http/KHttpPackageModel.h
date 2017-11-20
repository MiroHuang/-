//
//  KHttpPackageModel.h
//  土爸
//
//  Created by 黄凯 on 2016/11/29.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHttpPackageModel : NSObject
#pragma mark - Request Parameters
+ (NSURLRequest *)HTTPRequestOperationForUploadDataWithHTTPMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSMutableDictionary *)parameters;
#pragma mark - UploadTask URLRequest(上传图片)
+ (NSURLRequest *)HTTPRequestOperationForUploadTaskWithUrlRequest:(NSString *)URLString;
+ (NSData *)HTTPRequestOperationForUploadTaskWithImageModelArr:(NSArray<KImageModel *> *)imageModelArr parameters:(id)parameters;
@end
