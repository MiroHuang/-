//
//  WithdrawalsViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/19.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "WithdrawalStatusViewController.h"
#import "UIViewController+KVC.h"

@interface WithdrawalsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KTextField *kTextField1;
@property (nonatomic, strong) KTextField *kTextField2;
@property (nonatomic, strong) KTextField *kTextField3;
@property (nonatomic, strong) KTextField *kTextField4;

@property (nonatomic, strong) UILabel *kLabel1;
@property (nonatomic, strong) UILabel *kLabel2;
@property (nonatomic, strong) UILabel *kLabel3;
@property (nonatomic, strong) UILabel *kLabel4;

@property (nonatomic, strong) UIButton *kCompleteButton;
@property (nonatomic, strong) UILabel *kPromptLabel;
@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initTableView];
    [self _initBlocksKit];
    [self _initReactiveCocoa];
    [self _initReloadForKUserInfoDataModel];
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
        [kStrongSelf.kTextField1 resignFirstResponder];
        [kStrongSelf.kTextField2 resignFirstResponder];
        [kStrongSelf.kTextField3 resignFirstResponder];
        [kStrongSelf.kTextField4 resignFirstResponder];
        KPayAlertViewController *alertController = [KPayAlertViewController showQyjCustomerAlertViewController:^(NSString *resultVault) {
            kStrongfy(kWeakSelf);
            [kStrongSelf sendRequestForUserWithdraw:resultVault];
        }];

        NSString *kInputMoneyLabelStr = [NSString stringWithFormat:@"￥%@分", kStrongSelf.kTextField4.text];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:kInputMoneyLabelStr];
        [attributedStr addAttribute:NSFontAttributeName value:SystemBoldFontAll(70) range:NSMakeRange(kInputMoneyLabelStr.length-1, 1)];
        [attributedStr addAttribute:NSFontAttributeName value:SystemBoldFontAll(70) range:NSMakeRange(0, 1)];
        alertController.kInputMoneyLabel.attributedText = attributedStr;
        
        [kStrongSelf presentViewController:alertController animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.kTextField1 resignFirstResponder];
        [kStrongSelf.kTextField2 resignFirstResponder];
        [kStrongSelf.kTextField3 resignFirstResponder];
        [kStrongSelf.kTextField4 resignFirstResponder];
    }];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}
