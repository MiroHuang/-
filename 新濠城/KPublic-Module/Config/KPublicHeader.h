//
//  KPublicHeader.h
//  新濠城
//
//  Created by XHC on 2017/10/12.
//  Copyright © 2017年 XHC. All rights reserved.
//

#ifndef KPublicHeader_h
#define KPublicHeader_h

#import "KPublicPrompt.h"
#import "KValidateObject.h"
#import "KRequestURLObject.h"

#pragma mark - Model
#import "KUserInfoModel.h"
#import "KRoomModel.h"
#import "KOperationRecordModel.h"
#import "KRoomUserModel.h"
#import "KBaccaratRecordModel.h"
#import "KBaccaratResultModel.h"

#pragma mark - DataModel
#import "KUserInfoDataModel.h"
#import "KVersionControlManager.h"

#pragma mark - ViewController
#import "KPublicChatListViewController.h"

#pragma mark - 调试模式开关
//#define DEBUG_MODE
#ifdef DEBUG_MODE
#define KLog(fmt, ...) NSLog((@"[函数名:%s]" "[行号:%d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...)
#define KLog(...);
#endif

#pragma mark - Limit
#define PhoneNumber_Length (11)
#define AccountName_Max_Length (12)
#define AccountName_Min_Length (5)
#define NickName_Max_Length (12)
#define NickName_Min_Length (2)
#define PassWord_Max_Length (12)
#define PassWord_Min_Length (6)
#define PayPassWord_Length (6)

#pragma mark - RequestURL
#define KRequestForUser_Login [[KRequestURLObject shareInstance].activeRequestURLStr stringByAppendingFormat:@"%@", @"/api/user/gettoken"]
#define KRequestForBaccarat_Removeuserstake [[KRequestURLObject shareInstance].activeRequestURLStr stringByAppendingFormat:@"%@", @"/api/baccarat/removeuserstake"]
#define KRequestForBaccarat_Userstake [[KRequestURLObject shareInstance].activeRequestURLStr stringByAppendingFormat:@"%@", @"/api/baccarat/userstake"]

#endif /* KPublicHeader_h */
