//
//  WithdrawalStatusViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/23.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "WithdrawalStatusViewController.h"

@interface WithdrawalStatusViewController ()

@end

@implementation WithdrawalStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self sendRequestForGetUserWithdraw];
}
#pragma mark - Reload
- (void)reloadMainViewForWait:(KBasicModel *)kBasicModel {
    KLabel *kLabel1 = [KLabel new];
    kLabel1.font = SystemFontAll(54);
    kLabel1.textColor = KRGB(100, 100, 100, 1);
    kLabel1.numberOfLines = 1;
    kLabel1.text = [NSString stringWithFormat:@"提现：%@", ((NSDictionary *)kBasicModel.data)[@"money"]];
    [self.view addSubview:kLabel1];
    CGFloat kLabel1_Left = KScreenL(160);
    CGFloat kLabel1_Right = KScreenL(160);
    CGFloat kLabel1_Top = KScreenL(100);
    [kLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kLabel1_Left);
        make.right.equalTo(self.view).offset(-kLabel1_Right);
        make.top.equalTo(self.view).offset(kLabel1_Top);
    }];
    
    KLabel *kLabel2 = [KLabel new];
    kLabel2.font = SystemFontAll(54);
    kLabel2.textColor = KRGB(100, 100, 100, 1);
    kLabel2.numberOfLines = 1;
    kLabel2.text = [NSString stringWithFormat:@"时间：%@", ((NSDictionary *)kBasicModel.data)[@"createtime"]];
    [self.view addSubview:kLabel2];
    CGFloat kLabel2_Top = KScreenL(100);
    [kLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kLabel1);
        make.top.equalTo(kLabel1.mas_bottom).offset(kLabel2_Top);
    }];
    
    KLabel *kLabel3 = [KLabel new];
    kLabel3.font = SystemFontAll(120);
    kLabel3.textColor = KRGB(243.0, 107.0, 42.0, 1);
    kLabel3.numberOfLines = 1;
    kLabel3.text = @"正在等待处理...";
    [self.view addSubview:kLabel3];
    CGFloat kLabel3_Top = KScreenL(100);
    [kLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kLabel2);
        make.top.equalTo(kLabel2.mas_bottom).offset(kLabel3_Top);
    }];
    
    KLabel *kLabel4 = [KLabel new];
    kLabel4.font = SystemFontAll(48);
    kLabel4.textColor = KRGB(100, 100, 100, 1);
    kLabel4.numberOfLines = 0;
    kLabel4.text = @"注：提现后提现分数会冻结，工作人员会在2~3个工作日内处理。";
    [self.view addSubview:kLabel4];
    CGFloat kLabel4_Top = KScreenL(100);
    [kLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kLabel3);
        make.top.equalTo(kLabel3.mas_bottom).offset(kLabel4_Top);
    }];
}
#pragma mark - Request
- (void)sendRequestForGetUserWithdraw {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/getuserwithdraw"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [KMBProgressHUDManager hide];
            [kStrongSelf reloadMainViewForWait:kBasicModel];
        }];
    } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        [KGlobalUtils getMainThread:^{
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
