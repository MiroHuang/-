//
//  AccountDetailsViewController.m
//  新濠城
//
//  Created by XHC on 2017/9/29.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "AccountDetailsViewController.h"
#import "UIImage+KImage.h"
#import "KValidateObject.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AccountDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label_left_1;
@property (nonatomic, strong) UILabel *label_left_2;
@property (nonatomic, strong) UILabel *label_left_3;
@property (nonatomic, strong) UILabel *label_left_4;
@property (nonatomic, strong) UILabel *label_left_5;
@property (nonatomic, strong) UILabel *label_left_6;

@property (nonatomic, strong) UILabel *label_right_1;
@property (nonatomic, strong) UILabel *label_right_2;
@property (nonatomic, strong) UILabel *label_right_3;
@property (nonatomic, strong) UIImageView *imageView_right_4;
@property (nonatomic, strong) KTextField *kTextField_right_5;
@property (nonatomic, strong) KTextField *kTextField_right_6;

@property (nonatomic, strong) KUserInfoModel *kUserInfoModel;

@property (nonatomic, strong) UIButton *kSaveQRCodeButton;
@property (nonatomic, strong) UIView *qRCodeBgView;
@property (nonatomic, strong) UIImageView *qRCodeImageView;
@end

@implementation AccountDetailsViewController

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
   
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (void)_initBlocksKit {
    kWeakfy(self);
    [self.kTextField_right_5 setBk_shouldReturnBlock:^BOOL(UITextField *textfield) {
        [textfield resignFirstResponder];
        kStrongfy(kWeakSelf);
        if (textfield.text.length < NickName_Min_Length) {
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:[NSString stringWithFormat:@"昵称长度必须大于%d！", NickName_Min_Length] duration:kToastDurationTime position:CSToastPositionBottom];
        }else{
            if ([kStrongSelf checkRequestForEditUserInfo]) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setValue:textfield.text forKey:@"nickname"];
                [kStrongSelf sendRequestForEditUserInfo:parameters];
            }
        }
        return YES;
    }];
    
    [self.kTextField_right_6 setKClickRightItemInToolBarCompletedBlock:^(KTextField *textfield) {
        [textfield resignFirstResponder];
        kStrongfy(kWeakSelf);
        if (textfield.text.length != PhoneNumber_Length) {
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:[NSString stringWithFormat:@"手机号长度必须为%d！", PhoneNumber_Length] duration:kToastDurationTime position:CSToastPositionBottom];
        }else{
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setValue:textfield.text forKey:@"phone"];
            [kStrongSelf sendRequestForEditUserInfo:parameters];
        }
    }];
    
    UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.kTextField_right_5 resignFirstResponder];
        [kStrongSelf.kTextField_right_6 resignFirstResponder];
    }];
    [self.tableView addGestureRecognizer:gestureRecognizer1];
    gestureRecognizer1.cancelsTouchesInView = NO;
    
    UITapGestureRecognizer *gestureRecognizer2 = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        kStrongfy(kWeakSelf);
        [kStrongSelf.qRCodeBgView removeFromSuperview];
        [kStrongSelf.qRCodeImageView removeFromSuperview];
        [kStrongSelf.kSaveQRCodeButton removeFromSuperview];
    }];
    [self.qRCodeBgView addGestureRecognizer:gestureRecognizer2];
    gestureRecognizer2.cancelsTouchesInView = NO;
    
    [self.kSaveQRCodeButton bk_addEventHandler:^(UIButton *sender) {
        kStrongfy(kWeakSelf);
        __block UIImage * image = [UIImage captureImageFromView:kStrongSelf.qRCodeImageView.superview];
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||status == PHAuthorizationStatusDenied) {
            [kStrongSelf.navigationController.view hideToasts];
            [kStrongSelf.navigationController.view makeToast:@"请在设备的'设置-隐私-相册'中允许访问相册。" duration:kToastDurationTime position:CSToastPositionBottom];
            return;
        }
        //__block NSMutableArray * imageIds = [NSMutableArray array];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            //[imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
            if (success) {
                [KGlobalUtils getMainThread:^{
                    [kStrongSelf.navigationController.view hideToasts];
                    [kStrongSelf.navigationController.view makeToast:@"成功保存到相册！" duration:kToastDurationTime position:CSToastPositionBottom];
                }];
                
                //成功后取相册中的图片对象
//                __block PHAsset *imageAsset = nil;
//                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
//                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    imageAsset = obj;
//                    *stop = YES;
//                }];
//                if (imageAsset) {
//                    //加载图片数据
//                    [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                        NSLog("imageData = %@", imageData);
//                    }];
//                }
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)_initReactiveCocoa {
    kWeakfy(self);
    [self.kTextField_right_5.rac_textSignal subscribeNext:^(NSString *content) {
        kStrongfy(kWeakSelf);
        if (kStrongSelf.kTextField_right_5.text.length >= NickName_Max_Length) {
            kStrongSelf.kTextField_right_5.text = [kStrongSelf.kTextField_right_5.text substringToIndex:NickName_Max_Length];
        }
    }];
    [self.kTextField_right_6.rac_textSignal subscribeNext:^(NSString *content) {
        kStrongfy(kWeakSelf);
        if (kStrongSelf.kTextField_right_6.text.length >= PhoneNumber_Length) {
            kStrongSelf.kTextField_right_6.text = [kStrongSelf.kTextField_right_6.text substringToIndex:PhoneNumber_Length];
        }
    }];
}
- (void)_initReloadForKUserInfoDataModel {
    kWeakfy(self);
    [[KUserInfoDataModel shareInstance] setKAccountDetailsViewControllerSuccessBlock:^(NSHTTPURLResponse *response, KUserInfoModel *kUserInfoModel) {
        kStrongfy(kWeakSelf);
        kStrongSelf.kUserInfoModel = kUserInfoModel;
        [KGlobalUtils getMainThread:^{
            kStrongSelf.label_right_1.text = kStrongSelf.kUserInfoModel.userid;
            kStrongSelf.label_right_2.text = kStrongSelf.kUserInfoModel.username;
            kStrongSelf.label_right_3.text = kStrongSelf.kUserInfoModel.logintime;
            if (kStrongSelf.label_right_3.text.length >= 19) {
                kStrongSelf.label_right_3.text = [kStrongSelf.label_right_3.text substringToIndex:19];
            }
            kStrongSelf.kTextField_right_5.text = kStrongSelf.kUserInfoModel.nickname;
            kStrongSelf.kTextField_right_6.text = kStrongSelf.kUserInfoModel.phone;
            kStrongSelf.qRCodeImageView.image = [UIImage createNonInterpolatedUIImageFormCIImage:kStrongSelf.kUserInfoModel.qrcode withSize:KScreenL(700)];
        }];
    }];
    [[KUserInfoDataModel shareInstance] setKAccountDetailsViewControllerFailureBlock:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
        }];
    }];
}
- (void)dealloc {
    [KUserInfoDataModel shareInstance].kAccountDetailsViewControllerSuccessBlock = nil;
    [KUserInfoDataModel shareInstance].kAccountDetailsViewControllerFailureBlock = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (!_kUserInfoModel) {
        [KUserInfoDataModel reload:ResponseDataStyleAfterRequest];
    }
}
#pragma mark - Method
- (BOOL)checkRequestForEditUserInfo {
    [_kTextField_right_5 resignFirstResponder];
    [_kTextField_right_6 resignFirstResponder];
    
    kWeakfy(self);
    if (![KValidateObject JudgeRegularExpression:OnlyContainLettersAndNumbers content:self.kTextField_right_5.text]) {
        [KGlobalUtils getMainThread:^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:KNickNameInputIllegalCharacter duration:kToastDurationTime position:CSToastPositionBottom];
        }];
        return NO;
    }
    return YES;
}
#pragma mark - Request
- (void)sendRequestForEditUserInfo:(NSMutableDictionary *)parameters {
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/edituserinfo"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KMBProgressHUDManager hide];
        kStrongfy(kWeakSelf);
        if (parameters[@"nickname"]) {
            kStrongSelf.kUserInfoModel.nickname = parameters[@"nickname"];
        }
        if (parameters[@"phone"]) {
            kStrongSelf.kUserInfoModel.phone = parameters[@"phone"];
        }
        
        [KUserInfoDataModel reload:ResponseDataStyleNoneRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:kBasicModel.message duration:kToastDurationTime position:CSToastPositionBottom];
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_kUserInfoModel && _kUserInfoModel.isagent != 0) {
            return 4;
        }
        return 3;
    }
    return 2;
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
    return KScreenL(160);
}
- (void)configureUITableViewCell:(UITableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    UIView *leftView;
    UIView *rightView;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                leftView = self.label_left_1;
                rightView = self.label_right_1;
                break;
            }
            case 1:
            {
                leftView = self.label_left_2;
                rightView = self.label_right_2;
                break;
            }
            case 2:
            {
                leftView = self.label_left_3;
                rightView = self.label_right_3;
                break;
            }
            case 3:
            {
                leftView = self.label_left_4;
                rightView = self.imageView_right_4;
                break;
            }
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                leftView = self.label_left_5;
                rightView = self.kTextField_right_5;
                break;
            }
            case 1:
            {
                leftView = self.label_left_6;
                rightView = self.kTextField_right_6;
                break;
            }
            default:
                break;
        }
    }
    
    [cell.contentView addSubview:leftView];
    CGFloat leftView_Left = KScreenL(70);
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(leftView_Left);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    
    [cell.contentView addSubview:rightView];
    CGFloat rightView_right = KScreenL(70);
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-rightView_right);
        make.centerY.equalTo(cell.contentView.mas_centerY);
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
    if (indexPath.section == 0 && indexPath.row == 3) {
        [self.kTextField_right_5 resignFirstResponder];
        [self.kTextField_right_6 resignFirstResponder];
        
        [self.navigationController.view addSubview:self.qRCodeBgView];
        _qRCodeBgView.backgroundColor = [UIColor whiteColor];
        [_qRCodeBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.navigationController.view);
        }];

        [self.navigationController.view addSubview:self.qRCodeImageView];
        [_qRCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(_imageView_right_4);
            make.width.height.mas_equalTo(KScreenL(70));
        }];
        
        [self.navigationController.view addSubview:self.kSaveQRCodeButton];
        [_kSaveQRCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imageView_right_4);
            make.top.equalTo(_qRCodeImageView.mas_bottom).offset(KScreenL(100));
            make.width.height.mas_equalTo(KScreenL(70));
        }];
        
        kWeakfy(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            kStrongfy(kWeakSelf);
            [kStrongSelf.qRCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(kStrongSelf.navigationController.view);
                make.width.height.mas_equalTo(KScreenL(700));
            }];
            [kStrongSelf.kSaveQRCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(kStrongSelf.navigationController.view);
                make.top.equalTo(kStrongSelf.qRCodeImageView.mas_bottom).offset(KScreenL(100));
                make.width.height.mas_equalTo(KScreenL(700));
            }];
            [UIView animateWithDuration:0.3 animations:^{
                kStrongfy(kWeakSelf);
                [kStrongSelf.qRCodeImageView.superview layoutIfNeeded];
            }];
        });
    }
}
#pragma mark - Lazyloading
- (UIButton *)kSaveQRCodeButton {
    if (!_kSaveQRCodeButton) {
        _kSaveQRCodeButton = [UIButton new];
        [_kSaveQRCodeButton setImage:[UIImage imageNamed:@"kSaveQRCodeButton"] forState:UIControlStateNormal];
    }
    return _kSaveQRCodeButton;
}
- (UIView *)qRCodeBgView {
    if (!_qRCodeBgView) {
        _qRCodeBgView = [UIView new];
    }
    return _qRCodeBgView;
}
- (UIImageView *)qRCodeImageView {
    if (!_qRCodeImageView) {
        _qRCodeImageView = [UIImageView new];
    }
    return _qRCodeImageView;
}
- (UILabel *)label_left_1 {
    if (!_label_left_1) {
        _label_left_1 = [UILabel new];
        _label_left_1.text = @"ID";
        _label_left_1.textColor = KRGB(33, 33, 33, 1);
        _label_left_1.font = SystemFontAll(54);
        _label_left_1.numberOfLines = 1;
    }
    return _label_left_1;
}
- (UILabel *)label_left_2 {
    if (!_label_left_2) {
        _label_left_2 = [UILabel new];
        _label_left_2.text = @"账号";
        _label_left_2.textColor = KRGB(33, 33, 33, 1);
        _label_left_2.font = SystemFontAll(54);
        _label_left_2.numberOfLines = 1;
    }
    return _label_left_2;
}
- (UILabel *)label_left_3 {
    if (!_label_left_3) {
        _label_left_3 = [UILabel new];
        _label_left_3.text = @"上次登录时间";
        _label_left_3.textColor = KRGB(33, 33, 33, 1);
        _label_left_3.font = SystemFontAll(54);
        _label_left_3.numberOfLines = 1;
    }
    return _label_left_3;
}
- (UILabel *)label_left_4 {
    if (!_label_left_4) {
        _label_left_4 = [UILabel new];
        _label_left_4.text = @"邀请二维码";
        _label_left_4.textColor = KRGB(33, 33, 33, 1);
        _label_left_4.font = SystemFontAll(54);
        _label_left_4.numberOfLines = 1;
    }
    return _label_left_4;
}
- (UILabel *)label_left_5 {
    if (!_label_left_5) {
        _label_left_5 = [UILabel new];
        _label_left_5.text = @"昵称";
        _label_left_5.textColor = KRGB(33, 33, 33, 1);
        _label_left_5.font = SystemFontAll(54);
        _label_left_5.numberOfLines = 1;
    }
    return _label_left_5;
}
- (UILabel *)label_left_6 {
    if (!_label_left_6) {
        _label_left_6 = [UILabel new];
        _label_left_6.text = @"手机号";
        _label_left_6.textColor = KRGB(33, 33, 33, 1);
        _label_left_6.font = SystemFontAll(54);
        _label_left_6.numberOfLines = 1;
    }
    return _label_left_6;
}
- (UILabel *)label_right_1 {
    if (!_label_right_1) {
        _label_right_1 = [UILabel new];
        _label_right_1.textColor = KPHColoc;
        _label_right_1.font = SystemFontAll(54);
        _label_right_1.textAlignment = NSTextAlignmentRight;
        _label_right_1.numberOfLines = 1;
    }
    return _label_right_1;
}
- (UILabel *)label_right_2 {
    if (!_label_right_2) {
        _label_right_2 = [UILabel new];
        _label_right_2.textColor = KPHColoc;
        _label_right_2.font = SystemFontAll(54);
        _label_right_2.textAlignment = NSTextAlignmentRight;
        _label_right_2.numberOfLines = 1;
    }
    return _label_right_2;
}
- (UILabel *)label_right_3 {
    if (!_label_right_3) {
        _label_right_3 = [UILabel new];
        _label_right_3.textColor = KPHColoc;
        _label_right_3.font = SystemFontAll(54);
        _label_right_3.textAlignment = NSTextAlignmentRight;
        _label_right_3.numberOfLines = 1;
    }
    return _label_right_3;
}
- (UIImageView *)imageView_right_4 {
    if (!_imageView_right_4) {
        _imageView_right_4 = [UIImageView new];
        _imageView_right_4.image = [UIImage imageNamed:@"qrcode"];
    }
    return _imageView_right_4;
}
- (KTextField *)kTextField_right_5 {
    if (!_kTextField_right_5) {
        _kTextField_right_5 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField_right_5.font = SystemFontAll(54);
        _kTextField_right_5.textColor = KRGB(33, 33, 33, 1);
        _kTextField_right_5.tintColor = KRGB(33, 33, 33, 1);
        _kTextField_right_5.textAlignment = NSTextAlignmentRight;
        _kTextField_right_5.keyboardType = UIKeyboardTypeDefault;
        _kTextField_right_5.placeholder = @"请输入昵称";
        [_kTextField_right_5 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField_right_5.isHiddenClearButtonMode = YES;
    }
    return _kTextField_right_5;
}
- (KTextField *)kTextField_right_6 {
    if (!_kTextField_right_6) {
        _kTextField_right_6 = [[KTextField alloc] initWithFrame:CGRectZero KTextFieldType:KTextFieldNone];
        _kTextField_right_6.font = SystemFontAll(54);
        _kTextField_right_6.textColor = KRGB(33, 33, 33, 1);
        _kTextField_right_6.tintColor = KRGB(33, 33, 33, 1);
        _kTextField_right_6.textAlignment = NSTextAlignmentRight;
        _kTextField_right_6.keyboardType = UIKeyboardTypeNumberPad;
        _kTextField_right_6.iSAddToolbar = YES;
        _kTextField_right_6.placeholder = @"请输入手机号";
        [_kTextField_right_6 setValue:KPHColoc forKeyPath:@"_placeholderLabel.textColor"];
        _kTextField_right_6.isHiddenClearButtonMode = YES;
    }
    return _kTextField_right_6;
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
