//
//  KRequestManager.m
//  土爸
//
//  Created by 黄凯 on 2016/11/29.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import "KRequestManager.h"
#import "KHttpPackageModel.h"

@implementation KRequestManager
+ (KRequestManager *)shareInstance {
    static KRequestManager *kRequestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRequestManager = [[KRequestManager alloc] init];
    });
    return kRequestManager;
}
#pragma mark - Response Method
+ (NSString *)CheckNSURLResponseDomainWithCode:(NSInteger)statusCode {
    NSString *promptStr = nil;
    switch (statusCode) {
        case 401:
        {
            promptStr = @"您的帐号在别的设备上登录，您被迫下线！";
            break;
        }
        case 500:
        {
            promptStr = @"服务器异常！";
            break;
        }
        default:
        {
#ifdef DEBUG_MODE
            promptStr = [NSString stringWithFormat:@"错误码 ->%ld", (long)statusCode];
#else
            promptStr = @"未知错误,请联系客服!";
#endif
            break;
        }
    }
    
    return promptStr;
}
+ (NSString *)CheckNSURLErrorDomainWithCode:(NSInteger)code {
    NSString *promptStr = nil;
    switch (code) {
        case 500:
        {
            promptStr = @"服务器异常!";
            break;
        }
        case -1001:
        {
            promptStr = @"网络请求超时,请重试";
        }
            break;
        case -1009:
        {
            promptStr = @"当前网络不可用,请检查网络";
        }
            break;
        case 0:
        case -1003:
        case -1004:
        case -1011:
        {
            promptStr = @"服务器无响应";
        }
            break;
        default:
        {
#ifdef DEBUG_MODE
            promptStr = [NSString stringWithFormat:@"网络错误码 ->%ld", (long)code];
#else
            promptStr = @"未知错误,请联系客服!";
#endif
        }
            break;
    }
    return promptStr;
}
+ (void)returnSuccessByHttpResponse:(NSHTTPURLResponse *)httpResponse
                     andKBasicModel:(KBasicModel *)basicModel
                         andSuccess:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel))success {
    __block void(^kSuccessBlock)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel) = success;
    __block NSHTTPURLResponse *kHttpResponse = httpResponse;
    __block KBasicModel *kBasicModel = basicModel;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (kSuccessBlock) {
            kSuccessBlock(kHttpResponse, kBasicModel);
        }
    });
}
+ (void)returnFailureByHttpResponse:(NSHTTPURLResponse *)httpResponse
                     andKBasicModel:(KBasicModel *)basicModel andError:(NSError * _Nullable)error
                         andFailure:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr))failure {
    __block KBasicModel *kBasicModel = basicModel;
    __block NSError *kError = error;
    __block NSString *kErrorStr = nil;
    
    if (error.code != 0) {
        kErrorStr = [self CheckNSURLErrorDomainWithCode:kError.code];
    }else if (httpResponse.statusCode != 200) {
        kErrorStr = [self CheckNSURLResponseDomainWithCode:httpResponse.statusCode];
    }else if (kBasicModel) {
        kErrorStr = kBasicModel.message;
    }else{
        kErrorStr = @"未知错误，谨慎！";
    }
    
    if (httpResponse.statusCode == 401) {
        [KGlobalUtils rollBackToLoginViewControllerWithPrompt:kErrorStr];
    }else{
        __block void(^kFailureBlock)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr) = failure;
        __block NSHTTPURLResponse *kHttpResponse = httpResponse;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (kFailureBlock) {
                kFailureBlock(kHttpResponse, kBasicModel, kError, kErrorStr);
            }
        });
    }
}
#pragma mark - Request Images
+ (void)sendHttpRequestWithKImageModelArr:(NSArray<KImageModel *> *)imageModelArr
                                URLString:(NSString *)URLString
                               parameters:(NSMutableDictionary *)parameters
                                  success:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel *kBasicModel))success
                                  failure:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr))failure {
    NSURLRequest *urlRequest = [KHttpPackageModel HTTPRequestOperationForUploadTaskWithUrlRequest:URLString];
    NSData *uploadData = [KHttpPackageModel HTTPRequestOperationForUploadTaskWithImageModelArr:imageModelArr parameters:parameters];
    __block void(^kSuccessBlock)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel) = success;
    __block void(^kFailureBlock)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr) = failure;
    kWeakfy(self);
    NSURLSessionUploadTask *uploadtask = [[NSURLSession sharedSession] uploadTaskWithRequest:urlRequest fromData:uploadData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        kStrongfy(kWeakSelf);
        KBasicModel *kBasicModel = [KBasicModel yy_modelWithJSON:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        if (httpResponse.statusCode == 200) {
            if ([kBasicModel.status isEqualToString:@"failed"]) {
                [kStrongSelf returnFailureByHttpResponse:httpResponse andKBasicModel:kBasicModel andError:nil andFailure:kFailureBlock];
            }else{
                [kStrongSelf returnSuccessByHttpResponse:httpResponse andKBasicModel:kBasicModel andSuccess:kSuccessBlock];
            }
        }else{
            [kStrongSelf returnFailureByHttpResponse:httpResponse andKBasicModel:kBasicModel andError:error andFailure:kFailureBlock];
        }
    }];
    [uploadtask resume];
}
#pragma mark - Request Parameters
+ (void)sendHttpRequestWithHTTPURLString:(NSString *)URLString
                              parameters:(NSMutableDictionary *)parameters
                                 success:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel *kBasicModel))success
                                 failure:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr))failure {
    [self sendHttpRequestWithHTTPMethod:@"POST" URLString:URLString parameters:parameters success:success failure:failure];
}
+ (void)sendHttpRequestWithHTTPMethod:(NSString *)method
                            URLString:(NSString *)URLString
                           parameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel *kBasicModel))success
                              failure:(void (^)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr))failure {
    NSURLRequest *urlRequest = [KHttpPackageModel HTTPRequestOperationForUploadDataWithHTTPMethod:method URLString:URLString parameters:parameters];
    __block void(^kSuccessBlock)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel) = success;
    __block void(^kFailureBlock)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr) = failure;
    kWeakfy(self);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        kStrongfy(kWeakSelf);
        KBasicModel *kBasicModel = [KBasicModel yy_modelWithJSON:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        if (httpResponse.statusCode == 200) {
            if ([kBasicModel.status isEqualToString:@"failed"]) {
                [kStrongSelf returnFailureByHttpResponse:httpResponse andKBasicModel:kBasicModel andError:nil andFailure:kFailureBlock];
            }else{
                [kStrongSelf returnSuccessByHttpResponse:httpResponse andKBasicModel:kBasicModel andSuccess:kSuccessBlock];
            }
        }else{
            [kStrongSelf returnFailureByHttpResponse:httpResponse andKBasicModel:kBasicModel andError:error andFailure:kFailureBlock];
        }
    }];
    [task resume];
}
@end
