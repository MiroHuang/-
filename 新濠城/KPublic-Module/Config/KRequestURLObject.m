//
//  KRequestURLObject.m
//  新濠城
//
//  Created by XHC on 2017/10/25.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KRequestURLObject.h"

@implementation KRequestURLObject

+ (KRequestURLObject *)shareInstance {
    static KRequestURLObject *dataModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataModel = [[KRequestURLObject alloc] init];
        dataModel.activeRequestURLStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"ActiveRequestURL"];
    });
    return dataModel;
}
#pragma mark - Method
- (void)setActiveRequestURLStr:(NSString *)activeRequestURLStr {
    _activeRequestURLStr = activeRequestURLStr;
    if (!activeRequestURLStr || activeRequestURLStr.length == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ActiveRequestURL"];
    }else{
        NSMutableArray *kRequestURLMuArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"RequestURLArr"]];
        [kRequestURLMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *jsonMuDic = [NSMutableDictionary dictionaryWithDictionary:obj];
            if ([jsonMuDic[@"RequestURL"] isEqualToString:activeRequestURLStr]) {
                [jsonMuDic setObject:@YES forKey:@"ISSelected"];
            }else{
                [jsonMuDic setObject:@NO forKey:@"ISSelected"];
            }
            [kRequestURLMuArr replaceObjectAtIndex:idx withObject:jsonMuDic];
        }];
        [[NSUserDefaults standardUserDefaults] setObject:kRequestURLMuArr forKey:@"RequestURLArr"];
        [[NSUserDefaults standardUserDefaults] setValue:activeRequestURLStr forKey:@"ActiveRequestURL"];
    }
}
- (void)updateRequestURL {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ActiveRequestURL"];
    NSString *activeRequestURLStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"ActiveRequestURL"];
    if (!activeRequestURLStr || activeRequestURLStr.length == 0) {
        NSDictionary *dic1 = @{@"RequestURL":@"http://www.xinhaocheng888.com", @"ISDefault":@YES, @"ISSelected":@YES};
        NSArray *kRequestURLArr = @[dic1];
        [[NSUserDefaults standardUserDefaults] setObject:kRequestURLArr forKey:@"RequestURLArr"];
        [KRequestURLObject shareInstance].activeRequestURLStr = dic1[@"RequestURL"];
    }
}
@end
