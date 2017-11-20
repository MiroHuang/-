//
//  KWebSocket.h
//  Tuba2.0
//
//  Created by 黄凯 on 2016/12/24.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWebSocket : NSObject
+ (KWebSocket *)shareInstance;
#pragma mark - Connect Socket
- (void)connectSocket;
- (void)disConnectSocket;
- (void)sendScoketMessage;
@property (nonatomic, copy) void(^kWebSocketCompletedBlock) (NSString *value);
@end
