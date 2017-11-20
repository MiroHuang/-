//
//  KPublicGroupMemberInfoViewController.h
//  新濠城
//
//  Created by XHC on 2017/10/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 群组成员信息列表 */
@interface KPublicGroupMemberInfoViewController : BasicViewController
@property (nonatomic, copy) NSString *roomidStr;
@property (nonatomic, copy) NSArray<KRoomUserModel *> *kRoomUserModelArr;
@end
