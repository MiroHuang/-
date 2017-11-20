//
//  KUserInfoModel.h
//  新濠城
//
//  Created by XHC on 2017/9/29.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUserInfoModel : NSObject
@property (nonatomic, copy) NSString *logintime;
@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger isagent;//1：总代理
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger safebalance;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *groupuuid;
@property (nonatomic, assign) BOOL ispaypassword;
@property (nonatomic, copy) NSString *qrcode;
@end
