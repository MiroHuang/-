//
//  FourthModuleHomePageViewController.m
//  新濠城
//
//  Created by XHC on 2017/9/25.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "FourthModuleHomePageViewController.h"
#import "UIViewController+KVC.h"
#import "KUserInfoDataModel.h"
#import "UIViewController+KVC.h"
#import "AccountDetailsViewController.h"
#import "ModifyPassWordViewController.h"
#import "StrongBoxViewController.h"
#import "TransferToOthersViewController.h"
#import "OperationRecordViewController.h"
#import "WithdrawalsViewController.h"
#import "WithdrawalStatusViewController.h"

@interface FourthModuleHomePageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *button1_1;
@property (nonatomic, strong) UIButton *button1_2;
@property (nonatomic, strong) UIImageView *imageView2_1;
@property (nonatomic, strong) UIImageView *imageView2_2;
@property (nonatomic, strong) UIImageView *imageView2_3;
@property (nonatomic, strong) UIImageView *imageView2_4;
@property (nonatomic, strong) UIImageView *imageView2_5;
@property (nonatomic, strong) UIImageView *imageView3_1;
@property (nonatomic, strong) UILabel *label1_1;
@property (nonatomic, strong) UILabel *label1_2;
@property (nonatomic, strong) UILabel *label1_3;
@property (nonatomic, strong) UILabel *label1_4;
@property (nonatomic, strong) UILabel *label2_1;
@property (nonatomic, strong) UILabel *label2_2;
@property (nonatomic, strong) UILabel *label2_3;
@property (nonatomic, strong) UILabel *label2_4;
@property (nonatomic, strong) UILabel *label2_5;
@property (nonatomic, strong) UILabel *label3_1;

@property (nonatomic, strong) KUserInfoModel *kUserInfoModel;
@end

