//
//  KVersionControlManager.m
//  新濠城
//
//  Created by XHC on 2017/10/27.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KVersionControlManager.h"

@implementation KVersionControlManager
+ (KVersionControlManager *)shareInstance {
    static KVersionControlManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KVersionControlManager alloc] init];
    });
    return manager;
}
+ (void)versionUpdate {
    [self sendReqeustForGetversion];
}
+ (void)sendReqeustForGetversion {
    [[NSUserDefaults standardUserDefaults] setValue:@"1.0.0" forKey:@"iOSVersion"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [KMBProgressHUDManager showHUDAtWindow];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/getversion"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        NSString *latestiOSVersion = ((NSDictionary *)kBasicModel.data)[@"iosversion"];
        NSString *iOSVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"iOSVersion"];
        if (![latestiOSVersion isEqualToString:iOSVersion]) {
            __block NSString *itunesStr = ((NSDictionary *)kBasicModel.data)[@"ios"];
            __block UIViewController *viewController = [UIViewController kCurrentViewController];
            __block UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:@"版本过低，需要升级到最新版本！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesStr]];
            }];
            [alertController addAction:continueAction];
            [KGlobalUtils getMainThread:^{
                [viewController presentViewController:alertController animated:YES completion:nil];
            }];
        }
        [KMBProgressHUDManager hide];
    } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        [KMBProgressHUDManager hide];
    }];
}
@end
