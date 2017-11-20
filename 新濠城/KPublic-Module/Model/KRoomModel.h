//
//  KRoomModel.h
//  新濠城
//
//  Created by XHC on 2017/10/10.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 房间列表Model */
@interface KRoomModel : NSObject
@property (nonatomic, copy) NSString *roomname;
@property (nonatomic, assign) NSInteger minstake;
@property (nonatomic, assign) NSInteger usercount;
@property (nonatomic, copy) NSString *adminid;
@property (nonatomic, copy) NSString *serviceid;//客服id
@property (nonatomic, assign) NSInteger roomid;
@end