@implementation FourthModuleHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initTableView];
    [self _initBlocksKit];
    [self _initReloadForKUserInfoDataModel];
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (void)_initBlocksKit {
    kWeakfy(self);
    [self.button1_1 bk_addEventHandler:^(id sender) {
        kStrongfy(kWeakSelf);
        [kStrongSelf modifyUserAvatar:^(UIImage *image) {
            kStrongfy(kWeakSelf);
            [kStrongSelf sendRequestForUploadImage:image];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.button1_2 bk_addEventHandler:^(id sender) {
        kStrongfy(kWeakSelf);
        [kStrongSelf sendRequestForGetUserWithdraw];
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)_initReloadForKUserInfoDataModel {
    kWeakfy(self);
    [[KUserInfoDataModel shareInstance] setKViewControllerSuccessBlock:^(NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel) {
        kStrongfy(kWeakSelf);
        kStrongSelf.kUserInfoModel = kUserInfoModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.tableView reloadData];
        });
    }];
    [[KUserInfoDataModel shareInstance] setKViewControllerFailureBlock:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
        });
    }];
}
- (void)dealloc {
    [KUserInfoDataModel shareInstance].kViewControllerSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kViewControllerFailureBlock = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [KUserInfoDataModel reload:ResponseDataStyleAfterRequest];
    //[KGlobalUtils exitApplication];
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
            WithdrawalStatusViewController *viewController = [WithdrawalStatusViewController new];
            viewController.title = @"提现";
            [kStrongSelf.navigationController pushViewController:viewController animated:YES];
        }];
    } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        [KGlobalUtils getMainThread:^{
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            if (response.statusCode == 200) {
                WithdrawalsViewController *viewController = [WithdrawalsViewController new];
                viewController.title = @"提现";
                [kStrongSelf.navigationController pushViewController:viewController animated:YES];
            }else{
                [kStrongSelf.view hideToasts];
                [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
            }
        }];
    }];
}
- (void)sendRequestForUploadImage:(UIImage *)image {
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [image compressedImageFiles:image imageKB:400 imageBlock:^(UIImage *returnImage) {
        [[KAliyunOSSManager shareInstance] startAliyunOSSWithUploadData:UIImageJPEGRepresentation(returnImage, 1) ofType:@"jpg" success:^(NSString *correctnessStr) {
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setValue:correctnessStr forKey:@"avatar"];
            [kStrongSelf sendRequestForEdituserinfo:parameters];
        } failure:^(NSString *errorStr) {
            [KGlobalUtils getMainThread:^{
                [KMBProgressHUDManager hide];
                kStrongfy(kWeakSelf);
                [kStrongSelf.view hideToasts];
                [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
            }];
        }];
    }];
}
- (void)sendRequestForEdituserinfo:(NSMutableDictionary *)parameters {
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/edituserinfo"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KGlobalUtils getMainThread:^{
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            [KUserInfoDataModel reload:ResponseDataStyleDirectRequest];
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:kBasicModel.message duration:kToastDurationTime position:CSToastPositionBottom];
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
#pragma mark - Method
- (void)modifyUserAvatar:(void (^)(UIImage *image))completion {
    kWeakfy(self);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAction_1 = [UIAlertAction actionWithTitle:@"从手机选择"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        kStrongfy(kWeakSelf);
        [kStrongSelf kShowSourceTypePhotoLibrary:completion];
    }];
    [alertController addAction:alertAction_1];
    UIAlertAction *alertAction_2 = [UIAlertAction actionWithTitle:@"拍照"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        kStrongfy(kWeakSelf);
        [kStrongSelf kShowSourceTypeCamera:completion];
    }];
    [alertController addAction:alertAction_2];
    UIAlertAction *alertAction_3 = [UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction_3];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 5;
    }
    return 1;
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
    if (indexPath.section == 0) {
        return KScreenL(250);
    }
    if (indexPath.row == 3) {
//        if (_kUserInfoModel && _kUserInfoModel.isagent == 1) {
//            return KScreenL(160);
//        }else{
            return KScreenL(0);
//        }
    }
    return KScreenL(160);
}
- (void)configureFirstSectionFromCell:(UITableViewCell *)cell {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell.contentView addSubview:self.button1_1];
    [_button1_1 sd_setImageWithURL:[NSURL URLWithString:_kUserInfoModel.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    CGFloat button1_1_Left = KScreenL(40);
    CGFloat button1_1_WidthAndHeight = KScreenL(200);
    [_button1_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(button1_1_WidthAndHeight, button1_1_WidthAndHeight));
        make.left.equalTo(cell.contentView).offset(button1_1_Left);
    }];
    
    [cell.contentView addSubview:self.label1_1];
    _label1_1.text = _kUserInfoModel.nickname;
    CGFloat label1_1_Left = KScreenL(40);
    [_label1_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button1_1.mas_right).offset(label1_1_Left);
        make.top.equalTo(_button1_1);
    }];
    
    [cell.contentView addSubview:self.label1_2];
    _label1_2.text = [NSString stringWithFormat:@"ID:%@", _kUserInfoModel.userid];
    [_label1_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label1_1);
        make.centerY.equalTo(_button1_1);
    }];
    
    [cell.contentView addSubview:self.label1_3];
    _label1_3.text = [NSString stringWithFormat:@"身上分:%ld", _kUserInfoModel.balance];
    [_label1_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label1_1);
        make.bottom.equalTo(_button1_1);
    }];
    
    [cell.contentView addSubview:self.label1_4];
    _label1_4.text = [NSString stringWithFormat:@"保险箱:%ld", _kUserInfoModel.safebalance];
    CGFloat label1_4_Right = KScreenL(40);
    [_label1_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label1_3.mas_right).offset(label1_4_Right);
        make.bottom.equalTo(_label1_3);
    }];
    
