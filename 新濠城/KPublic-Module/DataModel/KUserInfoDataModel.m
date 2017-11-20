//
//  KUserInfoDataModel.m
//  新濠城
//
//  Created by XHC on 2017/9/29.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KUserInfoDataModel.h"
#import "NSString+KString.h"

@interface KUserInfoDataModel ()
@property (nonatomic, copy) void(^kSuccessBlock) (NSHTTPURLResponse * _Nullable response, KUserInfoModel * _Nullable kUserInfoModel);
@property (nonatomic, copy) void(^kFailureBlock)(NSHTTPURLResponse * _Nullable response, KBasicModel * _Nullable kBasicModel, NSError * _Nullable error, NSString * _Nullable errorStr);
@end
@implementation KUserInfoDataModel
+ (KUserInfoDataModel *)shareInstance {
    static KUserInfoDataModel *kUserInfoDataModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kUserInfoDataModel = [[KUserInfoDataModel alloc] init];
    });
    return kUserInfoDataModel;
}
+ (void)tearDown {
    [KUserInfoDataModel shareInstance].kSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kFailureBlock = nil;
    [KUserInfoDataModel shareInstance].kViewControllerSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kViewControllerFailureBlock = nil;
    [KUserInfoDataModel shareInstance].kRCCBETViewControllerSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kRCCBETViewControllerFailureBlock = nil;
    [KUserInfoDataModel shareInstance].kStrongBoxViewControllerSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kStrongBoxViewControllerFailureBlock = nil;
    [KUserInfoDataModel shareInstance].kAccountDetailsViewControllerSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kAccountDetailsViewControllerFailureBlock = nil;
    [KUserInfoDataModel shareInstance].kUserInfoModel = nil;
}
#pragma mark - Reload
+ (void)reload:(ResponseDataStyle)responseDataStyle {
    [self reload:responseDataStyle success:nil failure:nil];
}
+ (void)reload:(ResponseDataStyle)responseDataStyle success:(void (^)(NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel))success failure:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr))failure {
    [self reload:responseDataStyle parameters:nil success:success failure:failure];
}
+ (void)reload:(ResponseDataStyle)responseDataStyle parameters:(NSMutableDictionary *)parameters success:(void (^)(NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel))success failure:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr))failure {
    [KUserInfoDataModel shareInstance];
    [KUserInfoDataModel shareInstance].kSuccessBlock = success;
    [KUserInfoDataModel shareInstance].kFailureBlock = failure;
    
    if (![KUserInfoDataModel shareInstance].kUserInfoModel ||
            responseDataStyle == ResponseDataStyleDirectRequest) {
        [self sendRequestForGetUserInfo];
    }else if (responseDataStyle == ResponseDataStyleAfterRequest) {
        [self returnSuccessBlock:nil andKUserInfoModel:[KUserInfoDataModel shareInstance].kUserInfoModel];
        [self sendRequestForGetUserInfo];
    }else{
        [self returnSuccessBlock:nil andKUserInfoModel:[KUserInfoDataModel shareInstance].kUserInfoModel];
    }
}
#pragma mark - Method
+ (void)returnSuccessBlock:(NSHTTPURLResponse *)response andKUserInfoModel:(KUserInfoModel *)kUserInfoModel {
    if ([KUserInfoDataModel shareInstance].kSuccessBlock) {
        [KUserInfoDataModel shareInstance].kSuccessBlock(response, kUserInfoModel);
    }
    if ([KUserInfoDataModel shareInstance].kViewControllerSuccessBlock) {
        [KUserInfoDataModel shareInstance].kViewControllerSuccessBlock(response, kUserInfoModel);
    }
    if ([KUserInfoDataModel shareInstance].kRCCBETViewControllerSuccessBlock) {
        [KUserInfoDataModel shareInstance].kRCCBETViewControllerSuccessBlock(response, kUserInfoModel);
    }
    if ([KUserInfoDataModel shareInstance].kStrongBoxViewControllerSuccessBlock) {
        [KUserInfoDataModel shareInstance].kStrongBoxViewControllerSuccessBlock(response, kUserInfoModel);
    }
    if ([KUserInfoDataModel shareInstance].kAccountDetailsViewControllerSuccessBlock) {
        [KUserInfoDataModel shareInstance].kAccountDetailsViewControllerSuccessBlock(response, kUserInfoModel);
    }
}
+ (void)returnFailureBlock:(NSHTTPURLResponse *)response andKBasicModel:(KBasicModel *)kBasicModel andError:(NSError *)error andErrorStr:(NSString *)errorStr {
    if ([KUserInfoDataModel shareInstance].kFailureBlock) {
        [KUserInfoDataModel shareInstance].kFailureBlock(response, kBasicModel, error, errorStr);
    }
    if ([KUserInfoDataModel shareInstance].kViewControllerFailureBlock) {
        [KUserInfoDataModel shareInstance].kViewControllerFailureBlock(response, kBasicModel, error, errorStr);
    }
    if ([KUserInfoDataModel shareInstance].kRCCBETViewControllerFailureBlock) {
        [KUserInfoDataModel shareInstance].kRCCBETViewControllerFailureBlock(response, kBasicModel, error, errorStr);
    }
    if ([KUserInfoDataModel shareInstance].kStrongBoxViewControllerFailureBlock) {
        [KUserInfoDataModel shareInstance].kStrongBoxViewControllerFailureBlock(response, kBasicModel, error, errorStr);
    }
    if ([KUserInfoDataModel shareInstance].kAccountDetailsViewControllerFailureBlock) {
        [KUserInfoDataModel shareInstance].kAccountDetailsViewControllerFailureBlock(response, kBasicModel, error, errorStr);
    }
}
#pragma mark - Request
+ (void)sendRequestForGetUserInfo {
    kWeakfy(self);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/getuserinfo"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KUserInfoDataModel shareInstance].kUserInfoModel = [KUserInfoModel yy_modelWithJSON:kBasicModel.data];
        
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:[KUserInfoDataModel shareInstance].kUserInfoModel.uuid name:[KUserInfoDataModel shareInstance].kUserInfoModel.nickname portrait:[KUserInfoDataModel shareInstance].kUserInfoModel.avatar];
        if (!userInfo.portraitUri || userInfo.portraitUri.length <= 0 || userInfo.portraitUri != [KUserInfoDataModel shareInstance].kUserInfoModel.avatar) {
            userInfo.portraitUri = [KUserInfoDataModel shareInstance].kUserInfoModel.avatar;
            [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:[KUserInfoDataModel shareInstance].kUserInfoModel.uuid];
        }
        [RCIM sharedRCIM].currentUserInfo = userInfo;
        
        kStrongfy(kWeakSelf);
        [kStrongSelf returnSuccessBlock:response andKUserInfoModel:[KUserInfoDataModel shareInstance].kUserInfoModel];
    } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        kStrongfy(kWeakSelf);
        [kStrongSelf returnFailureBlock:response andKBasicModel:kBasicModel andError:error andErrorStr:errorStr];
    }];
}
@end
