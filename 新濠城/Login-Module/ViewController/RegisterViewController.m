//
//  RegisterViewController.m
//  新濠城
//
//  Created by XHC on 2017/9/26.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "RegisterViewController.h"
#import "UILabel+KLabel.h"
#import "NSString+KString.h"
#import "UIViewController+KVC.h"
#import "UIImage+KImage.h"

@interface RegisterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) KTextField *textField1;
@property (nonatomic, strong) KTextField *textField2;
@property (nonatomic, strong) KTextField *textField3;
@property (nonatomic, strong) KTextField *textField4;
@property (nonatomic, strong) KTextField *textField5;
@property (nonatomic, assign) CGFloat leftViewFromTextField_Width;
@property (nonatomic, copy) UIFont *leftViewFromTextField_Font;
@property (nonatomic, strong) UIButton *button1;
@end

@implementation RegisterViewController

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
    _leftViewFromTextField_Width = [NSString checkSizeFromString:@"确认密码" Font:_leftViewFromTextField_Font Width:MAXFLOAT Height:MAXFLOAT].width;
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}
- (void)_initTableHeaderView {
    CGFloat headerView_width = KScreenW;
    CGFloat headerView_height = KScreenL(272);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView_width, headerView_height)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;

    [headerView addSubview:self.label1];
    CGFloat label1_Top = KScreenL(72);
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(label1_Top);
        make.centerX.equalTo(headerView);
    }];
    
    [_label1 insertImageAtTheLeftSideWithTitle:[NSString stringWithFormat:@"%@ 邀请您注册", _nicknameStr] TitleColor:[UIColor blackColor] TitleFont:SystemFontAll(54) InsertImage:[UIImage imageNamed:@"placeholder"] imageSize:CGSizeMake(KScreenL(150), KScreenL(150)) ImageMargin:KScreenL(45)];
    kWeakfy(self);
    [[KImageDownloader shareInstance] startDownloadImageWithImageUrl:_avatarStr completion:^(UIImage *image) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.label1 insertImageAtTheLeftSideWithTitle:[NSString stringWithFormat:@"%@ 邀请您注册", kStrongSelf.nicknameStr] TitleColor:[UIColor blackColor] TitleFont:SystemFontAll(54) InsertImage:image imageSize:CGSizeMake(KScreenL(150), KScreenL(150)) ImageMargin:KScreenL(45)];
    }];
}
- (void)_initBlocksKit {
    kWeakfy(self);
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.textField1 resignFirstResponder];
        [kStrongSelf.textField2 resignFirstResponder];
        [kStrongSelf.textField3 resignFirstResponder];
        [kStrongSelf.textField4 resignFirstResponder];
        [kStrongSelf.textField5 resignFirstResponder];
    }];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.button1 bk_addEventHandler:^(id sender) {
        kStrongfy(kWeakSelf);
        if ([kStrongSelf checkRequestForRegister]) {
            [kStrongSelf sendRequestForRegister];
        }
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)_initReactiveCocoa {
    kWeakfy(self);
    id<NSFastEnumeration> signals = @[self.textField1.rac_textSignal, self.textField2.rac_textSignal, self.textField3.rac_textSignal, self.textField4.rac_textSignal, self.textField5.rac_textSignal];
    RACSignal *signal = [RACSignal combineLatest:signals reduce:^id{
        kStrongfy(kWeakSelf);
        if (kStrongSelf.textField1.text.length >= PhoneNumber_Length) {
            kStrongSelf.textField1.text = [kStrongSelf.textField1.text substringToIndex:PhoneNumber_Length];
        }
        if (kStrongSelf.textField2.text.length >= AccountName_Max_Length) {
            kStrongSelf.textField2.text = [kStrongSelf.textField2.text substringToIndex:AccountName_Max_Length];
        }
        if (kStrongSelf.textField3.text.length >= NickName_Max_Length) {
            kStrongSelf.textField3.text = [kStrongSelf.textField3.text substringToIndex:NickName_Max_Length];
        }
        if (kStrongSelf.textField4.text.length >= PassWord_Max_Length) {
            kStrongSelf.textField4.text = [kStrongSelf.textField4.text substringToIndex:PassWord_Max_Length];
        }
        if (kStrongSelf.textField5.text.length >= PassWord_Max_Length) {
            kStrongSelf.textField5.text = [kStrongSelf.textField5.text substringToIndex:PassWord_Max_Length];
        }
        
        if ((kStrongSelf.textField1.text.length == 0 || kStrongSelf.textField1.text.length == PhoneNumber_Length) &&
                kStrongSelf.textField2.text.length >= AccountName_Min_Length &&
                kStrongSelf.textField3.text.length >= NickName_Min_Length &&
                kStrongSelf.textField4.text.length >= PassWord_Min_Length &&
                kStrongSelf.textField5.text.length >= PassWord_Min_Length) {
            return @YES;
        }
        return @NO;
    }];
    RAC(self.button1, backgroundColor) = [signal map:^id(NSNumber *textfieldSignalValid) {
        return[textfieldSignalValid boolValue] ? KRGB(243.0, 107.0, 42.0, 1) : KRGB(238, 197, 177, 1);
    }];
    RAC(self.button1, enabled) = [signal map:^id(id value) {
        return value;
    }];
}
#pragma mark - Method
- (BOOL)checkRequestForRegister {
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    [_textField4 resignFirstResponder];
    [_textField5 resignFirstResponder];
    
    kWeakfy(self);
    if (self.textField1.text.length != 0 && ![self.textField1.text hasPrefix:@"1"] ) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:KPhoneInputIllegalCharacter duration:kToastDurationTime position:CSToastPositionBottom];
        }];
        return NO;
    }
    
    if (![KValidateObject JudgeRegularExpression:FirstLetterIsEnglish content:self.textField2.text] ||
            ![KValidateObject JudgeRegularExpression:OnlyContainLettersAndNumbers content:self.textField2.text]) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:KAccountNameInputIllegalCharacter duration:kToastDurationTime position:CSToastPositionBottom];
        }];
        return NO;
    }
    if (![self.textField4.text isEqualToString:self.textField5.text]) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:KPassWordInputIllegalCharacter duration:kToastDurationTime position:CSToastPositionBottom];
        }];
        return NO;
    }
    if (![KValidateObject JudgeRegularExpression:OnlyContainChineseAndLettersAndNumbers content:self.textField4.text]) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:KPassWordAtypismInputError duration:kToastDurationTime position:CSToastPositionBottom];
        }];
        return NO;
    }
    return YES;
}
#pragma mark - Request
- (void)sendRequestForLogin:(NSDictionary *)dic {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:dic[@"username"] forKey:@"username"];
    [parameters setValue:dic[@"password"] forKey:@"password"];
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:KRequestForUser_Login parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KMBProgressHUDManager hide];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoginSuccess"];
        [[NSUserDefaults standardUserDefaults] setValue:((NSDictionary *)kBasicModel.data)[@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setValue:((NSDictionary *)kBasicModel.data)[@"rongcloudtoken"] forKey:@"rongcloudtoken"];
        [[KRongCloudManager shareInstance] loginRongCloud];
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            [kStrongSelf resetRootViewController:[UIViewController setRootViewController] byAnimated:YES];
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
- (void)sendRequestForRegister {
    __block NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_textField1.text forKey:@"phone"];
    [parameters setValue:_textField2.text forKey:@"username"];
    [parameters setValue:_textField3.text forKey:@"nickname"];
    [parameters setValue:_textField4.text forKey:@"password"];
    [parameters setValue:_qrcodeStr forKey:@"qrcode"];
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/user/userregister"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KMBProgressHUDManager hide];
        kStrongfy(kWeakSelf);
        [kStrongSelf.navigationController popToRootViewControllerAnimated:YES];
        //[kStrongSelf sendRequestForLogin:parameters];
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
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return KScreenL(240);
    }
    return KScreenL(160);
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
    
    if (indexPath.row == 5) {
        [cell.contentView addSubview:self.button1];
        CGFloat button1_leftAndRight = KScreenL(156);
        CGFloat button1_height = KScreenL(130);
        _button1.layer.cornerRadius = button1_height/2;
        [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(button1_leftAndRight);
            make.right.equalTo(cell.contentView).offset(-button1_leftAndRight);
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.height.mas_equalTo(button1_height);
        }];
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenW, 0, 0);
    }else{
        KTextField *textField;
        if (indexPath.row == 0) {
            textField = self.textField2;
        }else if (indexPath.row == 1) {
            textField = self.textField3;
        }else if (indexPath.row == 2) {
            textField = self.textField4;
        }else if (indexPath.row == 3) {
            textField = self.textField5;
        }else if (indexPath.row == 4) {
            textField = self.textField1;
        }
        CGFloat textField_leftAndright = KScreenL(45);
        CGFloat textField_bottom = KScreenL(28);
        [cell.contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(textField_leftAndright);
            make.right.equalTo(cell.contentView).offset(-textField_leftAndright);
            make.bottom.equalTo(cell.contentView).offset(-textField_bottom);
        }];
        cell.separatorInset = UIEdgeInsetsMake(0, textField_leftAndright, 0, textField_leftAndright);
    }
    
    return cell;
}
#pragma mark - Lazyloading
- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [UIImageView new];
    }
    return _imageView1;
}
- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [UILabel new];
    }
    return _label1;
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
- (KTextField *)textField1 {
    if (!_textField1) {
        _textField1 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldLeftView];
        _textField1.font = SystemFontAll(58);
        _textField1.textColor = KRGB(0, 0, 0, 1);
        _textField1.tintColor = KRGB(0, 0, 0, 1);
        _textField1.textAlignment = NSTextAlignmentLeft;
        _textField1.keyboardType = UIKeyboardTypeNumberPad;
        _textField1.placeholder = @"请输入手机号(选填)";
        [_textField1 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        [_textField1 setValue:SystemFontAll(58) forKeyPath:@"_placeholderLabel.font"];
        _textField1.iSAddToolbar = YES;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"手机号";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(33, 33, 33, 1);
        CGFloat label_width = _leftViewFromTextField_Width;
        CGFloat label_height = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        label.frame = CGRectMake(0, 0, label_width, label_height);
        label.textAlignment = NSTextAlignmentLeft;
        [label justifyAlignmentFromLabel];
        _textField1.kLeftPositionOffset = label_width + KScreenL(30);
        _textField1.leftView = label;
    }
    return _textField1;
}
- (KTextField *)textField2 {
    if (!_textField2) {
        _textField2 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldLeftView];
        _textField2.font = SystemFontAll(58);
        _textField2.textColor = KRGB(0, 0, 0, 1);
        _textField2.tintColor = KRGB(0, 0, 0, 1);
        _textField2.textAlignment = NSTextAlignmentLeft;
        _textField2.keyboardType = UIKeyboardTypeDefault;
        _textField2.placeholder = @"账号限5~12位(字母开头)";
        [_textField2 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        [_textField2 setValue:SystemFontAll(58) forKeyPath:@"_placeholderLabel.font"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"账号";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(33, 33, 33, 1);
        CGFloat label_width = _leftViewFromTextField_Width;
        CGFloat label_height = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        label.frame = CGRectMake(0, 0, label_width, label_height);
        label.textAlignment = NSTextAlignmentLeft;
        [label justifyAlignmentFromLabel];
        _textField2.kLeftPositionOffset = label_width + KScreenL(30);
        _textField2.leftView = label;
    }
    return _textField2;
}
- (KTextField *)textField3 {
    if (!_textField3) {
        _textField3 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldLeftView];
        _textField3.font = SystemFontAll(58);
        _textField3.textColor = KRGB(0, 0, 0, 1);
        _textField3.tintColor = KRGB(0, 0, 0, 1);
        _textField3.textAlignment = NSTextAlignmentLeft;
        _textField3.keyboardType = UIKeyboardTypeDefault;
        _textField3.placeholder = @"昵称限2~12位";
        [_textField3 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        [_textField3 setValue:SystemFontAll(58) forKeyPath:@"_placeholderLabel.font"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"昵称";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(33, 33, 33, 1);
        CGFloat label_width = _leftViewFromTextField_Width;
        CGFloat label_height = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        label.frame = CGRectMake(0, 0, label_width, label_height);
        label.textAlignment = NSTextAlignmentLeft;
        [label justifyAlignmentFromLabel];
        _textField3.kLeftPositionOffset = label_width + KScreenL(30);
        _textField3.leftView = label;
    }
    return _textField3;
}
- (KTextField *)textField4 {
    if (!_textField4) {
        _textField4 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldLeftView];
        _textField4.font = SystemFontAll(58);
        _textField4.textColor = KRGB(0, 0, 0, 1);
        _textField4.tintColor = KRGB(0, 0, 0, 1);
        _textField4.textAlignment = NSTextAlignmentLeft;
        _textField4.keyboardType = UIKeyboardTypeDefault;
        _textField4.secureTextEntry = YES;
        _textField4.placeholder = @"请输入密码";
        [_textField4 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        [_textField4 setValue:SystemFontAll(58) forKeyPath:@"_placeholderLabel.font"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"密码";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(33, 33, 33, 1);
        CGFloat label_width = _leftViewFromTextField_Width;
        CGFloat label_height = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        label.frame = CGRectMake(0, 0, label_width, label_height);
        label.textAlignment = NSTextAlignmentLeft;
        [label justifyAlignmentFromLabel];
        _textField4.kLeftPositionOffset = label_width + KScreenL(30);
        _textField4.leftView = label;
    }
    return _textField4;
}
- (KTextField *)textField5 {
    if (!_textField5) {
        _textField5 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldLeftView];
        _textField5.font = SystemFontAll(58);
        _textField5.textColor = KRGB(0, 0, 0, 1);
        _textField5.tintColor = KRGB(0, 0, 0, 1);
        _textField5.textAlignment = NSTextAlignmentLeft;
        _textField5.keyboardType = UIKeyboardTypeDefault;
        _textField5.secureTextEntry = YES;
        _textField5.placeholder = @"请确认密码";
        [_textField5 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        [_textField5 setValue:SystemFontAll(58) forKeyPath:@"_placeholderLabel.font"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"确认密码";
        label.font = _leftViewFromTextField_Font;
        label.textColor = KRGB(33, 33, 33, 1);
        CGFloat label_width = _leftViewFromTextField_Width;
        CGFloat label_height = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        label.frame = CGRectMake(0, 0, label_width, label_height);
        label.textAlignment = NSTextAlignmentLeft;
        [label justifyAlignmentFromLabel];
        _textField5.kLeftPositionOffset = label_width + KScreenL(30);
        _textField5.leftView = label;
    }
    return _textField5;
}
- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [[UIButton alloc] init];
        [_button1 setTitle:@"注      册" forState:UIControlStateNormal];
        [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button1.titleLabel.font = SystemFontAll(58);
    }
    return _button1;
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
