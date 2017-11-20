//
//  StrongBoxTurnOutViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/2.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "StrongBoxTurnOutViewController.h"
#import "NSString+KString.h"
#import "UILabel+KLabel.h"
#import "IntercalatePaymentPassWordViewController.h"

@interface StrongBoxTurnOutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KTextField *kTextField1;
@property (nonatomic, strong) KTextField *kTextField2;
@property (nonatomic, strong) UIButton *kCompleteButton;
@property (nonatomic, assign) CGFloat leftViewFromTextField_Width;
@property (nonatomic, copy) UIFont *leftViewFromTextField_Font;
@property (nonatomic, strong) UILabel *kLabel;
@end

@implementation StrongBoxTurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _initializedData];
    [self _initTableView];
    [self _initBlocksKit];
    [self _initReactiveCocoa];
    [self _initReloadForKUserInfoDataModel];
}
- (void)_initializedData {
    _leftViewFromTextField_Font = SystemFontAll(58);
    _leftViewFromTextField_Width = [NSString checkSizeFromString:@"保险箱" Font:_leftViewFromTextField_Font Width:MAXFLOAT Height:MAXFLOAT].width;
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}
- (void)_initBlocksKit {
    kWeakfy(self);
    [self.kCompleteButton bk_addEventHandler:^(id sender) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.kTextField2 resignFirstResponder];
        if ([KUserInfoDataModel shareInstance].kUserInfoModel.ispaypassword) {
            KPayAlertViewController *alertController = [KPayAlertViewController showQyjCustomerAlertViewController:^(NSString *resultVault) {
                kStrongfy(kWeakSelf);
                [kStrongSelf sendRequestForStrongBoxTurnOut:resultVault];
            }];

            NSString *kInputMoneyLabelStr = [NSString stringWithFormat:@"￥%@分", kStrongSelf.kTextField2.text];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:kInputMoneyLabelStr];
            [attributedStr addAttribute:NSFontAttributeName value:SystemBoldFontAll(70) range:NSMakeRange(kInputMoneyLabelStr.length-1, 1)];
            [attributedStr addAttribute:NSFontAttributeName value:SystemBoldFontAll(70) range:NSMakeRange(0, 1)];
            alertController.kInputMoneyLabel.attributedText = attributedStr;
            
            [kStrongSelf presentViewController:alertController animated:YES completion:nil];
        }else{
            IntercalatePaymentPassWordViewController *viewController = [IntercalatePaymentPassWordViewController new];
            viewController.title = @"设置新密码";
            [kStrongSelf.navigationController pushViewController:viewController animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.kTextField1 resignFirstResponder];
        [kStrongSelf.kTextField2 resignFirstResponder];
    }];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}
