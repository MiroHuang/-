//
//  ToggleServerAddressViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "ToggleServerAddressViewController.h"
#import "NSString+KString.h"
#import "UILabel+KLabel.h"

@interface ToggleServerAddressViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KTextField *kTextField1;
@property (nonatomic, copy) NSArray *kRequestURLArr;
@property (nonatomic, assign) NSInteger isSelectedRow;
@end

@implementation ToggleServerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initializedData];
    [self _initNavigationBar];
    [self _initTableView];
}
- (void)_initializedData {
    [self reloadTableView];
}
- (void)_initNavigationBar {
    kWeakfy(self);
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"添加" style:UIBarButtonItemStylePlain handler:^(id sender) {
        kStrongfy(kWeakSelf);
        [kStrongSelf showAlertViewControllerForAddReqeustURL];
    }];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}
#pragma mark - Method
- (BOOL)checkRequestURLWithActiveRequestURLStr:(NSString *)activeRequestURLStr {
    __block BOOL isContain = NO;
    kWeakfy(self);
    [[[NSUserDefaults standardUserDefaults] objectForKey:@"RequestURLArr"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *jsonDic = (NSDictionary *)obj;
        kStrongfy(kWeakSelf);
        if ([jsonDic[@"RequestURL"] isEqualToString:activeRequestURLStr] && kStrongSelf.isSelectedRow != idx) {
            isContain = YES;
            *stop = YES;
        }
    }];
    if (isContain) {
        [self.view hideToasts];
        [self.view makeToast:@"该服务器地址已存在!" duration:kToastDurationTime position:CSToastPositionBottom];
        return NO;
    }
    return YES;
}
- (void)updateRequestURLWithIndexRow:(NSInteger)indexRow andActiveRequestURLStr:(NSString *)activeRequestURLStr {
    NSMutableArray *kRequestURLMuArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"RequestURLArr"]];
    NSMutableDictionary *jsonMuDic = [NSMutableDictionary dictionaryWithDictionary:kRequestURLMuArr[indexRow]];
    [jsonMuDic setObject:activeRequestURLStr forKey:@"RequestURL"];
    [kRequestURLMuArr replaceObjectAtIndex:indexRow withObject:jsonMuDic];
    [[NSUserDefaults standardUserDefaults] setObject:kRequestURLMuArr forKey:@"RequestURLArr"];
    
    [KRequestURLObject shareInstance].activeRequestURLStr = activeRequestURLStr;
    [self reloadTableView];
    
    [self reloadRequestURLWithActiveRequestURLStr:activeRequestURLStr];
}
- (void)deleteRequestURLWithIndexRow:(NSInteger)indexRow andActiveRequestURLStr:(NSString *)activeRequestURLStr {
    NSMutableArray *kRequestURLMuArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"RequestURLArr"]];
    NSMutableDictionary *jsonMuDic = [NSMutableDictionary dictionaryWithDictionary:kRequestURLMuArr[indexRow]];
    [kRequestURLMuArr removeObjectAtIndex:indexRow];
    [[NSUserDefaults standardUserDefaults] setObject:kRequestURLMuArr forKey:@"RequestURLArr"];
    
    if ([jsonMuDic[@"ISSelected"] boolValue]) {
        [KRequestURLObject shareInstance].activeRequestURLStr = kRequestURLMuArr.firstObject[@"RequestURL"];
    }
    [self reloadTableView];
}
- (void)addRequestURLWithActiveRequestURLStr:(NSString *)activeRequestURLStr {
    NSMutableArray *kRequestURLMuArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"RequestURLArr"]];
    NSDictionary *jsonDic = @{@"RequestURL":activeRequestURLStr, @"ISDefault":@NO, @"ISSelected":@NO};
    [kRequestURLMuArr addObject:jsonDic];
    [[NSUserDefaults standardUserDefaults] setObject:kRequestURLMuArr forKey:@"RequestURLArr"];
    
    [KRequestURLObject shareInstance].activeRequestURLStr = activeRequestURLStr;
    [self reloadTableView];
    
    [self reloadRequestURLWithActiveRequestURLStr:activeRequestURLStr];
}
- (void)reloadTableView {
    _isSelectedRow = -1;
    _kRequestURLArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"RequestURLArr"];
    [self.tableView reloadData];
}
- (void)showAlertViewControllerForAddReqeustURL {
    kWeakfy(self);
    __block UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加服务器地址" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        kStrongfy(kWeakSelf);
        UITextField *textField = alertController.textFields.firstObject;
        if ([kStrongSelf checkRequestURLWithActiveRequestURLStr:textField.text]) {
            if (![textField.text hasPrefix:@"https://"] && ![textField.text hasPrefix:@"http://"]) {
                textField.text = [NSString stringWithFormat:@"https://%@", textField.text];
            }
            [kStrongSelf addRequestURLWithActiveRequestURLStr:textField.text];
        }
    }];
    [alertController addAction:continueAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入服务器地址";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)reloadRequestURLWithActiveRequestURLStr:(NSString *)activeRequestURLStr  {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [KMBProgressHUDManager showHUDAtWindow];
    kWeakfy(self);
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", activeRequestURLStr, @"/api/user/qrcodevalidate"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KGlobalUtils getMainThread:^{
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:@"更换服务器成功！" duration:kToastDurationTime position:CSToastPositionBottom];
        }];

    } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        [KGlobalUtils getMainThread:^{
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            if (response && kBasicModel) {
                [kStrongSelf.view hideToasts];
                [kStrongSelf.view makeToast:@"更换服务器成功！" duration:kToastDurationTime position:CSToastPositionBottom];
            }else{
                [kStrongSelf.view hideToasts];
                [kStrongSelf.view makeToast:@"连接失败，地址错误，请重新确认地址！" duration:kToastDurationTime position:CSToastPositionBottom];
            }
        }];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _kRequestURLArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScreenL(140);
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
    
    if (_isSelectedRow == indexPath.row) {
        UIButton *kButton1 = [UIButton new];
        [kButton1 setTitle:@"删除" forState:UIControlStateNormal];
        [kButton1 setTitleColor:KRGB(100, 100, 100, 1) forState:UIControlStateNormal];
        kButton1.titleLabel.font = SystemFontAll(54);
        [cell.contentView addSubview:kButton1];
        CGFloat kButton1_Width = KScreenL(210);
        [kButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(cell.contentView);
            make.width.mas_equalTo(kButton1_Width);
        }];
        
        UIButton *kButton2 = [UIButton new];
        [kButton2 setTitle:@"完成" forState:UIControlStateNormal];
        [kButton2 setTitleColor:KRGB(100, 100, 100, 1) forState:UIControlStateNormal];
        kButton2.titleLabel.font = SystemFontAll(54);
        [cell.contentView addSubview:kButton2];
        CGFloat kButton2_Width = KScreenL(210);
        [kButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(cell.contentView);
            make.width.mas_equalTo(kButton2_Width);
        }];
        
        [cell.contentView addSubview:self.kTextField1];
        _kTextField1.text = _kRequestURLArr[indexPath.row][@"RequestURL"];
        [_kTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(kButton1.mas_right);
            make.right.equalTo(kButton2.mas_left);
        }];
        
        kWeakfy(self);
        [kButton1 bk_addEventHandler:^(id sender) {
            kStrongfy(kWeakSelf);
            [kStrongSelf.kTextField1 resignFirstResponder];
            if (kStrongSelf.isSelectedRow >= 0) {
                [kStrongSelf deleteRequestURLWithIndexRow:kStrongSelf.isSelectedRow andActiveRequestURLStr:kStrongSelf.kTextField1.text];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [kButton2 bk_addEventHandler:^(id sender) {
            kStrongfy(kWeakSelf);
            [kStrongSelf.kTextField1 resignFirstResponder];
            if (kStrongSelf.isSelectedRow >= 0) {
                if ([kStrongSelf checkRequestURLWithActiveRequestURLStr:kStrongSelf.kTextField1.text]) {
                    if (![kStrongSelf.kTextField1.text hasPrefix:@"https://"] && ![kStrongSelf.kTextField1.text hasPrefix:@"http://"]) {
                        kStrongSelf.kTextField1.text = [NSString stringWithFormat:@"https://%@", kStrongSelf.kTextField1.text];
                    }
                    [kStrongSelf updateRequestURLWithIndexRow:kStrongSelf.isSelectedRow andActiveRequestURLStr:kStrongSelf.kTextField1.text];
                }
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }else{
        UIView *kView1 = [UIView new];
        if ([_kRequestURLArr[indexPath.row][@"ISSelected"] boolValue]) {
            kView1.backgroundColor = KDLColoc;
        }else{
            kView1.backgroundColor = [UIColor clearColor];
        }
        [cell.contentView addSubview:kView1];
        CGFloat kView1_Length = KScreenL(30);
        CGFloat kView1_Left = KScreenL(45);
        kView1.layer.borderWidth = 1.f;
        kView1.layer.borderColor = KDLColoc.CGColor;
        kView1.layer.cornerRadius = kView1_Length/2;
        [kView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kView1_Length);
            make.left.equalTo(cell.contentView).offset(kView1_Left);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UILabel *kLabel1 = [UILabel new];
        kLabel1.font = SystemFontAll(54);
        kLabel1.textColor = KRGB(33, 33, 33, 1);
        kLabel1.numberOfLines = 1;
        kLabel1.text = _kRequestURLArr[indexPath.row][@"RequestURL"];
        [cell.contentView addSubview:kLabel1];
        CGFloat kLabel1_Right = KScreenL(45);
        CGFloat kLabel1_Left = KScreenL(15);
        [kLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kView1.mas_right).offset(kLabel1_Left);
            make.right.equalTo(cell.contentView).offset(-kLabel1_Right);
            make.centerY.equalTo(cell.contentView);
        }];
        
        if (![_kRequestURLArr[indexPath.row][@"ISDefault"] boolValue]) {
            UIButton *kButton1 = [UIButton new];
            [kButton1 setTitle:@"编辑" forState:UIControlStateNormal];
            [kButton1 setTitleColor:KRGB(33, 33, 33, 1) forState:UIControlStateNormal];
            kButton1.titleLabel.font = SystemFontAll(54);
            [cell.contentView addSubview:kButton1];
            CGFloat kButton1_Width = KScreenL(210);
            [kButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.equalTo(cell.contentView);
                make.width.mas_equalTo(kButton1_Width);
            }];
            kWeakfy(self);
            [kButton1 bk_addEventHandler:^(id sender) {
                kStrongfy(kWeakSelf);
                kStrongSelf.isSelectedRow = indexPath.row;
                [kStrongSelf.tableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                    kStrongfy(kWeakSelf);
                    [kStrongSelf.kTextField1 becomeFirstResponder];
                });
            } forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[KRequestURLObject shareInstance].activeRequestURLStr isEqualToString:_kRequestURLArr[indexPath.row][@"RequestURL"]]) {
        [KRequestURLObject shareInstance].activeRequestURLStr = _kRequestURLArr[indexPath.row][@"RequestURL"];
        [self reloadTableView];
        [self reloadRequestURLWithActiveRequestURLStr:_kRequestURLArr[indexPath.row][@"RequestURL"]];
    }
}
#pragma mark - Lazyloading
- (KTextField *)kTextField1 {
    if (!_kTextField1) {
        _kTextField1 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField1.font = SystemFontAll(54);
        _kTextField1.textColor = KRGB(33, 33, 33, 1);
        _kTextField1.tintColor = KRGB(33, 33, 33, 1);
        _kTextField1.textAlignment = NSTextAlignmentLeft;
        _kTextField1.keyboardType = UIKeyboardTypeDefault;
        _kTextField1.layer.masksToBounds = YES;
        _kTextField1.layer.borderColor = KRGB(33, 33, 33, 1).CGColor;
        _kTextField1.layer.borderWidth = 1.f;
        _kTextField1.enabled = YES;
        _kTextField1.placeholder = @"请输入服务器地址";
        [_kTextField1 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField1.isHiddenClearButtonMode = YES;
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
