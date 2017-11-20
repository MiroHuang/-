//
//  KPublicOtherMemberInfoViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/9.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KPublicOtherMemberInfoViewController.h"

@interface KPublicOtherMemberInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *kImageView;
@property (nonatomic, strong) UILabel *kLabel1;
@property (nonatomic, strong) UILabel *kLabel2;
@property (nonatomic, strong) KTextField *kTextField;
@property (nonatomic, strong) UISwitch *kSwitch;
@property (nonatomic, strong) KRoomUserModel *kRoomUserModel;
@end

@implementation KPublicOtherMemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initTableView];
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (!_kRoomUserModel) {
        [self sendRequestForGetUserInfo];
    }
}
#pragma mark - Method
- (void)sendRequestForGetUserInfo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_targetId forKey:@"uuid"];
    [KMBProgressHUDManager showHUDAtViewController];
    kWeakfy(self);
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/stake/getuserinfo"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        kStrongfy(kWeakSelf);
        kStrongSelf.kRoomUserModel = [KRoomUserModel yy_modelWithJSON:kBasicModel.data];
        [KGlobalUtils getMainThread:^{
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            [kStrongSelf.tableView reloadData];
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
    if (!_kRoomUserModel) {
        return 0;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        return KScreenL(240);
    }
    return KScreenL(160);
}
- (void)configureUITableViewCell:(UITableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    UIView *rightView;
    
    UILabel *kLeftLabel = [UILabel new];
    kLeftLabel.textColor = KRGB(33, 33, 33, 1);
    kLeftLabel.font = SystemFontAll(54);
    kLeftLabel.numberOfLines = 1;
    
    if (indexPath.row == 0) {
        kLeftLabel.text = @"头像";
        rightView = self.kImageView;
        [_kImageView sd_setImageWithURL:[NSURL URLWithString:_kRoomUserModel.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _kImageView.backgroundColor = RandomColor;
    }else if (indexPath.row == 1) {
        kLeftLabel.text = @"ID";
        rightView = self.kLabel1;
        _kLabel1.text = _kRoomUserModel.userid;
    }else{
        kLeftLabel.text = @"昵称";
        rightView = self.kLabel2;
        _kLabel2.text = _kRoomUserModel.nickname;
    }
    
    [cell.contentView addSubview:kLeftLabel];
    CGFloat kLeftLabel_Left = KScreenL(45);
    [kLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(kLeftLabel_Left);
        make.centerY.equalTo(cell.contentView);
    }];
    
    [cell.contentView addSubview:rightView];
    CGFloat rightView_right = KScreenL(70);
    CGFloat rightView_WidthAndHeight = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        rightView_WidthAndHeight = KScreenL(200);
        rightView.layer.cornerRadius = 5.f;
    }
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kLeftLabel.mas_right);
        make.right.equalTo(cell).offset(-rightView_right);
        make.centerY.equalTo(cell.mas_centerY);
        if (rightView_WidthAndHeight != 0) {
            make.width.height.mas_equalTo(rightView_WidthAndHeight);
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [self configureUITableViewCell:cell atIndexPAth:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Lazyloading
- (UIImageView *)kImageView {
    if (!_kImageView) {
        _kImageView = [UIImageView new];
    }
    return _kImageView;
}
- (UILabel *)kLabel1 {
    if (!_kLabel1) {
        _kLabel1 = [UILabel new];
        _kLabel1.font = SystemFontAll(54);
        _kLabel1.textColor = KRGB(33, 33, 33, 1);
    }
    return _kLabel1;
}
- (UILabel *)kLabel2 {
    if (!_kLabel2) {
        _kLabel2 = [UILabel new];
        _kLabel2.font = SystemFontAll(54);
        _kLabel2.textColor = KRGB(33, 33, 33, 1);
    }
    return _kLabel2;
}
- (KTextField *)kTextField {
    if (!_kTextField) {
        _kTextField = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField.font = SystemFontAll(54);
        _kTextField.textColor = KRGB(33, 33, 33, 1);
        _kTextField.tintColor = KRGB(33, 33, 33, 1);
        _kTextField.textAlignment = NSTextAlignmentRight;
        _kTextField.keyboardType = UIKeyboardTypeDefault;
        _kTextField.placeholder = @"请输入备注";
        [_kTextField setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField.isHiddenClearButtonMode = YES;
    }
    return _kTextField;
}
- (UISwitch *)kSwitch {
    if (!_kSwitch) {
        _kSwitch = [UISwitch new];
    }
    return _kSwitch;
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
