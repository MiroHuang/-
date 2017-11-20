//
//  KUserInfoDataModel.h
//  新濠城
//
//  Created by XHC on 2017/9/29.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUserInfoDataModel : NSObject
+ (KUserInfoDataModel *)shareInstance;
+ (void)tearDown;
@property (nonatomic, strong) KUserInfoModel *kUserInfoModel;
#pragma mark - Reload
+ (void)reload:(ResponseDataStyle)responseDataStyle;
+ (void)reload:(ResponseDataStyle)responseDataStyle success:(void (^)(NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel))success failure:(void (^)(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr))failure;

#pragma mark - CallBack
@property (nonatomic, copy) void(^kViewControllerSuccessBlock) (NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel);
@property (nonatomic, copy) void(^kViewControllerFailureBlock) (NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr);

@property (nonatomic, copy) void(^kRCCBETViewControllerSuccessBlock) (NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel);
@property (nonatomic, copy) void(^kRCCBETViewControllerFailureBlock) (NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr);

@property (nonatomic, copy) void(^kStrongBoxViewControllerSuccessBlock) (NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel);
@property (nonatomic, copy) void(^kStrongBoxViewControllerFailureBlock) (NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr);

@property (nonatomic, copy) void(^kAccountDetailsViewControllerSuccessBlock) (NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel);
@property (nonatomic, copy) void(^kAccountDetailsViewControllerFailureBlock) (NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError * error, NSString *errorStr);

@end
