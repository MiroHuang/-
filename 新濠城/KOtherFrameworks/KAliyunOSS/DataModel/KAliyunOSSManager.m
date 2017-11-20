//
//  KAliyunOSSManager.m
//  新濠城
//
//  Created by XHC on 2017/11/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KAliyunOSSManager.h"

@interface KAliyunOSSManager()
@property (nonatomic, strong) OSSClient *client;
@end
@implementation KAliyunOSSManager

+ (KAliyunOSSManager *)shareInstance {
    static KAliyunOSSManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[KAliyunOSSManager alloc] init];
    });
    return sharedInstace;
}
#pragma mark - Method
- (void)startAliyunOSSWithUploadData:(NSData *)uploadData ofType:(NSString *)ext success:(void (^)(NSString *correctnessStr))success failure:(void (^)(NSString *errorStr))failure {
    if (!_client) {
        kWeakfy(self);
        [self sendRequestForGetOSS:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf uploadFileWithData:uploadData ofType:ext success:success failure:failure];
        } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
            if (failure) {
                failure(errorStr);
            }
        }];
    }else{
        [self uploadFileWithData:uploadData ofType:ext success:success failure:failure];
    }
}
- (void)uploadFileWithData:(NSData *)uploadData ofType:(NSString *)ext success:(void (^)(NSString *correctnessStr))success failure:(void (^)(NSString *errorStr))failure {
    __block NSString *filePath = [NSString stringWithFormat:@"upload/avatar/%@%@.%@", [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]*1000], [NSString stringWithFormat:@"%.6d", (arc4random() % 1000000)], ext];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = @"xinhaocheng";
    put.objectKey = filePath;
    //put.uploadingFileURL = [NSURL fileURLWithPath:@"<filepath>"];
    put.uploadingData = uploadData;

    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            if (success) {
                success(filePath);
            }
        }else{
            NSLog(@"upload object failed, error: %@" , task.error);
            if (failure) {
                failure(@"upload object failed!");
            }
        }
        return nil;
    }];
    [putTask waitUntilFinished];
    //[put cancel];
}
- (void)sendRequestForGetOSS:(void (^)(void))success failure:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    kWeakfy(self);
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/getoss"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        NSString *endpoint = @"http://oss-cn-hongkong.aliyuncs.com";
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:((NSDictionary *)kBasicModel.data)[@"accesskeyid"] secretKeyId:((NSDictionary *)kBasicModel.data)[@"accesskeysecret"] securityToken:((NSDictionary *)kBasicModel.data)[@"securityttoken"]];
        kStrongfy(kWeakSelf);
        kStrongSelf.client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
        if (success) {
            success();
        }
    } failure:failure];
}

@end
