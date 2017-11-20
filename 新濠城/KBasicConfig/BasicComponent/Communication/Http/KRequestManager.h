//
//  KRequestManager.h
//  土爸
//
//  Created by 黄凯 on 2016/11/29.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KImageModel.h"
#import "KBasicModel.h"
#import "KHttpPackageModel.h"

@interface KRequestManager : NSObject
+ (KRequestManager *)shareInstance;
#pragma mark - Request Images
+ (void)sendHttpRequestWithKImageModelArr:(NSArray<KImageModel *> *)imageModelArr URLString:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel))success failure:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr))failure;
#pragma mark - Request Parameters
+ (void)sendHttpRequestWithHTTPURLString:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel))success failure:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr))failure;
@end