- (void)_initReactiveCocoa {
    kWeakfy(self);
    id<NSFastEnumeration> signals = @[self.kTextField2.rac_textSignal];
    RACSignal *signal = [RACSignal combineLatest:signals reduce:^id{
        kStrongfy(kWeakSelf);
        if ([kStrongSelf.kTextField2.text integerValue] > [KUserInfoDataModel shareInstance].kUserInfoModel.safebalance) {
            kStrongSelf.kTextField2.text = [NSString stringWithFormat:@"%ld", [KUserInfoDataModel shareInstance].kUserInfoModel.safebalance];
        }
        if ([kStrongSelf.kTextField2.text integerValue] <= 0) {
            kStrongSelf.kLabel.text = @"￥0";
        }else{
            kStrongSelf.kLabel.text = [NSString stringWithFormat:@"￥%@", kStrongSelf.kTextField2.text];
            return @YES;
        }
        return @NO;
    }];
    RAC(self.kCompleteButton, backgroundColor) = [signal map:^id(NSNumber *textfieldSignalValid) {
        return[textfieldSignalValid boolValue] ? KRGB(243.0, 107.0, 42.0, 1) : KRGB(238, 197, 177, 1);
    }];
    RAC(self.kCompleteButton, enabled) = [signal map:^id(id value) {
        return value;
    }];
}
- (void)_initReloadForKUserInfoDataModel {
    kWeakfy(self);
    [[KUserInfoDataModel shareInstance] setKStrongBoxViewControllerSuccessBlock:^(NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            kStrongSelf.kTextField1.text = [NSString stringWithFormat:@"%ld", kUserInfoModel.safebalance];
        }];
    }];
    [[KUserInfoDataModel shareInstance] setKStrongBoxViewControllerFailureBlock:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
        }];
    }];
}
- (void)dealloc {
    [KUserInfoDataModel shareInstance].kStrongBoxViewControllerSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kStrongBoxViewControllerFailureBlock = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [KUserInfoDataModel reload:ResponseDataStyleAfterRequest];
    [self.kTextField2 becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.kTextField2 resignFirstResponder];
}
#pragma mark - Request
- (void)sendRequestForStrongBoxTurnOut:(NSString *)password {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"tobalance" forKey:@"action"];
    [parameters setValue:password forKey:@"paypassword"];
    [parameters setObject:_kTextField2.text forKey:@"money"];
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/safechange"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KUserInfoDataModel reload:ResponseDataStyleDirectRequest success:^(NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel) {
            [KMBProgressHUDManager hide];
            dispatch_async(dispatch_get_main_queue(), ^{
                kStrongfy(kWeakSelf);
                [kStrongSelf.navigationController.view hideToasts];
                [kStrongSelf.navigationController.view makeToast:kBasicModel.message duration:kToastDurationTime position:CSToastPositionBottom];
                [kStrongSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
            [KGlobalUtils getMainThread:^{
                [KMBProgressHUDManager hide];
                kStrongfy(kWeakSelf);
                [kStrongSelf.view hideToasts];
                [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
            }];
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
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return KScreenL(330);
    }
    return KScreenL(160);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KScreenL(60);
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 3) {
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenW, 0, 0);
        [cell.contentView addSubview:self.kCompleteButton];
        CGFloat kCompleteButton_leftAndRight = KScreenL(156);
        CGFloat kCompleteButton_height = KScreenL(130);
        _kCompleteButton.layer.cornerRadius = kCompleteButton_height/2;
        [_kCompleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(kCompleteButton_leftAndRight);
            make.right.equalTo(cell.contentView).offset(-kCompleteButton_leftAndRight);
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.height.mas_equalTo(kCompleteButton_height);
        }];
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenW, 0, 0);
    }else if (indexPath.row == 2) {
        [cell.contentView addSubview:self.kLabel];
        CGFloat kLabel_Bottom = KScreenL(90);
        [_kLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView).offset(-kLabel_Bottom);
        }];
        
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenW, 0, 0);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        KTextField *kTextField;
        if (indexPath.row == 0) {
            kTextField = self.kTextField1;
        }else if (indexPath.row == 1) {
            kTextField = self.kTextField2;
        }
        
        [cell.contentView addSubview:kTextField];
        CGFloat textField_leftAndright = KScreenL(70);
        [kTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(textField_leftAndright);
            make.right.equalTo(cell.contentView).offset(-textField_leftAndright);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return cell;
}
#pragma mark - Lazyloading
- (UILabel *)kLabel {
    if (!_kLabel) {
        _kLabel = [UILabel new];
        _kLabel.textColor = KRGB(33, 33, 33, 1);
        _kLabel.font = SystemFontAll(150);
        _kLabel.numberOfLines = 1;
    }
    return _kLabel;
}
- (UIButton *)kCompleteButton {
    if (!_kCompleteButton) {
        _kCompleteButton = [[UIButton alloc] init];
        [_kCompleteButton setTitle:@"确定转到身上分" forState:UIControlStateNormal];
        _kCompleteButton.backgroundColor = KRGB(243.0, 107.0, 42.0, 1);
        _kCompleteButton.titleLabel.font = SystemFontAll(58);
    }
    return _kCompleteButton;
}
- (KTextField *)kTextField1 {
    if (!_kTextField1) {
        _kTextField1 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldLeftView];
        _kTextField1.font = SystemFontAll(54);
        _kTextField1.textColor = KDLColoc;
        _kTextField1.tintColor = KRGB(33, 33, 33, 1);
        _kTextField1.textAlignment = NSTextAlignmentLeft;
        _kTextField1.keyboardType = UIKeyboardTypeDefault;
        _kTextField1.enabled = NO;
        _kTextField1.isHiddenClearButtonMode = NO;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"保险箱";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(243, 107, 42, 1);
        CGFloat label_width = _leftViewFromTextField_Width;
        CGFloat label_height = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        label.frame = CGRectMake(0, 0, label_width, label_height);
        label.textAlignment = NSTextAlignmentLeft;
        [label justifyAlignmentFromLabel];
        _kTextField1.kLeftPositionOffset = label_width + KScreenL(30);
        _kTextField1.leftView = label;
    }
    return _kTextField1;
}
- (KTextField *)kTextField2 {
    if (!_kTextField2) {
        _kTextField2 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldLeftView];
        _kTextField2.font = SystemFontAll(54);
        _kTextField2.textColor = KRGB(33, 33, 33, 1);
        _kTextField2.tintColor = KRGB(33, 33, 33, 1);
        _kTextField2.textAlignment = NSTextAlignmentLeft;
        _kTextField2.keyboardType = UIKeyboardTypeNumberPad;
        _kTextField2.iSAddToolbar = YES;
        _kTextField2.placeholder = @"请输入金额";
        [_kTextField2 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField2.isHiddenClearButtonMode = NO;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"金额";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(243, 107, 42, 1);
        CGFloat label_width = _leftViewFromTextField_Width;
        CGFloat label_height = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        label.frame = CGRectMake(0, 0, label_width, label_height);
        label.textAlignment = NSTextAlignmentLeft;
        [label justifyAlignmentFromLabel];
        _kTextField2.kLeftPositionOffset = label_width + KScreenL(30);
        _kTextField2.leftView = label;
    }
    return _kTextField2;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = YES;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
