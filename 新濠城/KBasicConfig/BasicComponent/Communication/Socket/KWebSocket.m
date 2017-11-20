//
//  KWebSocket.m
//  Tuba2.0
//
//  Created by 黄凯 on 2016/12/24.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import "KWebSocket.h"
#import <UIKit/UIKit.h>
#import <SocketRocket/SRWebSocket.h>
#import "JSONKit.h"

@interface KWebSocket ()<SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@end
@implementation KWebSocket
+ (KWebSocket *)shareInstance {
    static KWebSocket *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[KWebSocket alloc] init];
    });
    return sharedInstace;
}
#pragma mark - connectSocket
- (void)connectSocket {
    _webSocket = nil;
    if (_webSocket == nil) {
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:1234"]]];
        _webSocket.delegate = self;
        [_webSocket open];
    }
}
#pragma mark - disConnectSocket
- (void)disConnectSocket {
    [_webSocket close];
    _webSocket = nil;
}
#pragma mark - Method
- (void)sendScoketMessage {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"小白一号" forKey:@"Sender"];
    [dictionary setValue:@"小白二号" forKey:@"Receiver"];
    UIImage *image = [UIImage imageNamed:@"bulk_header"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"length = %ld", encodedImageStr.length);
    [dictionary setValue:encodedImageStr forKey:@"Image"];
    NSLog(@"SendSocket：%@", [dictionary JSONString]);
    [_webSocket send:[NSString stringWithFormat:@"%@", [dictionary JSONString]]];
}
#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen");
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError = %@", error);
    //[self disConnectSocket];
    //[self connectSocket];
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"didReceiveMessage = %@", message);
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    if (resultDic[@"Image"]) {
        self.kWebSocketCompletedBlock(resultDic[@"Image"]);
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (wasClean) {
        NSLog(@"wasClean = YES, reason = %@, code = %ld", reason, code);
    }else{
        [self disConnectSocket];
        NSLog(@"wasClean = NO, reason = %@, code = %ld", reason, code);
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"pongPayload \"%@\"", pongPayload);
}

@end
