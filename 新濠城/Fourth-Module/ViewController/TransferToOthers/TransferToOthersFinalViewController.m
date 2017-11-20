//
//  TransferToOthersFinalViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "TransferToOthersFinalViewController.h"
#import "NSString+KString.h"
#import "UILabel+KLabel.h"

@interface TransferToOthersFinalViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KTextField *kTextField1;
@property (nonatomic, strong) UIButton *kCompleteButton;
@property (nonatomic, assign) CGFloat leftViewFromTextField_Width;
@property (nonatomic, copy) UIFont *leftViewFromTextField_Font;
@property (nonatomic, strong) UIImageView *kImageView1;
@property (nonatomic, strong) UILabel *kLabel1;
@property (nonatomic, strong) UILabel *kLabel2;
@end

@implementation TransferToOthersFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initializedData];
    [self _initTableView];
    [self _initTableHeaderView];
    [self _initBlocksKit];
    [self _initReactiveCocoa];
}
- (void)_initializedData {
    _leftViewFromTextField_Font = SystemFontAll(58);
    _leftViewFromTextField_Width = [NSString checkSizeFromString:@"支付密码" Font:_leftViewFromTextField_Font Width:MAXFLOAT Height:MAXFLOAT].width;
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}
- (void)_initTableHeaderView {
    CGFloat headerView_width = KScreenW;
    CGFloat headerView_height = KScreenL(480);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView_width, headerView_height)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    [headerView addSubview:self.kImageView1];
    CGFloat kImageView1_top = KScreenL(40);
    CGFloat kImageView1_widthAndHeight = KScreenL(150);
    _kImageView1.backgroundColor = RandomColor;
    _kImageView1.layer.masksToBounds = YES;
    _kImageView1.layer.cornerRadius = 5.f;
    [_kImageView1 sd_setImageWithURL:[NSURL URLWithString:_avatarStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [_kImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerView).offset(kImageView1_top);
        make.size.mas_equalTo(CGSizeMake(kImageView1_widthAndHeight, kImageView1_widthAndHeight));
    }];
    
    [headerView addSubview:self.kLabel1];
    NSString *kLabelStr = [NSString stringWithFormat:@"转给 %@ %@分", _nicknameStr, _moneyStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:kLabelStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:KRGB(243, 107, 42, 1) range:NSMakeRange(kLabelStr.length-_moneyStr.length-1, _moneyStr.length+1)];
    _kLabel1.attributedText = attributedStr;
    CGFloat kLabel1_top = KScreenL(35);
    [_kLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kImageView1.mas_bottom).offset(kLabel1_top);
        make.centerX.equalTo(_kImageView1);
    }];
    
    [headerView addSubview:self.kLabel2];
    _kLabel2.text = [NSString stringWithFormat:@"ID：%@", _touseridStr];
    CGFloat kLabel2_top = KScreenL(30);
    [_kLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kLabel1.mas_bottom).offset(kLabel2_top);
        make.centerX.equalTo(_kImageView1);
    }];
}
- (void)_initBlocksKit {
    kWeakfy(self);
    [self.kCompleteButton bk_addEventHandler:^(id sender) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.kTextField1 resignFirstResponder];
        [kStrongSelf sendRequestForTransferToOthers];
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)_initReactiveCocoa {
    kWeakfy(self);
    id<NSFastEnumeration> signals = @[self.kTextField1.rac_textSignal];
    RACSignal *signal = [RACSignal combineLatest:signals reduce:^id{
        kStrongfy(kWeakSelf);
        if (kStrongSelf.kTextField1.text.length >= PassWord_Max_Length) {
            kStrongSelf.kTextField1.text = [kStrongSelf.kTextField1.text substringToIndex:PassWord_Max_Length];
        }
        if (kStrongSelf.kTextField1.text.length >= PassWord_Min_Length) {
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
#pragma mark - Request
- (void)sendRequestForTransferToOthers {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_touseridStr forKey:@"touserid"];
    [parameters setValue:_moneyStr forKey:@"money"];
    [parameters setValue:_kTextField1.text forKey:@"paypassword"];
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/usertousersafebalance"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KMBProgressHUDManager hide];
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.navigationController popToRootViewControllerAnimated:YES];
            [kStrongSelf.navigationController.view hideToasts];
            [kStrongSelf.navigationController.view makeToast:kBasicModel.message duration:kToastDurationTime position:CSToastPositionBottom];
        });
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    if (indexPath.row == 2) {
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
    }else if (indexPath.row == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenW, 0, 0);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:self.kTextField1];
        CGFloat kTextField1_leftAndright = KScreenL(70);
        [_kTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(kTextField1_leftAndright);
            make.right.equalTo(cell.contentView).offset(-kTextField1_leftAndright);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    
    return cell;
}
#pragma mark - Lazyloading
- (UILabel *)kLabel1 {
    if (!_kLabel1) {
        _kLabel1 = [UILabel new];
        _kLabel1.textColor = KRGB(33, 33, 33, 1);
        _kLabel1.font = SystemFontAll(54);
    }
    return _kLabel1;
}
- (UILabel *)kLabel2 {
    if (!_kLabel2) {
        _kLabel2 = [UILabel new];
        _kLabel2.textColor = KRGB(199, 199, 199, 1);
        _kLabel2.font = SystemFontAll(45);
    }
    return _kLabel2;
}
- (UIImageView *)kImageView1 {
    if (!_kImageView1) {
        _kImageView1 = [UIImageView new];
    }
    return _kImageView1;
}
- (UIButton *)kCompleteButton {
    if (!_kCompleteButton) {
        _kCompleteButton = [[UIButton alloc] init];
        [_kCompleteButton setTitle:@"确定转分" forState:UIControlStateNormal];
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
        _kTextField1.placeholder = @"请输入支付密码";
        [_kTextField1 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField1.secureTextEntry = YES;
        _kTextField1.isHiddenClearButtonMode = NO;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"支付密码";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(33, 33, 33, 1);
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