- (void)_initReactiveCocoa {
    kWeakfy(self);
    id<NSFastEnumeration> signals = @[self.kTextField4.rac_textSignal];
    RACSignal *signal = [RACSignal combineLatest:signals reduce:^id{
        kStrongfy(kWeakSelf);
        if ([kStrongSelf.kTextField4.text integerValue] > [KUserInfoDataModel shareInstance].kUserInfoModel.balance) {
            kStrongSelf.kTextField4.text = [NSString stringWithFormat:@"%ld", [KUserInfoDataModel shareInstance].kUserInfoModel.safebalance];
        }
        if ([kStrongSelf.kTextField4.text integerValue] > 0) {
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
            kStrongSelf.kTextField1.text = [NSString stringWithFormat:@"%ld", kUserInfoModel.balance];
            kStrongSelf.kTextField2.text = [NSString stringWithFormat:@"%ld", kUserInfoModel.safebalance];
            kStrongSelf.kTextField3.text = [NSString stringWithFormat:@"%ld", kUserInfoModel.safebalance];
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
}
#pragma mark - Request
- (void)sendRequestForUserWithdraw:(NSString *)password {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:password forKey:@"paypassword"];
    [parameters setValue:_kTextField4.text forKey:@"money"];
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/userwithdraw"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [KMBProgressHUDManager hide];
            WithdrawalStatusViewController *viewController = [WithdrawalStatusViewController new];
            viewController.title = @"提现";
            [kStrongSelf updateRootViewControllerByAddViewController:viewController byDeleteViewController:kStrongSelf byAnimated:YES];
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
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KScreenL(60);
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return KScreenL(360);
    }else{
        return KScreenL(160);
    }
}
- (void)configureUITableViewCell:(UITableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenW, 0, 0);
        [cell.contentView addSubview:self.kCompleteButton];
        CGFloat kCompleteButton_leftAndRight = KScreenL(156);
        CGFloat kCompleteButton_height = KScreenL(130);
        CGFloat kCompleteButton_Top = KScreenL(96);
        _kCompleteButton.layer.cornerRadius = kCompleteButton_height/2;
        [_kCompleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(kCompleteButton_leftAndRight);
            make.right.equalTo(cell.contentView).offset(-kCompleteButton_leftAndRight);
            make.top.equalTo(cell.contentView).offset(kCompleteButton_Top);
            make.height.mas_equalTo(kCompleteButton_height);
        }];
        
        [cell.contentView addSubview:self.kPromptLabel];
        [_kPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(_kCompleteButton);
            make.top.equalTo(_kCompleteButton.mas_bottom);
            make.bottom.equalTo(cell.contentView);
        }];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *kLeftLabel = [UILabel new];
        kLeftLabel.textColor = KRGB(33, 33, 33, 1);
        kLeftLabel.font = SystemFontAll(54);
        kLeftLabel.numberOfLines = 1;
        
        KTextField *kTextField;
        if (indexPath.row == 0) {
            kLeftLabel.text = @"身上分";
            kTextField = self.kTextField1;
        }else if (indexPath.row == 1) {
            kLeftLabel.text = @"保险箱";
            kTextField = self.kTextField2;
        }else if (indexPath.row == 2) {
            kLeftLabel.text = @"可提分数";
            kTextField = self.kTextField3;
        }else if (indexPath.row == 3) {
            kLeftLabel.text = @"提现分数";
            kTextField = self.kTextField4;
        }
        
        [cell.contentView addSubview:kLeftLabel];
        CGFloat kLeftLabel_Left = KScreenL(45);
        [kLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(kLeftLabel_Left);
            make.centerY.equalTo(cell.contentView);
        }];
        
        
        [cell.contentView addSubview:kTextField];
        CGFloat kTextField_right = KScreenL(45);
        [kTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kLeftLabel.mas_right);
            make.right.equalTo(cell.contentView).offset(-kTextField_right);
            make.centerY.equalTo(cell.contentView);
        }];
    }
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [self configureUITableViewCell:cell atIndexPAth:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Lazyloading
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
- (UIButton *)kCompleteButton {
    if (!_kCompleteButton) {
        _kCompleteButton = [[UIButton alloc] init];
        [_kCompleteButton setTitle:@"确定提现" forState:UIControlStateNormal];
        _kCompleteButton.backgroundColor = KRGB(243.0, 107.0, 42.0, 1);
        _kCompleteButton.titleLabel.font = SystemFontAll(58);
    }
    return _kCompleteButton;
}
- (UILabel *)kPromptLabel {
    if (!_kPromptLabel) {
        _kPromptLabel = [UILabel new];
        _kPromptLabel.text = @"注：提现后提现分数会冻结，工作人员会在2~3个工作日处理";
        _kPromptLabel.textColor = KRGB(100, 100, 100, 1);
        _kPromptLabel.font = SystemFontAll(45);
        _kPromptLabel.numberOfLines = 0;
    }
    return _kPromptLabel;
}
- (KTextField *)kTextField1 {
    if (!_kTextField1) {
        _kTextField1 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField1.font = SystemFontAll(54);
        _kTextField1.textColor = KRGB(33, 33, 33, 1);
        _kTextField1.tintColor = KRGB(33, 33, 33, 1);
        _kTextField1.textAlignment = NSTextAlignmentRight;
        _kTextField1.keyboardType = UIKeyboardTypeDefault;
        _kTextField1.enabled = NO;
        _kTextField1.placeholder = @"";
        [_kTextField1 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField1.isHiddenClearButtonMode = YES;
    }
    return _kTextField1;
}
- (KTextField *)kTextField2 {
    if (!_kTextField2) {
        _kTextField2 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField2.font = SystemFontAll(54);
        _kTextField2.textColor = KRGB(33, 33, 33, 1);
        _kTextField2.tintColor = KRGB(33, 33, 33, 1);
        _kTextField2.textAlignment = NSTextAlignmentRight;
        _kTextField2.keyboardType = UIKeyboardTypeDefault;
        _kTextField2.enabled = NO;
        _kTextField2.placeholder = @"";
        [_kTextField2 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField2.isHiddenClearButtonMode = YES;
    }
    return _kTextField2;
}
- (KTextField *)kTextField3 {
    if (!_kTextField3) {
        _kTextField3 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField3.font = SystemFontAll(54);
        _kTextField3.textColor = KRGB(33, 33, 33, 1);
        _kTextField3.tintColor = KRGB(33, 33, 33, 1);
        _kTextField3.textAlignment = NSTextAlignmentRight;
        _kTextField3.keyboardType = UIKeyboardTypeDefault;
        _kTextField3.enabled = NO;
        _kTextField3.placeholder = @"";
        [_kTextField3 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField3.isHiddenClearButtonMode = YES;
    }
    return _kTextField3;
}
- (KTextField *)kTextField4 {
    if (!_kTextField4) {
        _kTextField4 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField4.font = SystemFontAll(54);
        _kTextField4.textColor = KRGB(33, 33, 33, 1);
        _kTextField4.tintColor = KRGB(33, 33, 33, 1);
        _kTextField4.textAlignment = NSTextAlignmentRight;
        _kTextField4.keyboardType = UIKeyboardTypeNumberPad;
        _kTextField4.iSAddToolbar = YES;
        _kTextField4.placeholder = @"请输入你想提现的分数";
        [_kTextField4 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField4.isHiddenClearButtonMode = YES;
    }
    return _kTextField4;
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