//    if (_kUserInfoModel && _kUserInfoModel.isagent != 1) {
//        [cell.contentView addSubview:self.button1_2];
//        CGFloat button1_2_Width = KScreenL(160);
//        CGFloat button1_2_Height = KScreenL(100);
//        [_button1_2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_label1_1.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(button1_2_Width, button1_2_Height));
//            make.right.equalTo(_label1_4.mas_right);
//        }];
//    }
}
- (void)configureThirdSectionFromCell:(UITableViewCell *)cell {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell.contentView addSubview:self.imageView3_1];
    CGFloat imageView3_1_Left = KScreenL(80);
    [_imageView3_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(imageView3_1_Left);
        make.centerY.equalTo(cell.contentView);
    }];
    
    [cell.contentView addSubview:self.label3_1];
    CGFloat label3_1_Left = KScreenL(80);
    [_label3_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView3_1.mas_right).offset(label3_1_Left);
        make.centerY.equalTo(_imageView3_1);
    }];
}
- (void)configureOtherSectionFromCell:(UITableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *kImageView;
    UILabel *kLabel;
    
    if (indexPath.row == 0) {
        kImageView = self.imageView2_1;
        kLabel = self.label2_1;
    }else if (indexPath.row == 1) {
        kImageView = self.imageView2_2;
        kLabel = self.label2_2;
    }else if (indexPath.row == 2) {
        kImageView = self.imageView2_3;
        kLabel = self.label2_3;
    }else if (indexPath.row == 3) {
        kImageView = self.imageView2_4;
        kLabel = self.label2_4;
    }else if (indexPath.row == 4) {
        kImageView = self.imageView2_5;
        kLabel = self.label2_5;
    }
    
    [cell.contentView addSubview:kImageView];
    CGFloat imageView3_1_Left = KScreenL(80);
    [kImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(imageView3_1_Left);
        make.centerY.equalTo(cell.contentView);
    }];
    
    [cell.contentView addSubview:kLabel];
    CGFloat label3_1_Left = KScreenL(80);
    [kLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kImageView.mas_right).offset(label3_1_Left);
        make.centerY.equalTo(kImageView);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        [self configureFirstSectionFromCell:cell];
    }else if (indexPath.section == 2) {
        [self configureThirdSectionFromCell:cell];
    }else{
        [self configureOtherSectionFromCell:cell atIndexPAth:indexPath];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                AccountDetailsViewController *viewController = [AccountDetailsViewController new];
                viewController.title = @"账号详情";
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 1:
            {
                ModifyPassWordViewController *viewController = [ModifyPassWordViewController new];
                viewController.title = @"密码修改";
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 2:
            {
                StrongBoxViewController *viewController = [StrongBoxViewController new];
                viewController.title = @"保险箱存取";
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 3:
            {
                TransferToOthersViewController *viewController = [TransferToOthersViewController new];
                viewController.title = @"转分给他人";
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 4:
            {
                OperationRecordViewController *viewController = [OperationRecordViewController new];
                viewController.title = @"操作记录";
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            default:
                break;
        }
    }
    if (indexPath.section == 2) {
        [KGlobalUtils rollBackToLoginViewControllerWithPrompt:nil];
    }
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
- (UIButton *)button1_1 {
    if (!_button1_1) {
        _button1_1 = [UIButton new];
        [_button1_1 setBackgroundImage:[UIImage imageNamed:@"placeholder"] forState:UIControlStateNormal];
        _button1_1.layer.masksToBounds = YES;
        _button1_1.layer.cornerRadius = 5.f;
    }
    return _button1_1;
}
- (UIButton *)button1_2 {
    if (!_button1_2) {
        _button1_2 = [UIButton new];
        [_button1_2 setBackgroundColor:KRGB(243.0, 107.0, 42.0, 1)];
        [_button1_2 setTitle:@"提现" forState:UIControlStateNormal];
        [_button1_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button1_2.layer.cornerRadius = 5.f;
    }
    return _button1_2;
}
- (UIImageView *)imageView2_1 {
    if (!_imageView2_1) {
        _imageView2_1 = [UIImageView new];
        _imageView2_1.image = [UIImage imageNamed:@"fourthModuleHomePage2_1"];
    }
    return _imageView2_1;
}
- (UIImageView *)imageView2_2 {
    if (!_imageView2_2) {
        _imageView2_2 = [UIImageView new];
        _imageView2_2.image = [UIImage imageNamed:@"fourthModuleHomePage2_2"];
    }
    return _imageView2_2;
}
- (UIImageView *)imageView2_3 {
    if (!_imageView2_3) {
        _imageView2_3 = [UIImageView new];
        _imageView2_3.image = [UIImage imageNamed:@"fourthModuleHomePage2_3"];
    }
    return _imageView2_3;
}
- (UIImageView *)imageView2_4 {
    if (!_imageView2_4) {
        _imageView2_4 = [UIImageView new];
        _imageView2_4.image = [UIImage imageNamed:@"fourthModuleHomePage2_4"];
    }
    return _imageView2_4;
}
- (UIImageView *)imageView2_5 {
    if (!_imageView2_5) {
        _imageView2_5 = [UIImageView new];
        _imageView2_5.image = [UIImage imageNamed:@"fourthModuleHomePage2_6"];
    }
    return _imageView2_5;
}
- (UIImageView *)imageView3_1 {
    if (!_imageView3_1) {
        _imageView3_1 = [UIImageView new];
        _imageView3_1.image = [UIImage imageNamed:@"fourthModuleHomePage3_1"];
    }
    return _imageView3_1;
}
- (UILabel *)label1_1 {
    if (!_label1_1) {
        _label1_1 = [UILabel new];
        _label1_1.textColor = KRGB(33, 33, 33, 1);
        _label1_1.font = SystemFontAll(50);
        _label1_1.numberOfLines = 1;
    }
    return _label1_1;
}
- (UILabel *)label1_2 {
    if (!_label1_2) {
        _label1_2 = [UILabel new];
        _label1_2.textColor = KRGB(33, 33, 33, 1);
        _label1_2.font = SystemFontAll(50);
        _label1_2.numberOfLines = 1;
    }
    return _label1_2;
}
- (UILabel *)label1_3 {
    if (!_label1_3) {
        _label1_3 = [UILabel new];
        _label1_3.textColor = KRGB(33, 33, 33, 1);
        _label1_3.font = SystemFontAll(40);
        _label1_3.numberOfLines = 1;
    }
    return _label1_3;
}
- (UILabel *)label1_4 {
    if (!_label1_4) {
        _label1_4 = [UILabel new];
        _label1_4.textColor = KRGB(33, 33, 33, 1);
        _label1_4.font = SystemFontAll(40);
        _label1_4.numberOfLines = 1;
    }
    return _label1_4;
}
- (UILabel *)label2_1 {
    if (!_label2_1) {
        _label2_1 = [UILabel new];
        _label2_1.text = @"账号详情";
        _label2_1.textColor = KRGB(33, 33, 33, 1);
        _label2_1.font = SystemFontAll(54);
        _label2_1.numberOfLines = 1;
    }
    return _label2_1;
}
- (UILabel *)label2_2 {
    if (!_label2_2) {
        _label2_2 = [UILabel new];
        _label2_2.text = @"密码修改";
        _label2_2.textColor = KRGB(33, 33, 33, 1);
        _label2_2.font = SystemFontAll(54);
        _label2_2.numberOfLines = 1;
    }
    return _label2_2;
}
- (UILabel *)label2_3 {
    if (!_label2_3) {
        _label2_3 = [UILabel new];
        _label2_3.text = @"保险箱存取";
        _label2_3.textColor = KRGB(33, 33, 33, 1);
        _label2_3.font = SystemFontAll(54);
        _label2_3.numberOfLines = 1;
    }
    return _label2_3;
}
- (UILabel *)label2_4 {
    if (!_label2_4) {
        _label2_4 = [UILabel new];
        _label2_4.text = @"转分给他人";
        _label2_4.textColor = KRGB(33, 33, 33, 1);
        _label2_4.font = SystemFontAll(54);
        _label2_4.numberOfLines = 1;
    }
    return _label2_4;
}
- (UILabel *)label2_5 {
    if (!_label2_5) {
        _label2_5 = [UILabel new];
        _label2_5.text = @"操作记录";
        _label2_5.textColor = KRGB(33, 33, 33, 1);
        _label2_5.font = SystemFontAll(54);
        _label2_5.numberOfLines = 1;
    }
    return _label2_5;
}
- (UILabel *)label3_1 {
    if (!_label3_1) {
        _label3_1 = [UILabel new];
        _label3_1.text = @"注销退出";
        _label3_1.textColor = KRGB(33, 33, 33, 1);
        _label3_1.font = SystemFontAll(54);
        _label3_1.numberOfLines = 1;
    }
    return _label3_1;
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
