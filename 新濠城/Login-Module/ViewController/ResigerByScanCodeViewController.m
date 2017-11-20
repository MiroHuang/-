//
//  ResigerByScanCodeViewController.m
//  新濠城
//
//  Created by XHC on 2017/9/23.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "ResigerByScanCodeViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "RegisterViewController.h"
#import "UIViewController+KVC.h"

#define kScanAreadLength KScreenL(860)

@interface ResigerByScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *qrSession;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) NSTimer *lineTimer;
@property (nonatomic, strong) UIImageView *imageView2;
@end

@implementation ResigerByScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _initNavigationBar];
    [self _initMainView];
    [self _setupCamera];
}
- (void)_initNavigationBar {
    UIButton *rightBarButton = [[UIButton alloc] init];
    rightBarButton.titleLabel.font = SystemFontAll(54);
    [rightBarButton setTitle:@"相册" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGSize rightBarButton_size = [rightBarButton sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    rightBarButton.frame = CGRectMake(0, 0, rightBarButton_size.width, rightBarButton_size.height);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    kWeakfy(self);
    [rightBarButton bk_addEventHandler:^(id sender) {
        kStrongfy(kWeakSelf);
        [kStrongSelf kShowSourceTypePhotoLibrary:^(UIImage *image) {
            NSData *imageData = UIImagePNGRepresentation(image);
            CIImage *ciImage = [CIImage imageWithData:imageData];
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
            NSArray *feature = [detector featuresInImage:ciImage];
            for (CIQRCodeFeature *result in feature) {
                [kStrongSelf sendRequestForVerifyQrcode:result.messageString];
                break;
            }
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:@"您选择的相片不是二维码！" duration:kToastDurationTime position:CSToastPositionBottom];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)_initMainView {
    [self.view addSubview:self.imageView1];
    CGFloat imageView1_top = KScreenL(366);
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(imageView1_top);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScanAreadLength, kScanAreadLength));
    }];

    UIView *upView = [[UIView alloc] init];
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(_imageView1.mas_top);
    }];
    UIView *leftView = [[UIView alloc] init];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.bottom.equalTo(_imageView1);
        make.right.equalTo(_imageView1.mas_left);
    }];
    UIView *rightView = [[UIView alloc] init];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.bottom.equalTo(_imageView1);
        make.left.equalTo(_imageView1.mas_right);
    }];
    UIView *downView = [[UIView alloc] init];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView1.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    [self.view addSubview:self.imageView2];
    CGFloat imageView2_leftAndright = KScreenL(30);
    CGFloat imageView2_height = KMainScreenScale(2);
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView1).offset(imageView2_leftAndright);
        make.top.equalTo(_imageView1);
        make.right.equalTo(_imageView1).offset(-imageView2_leftAndright);
        make.height.mas_equalTo(imageView2_height);
    }];
}
- (void)_setupCamera {
    NSError *error = nil;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            [self.navigationController.view hideToasts];
            [self.navigationController.view makeToast:@"请在设备的'设置-隐私-相册'中允许访问摄像头。" duration:kToastDurationTime position:CSToastPositionBottom];
        }
        return;
    }

    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    [_imageView1.superview layoutIfNeeded];
    [output setRectOfInterest:CGRectMake(CGRectGetMinY(_imageView1.frame)/KScreenH, CGRectGetMinX(_imageView1.frame)/KScreenW, kScanAreadLength/KScreenH, kScanAreadLength/KScreenW)];
    AVCaptureConnection *connetion = [output connectionWithMediaType:AVMediaTypeAudio];
    [connetion setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeOff];

    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }else{
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }

    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }

    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];

    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    _qrVideoPreviewLayer = preview;
    _qrSession = session;
}
#pragma mark - Request
- (void)sendRequestForVerifyQrcode:(NSString *)qrcodeStr {
    NSArray *parameterArr = [qrcodeStr componentsSeparatedByString:@"qrcode="];
    if (parameterArr.count == 2 && [parameterArr[1] length] > 0) {
        __block NSString * qrcodeValue = parameterArr[1];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:qrcodeValue forKey:@"qrcode"];
        kWeakfy(self);
        [KMBProgressHUDManager showHUDAtViewController];
        [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/user/qrcodevalidate"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
            [KMBProgressHUDManager hide];
            dispatch_async(dispatch_get_main_queue(), ^{
                kStrongfy(kWeakSelf);
                RegisterViewController *viewController = [[RegisterViewController alloc] init];
                viewController.title = @"注册";
                viewController.qrcodeStr = qrcodeValue;
                viewController.nicknameStr = ((NSDictionary *)kBasicModel.data)[@"nickname"];
                viewController.avatarStr = ((NSDictionary *)kBasicModel.data)[@"avatar"];
                [kStrongSelf.navigationController pushViewController:viewController animated:YES];
            });
        } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
            [KGlobalUtils getMainThread:^{
                [KMBProgressHUDManager hide];
                kStrongfy(kWeakSelf);
                if (kStrongSelf.qrSession && ![kStrongSelf.qrSession isRunning]) {
                    [kStrongSelf startSYQRCodeReading];
                }
                [kStrongSelf.view hideToasts];
                [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
            }];
        }];
    }else{
        [self.view hideToasts];
        [self.view makeToast:@"请扫描正确的邀请二维码！" duration:kToastDurationTime position:CSToastPositionBottom];
    }
}
#pragma mark 输出代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self stopSYQRCodeReading];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0) {
            [self sendRequestForVerifyQrcode:obj.stringValue];
        }
    }
}
#pragma mark 交互事件
- (void)startSYQRCodeReading {
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(animation_line) userInfo:nil repeats:YES];
    [_qrSession startRunning];
    //NSLog(@"start reading");
}
- (void)stopSYQRCodeReading {
    if (_lineTimer) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    [_qrSession stopRunning];
    _qrVideoPreviewLayer = nil;
    //NSLog(@"stop reading");
}
#pragma mark 上下滚动交互线
- (void)animation_line {
    CGRect frame = _imageView2.frame;
    frame.origin.y += 2;
    if (frame.origin.y > _imageView1.frame.size.width + _imageView1.frame.origin.y) {
        frame.origin.y = _imageView1.frame.origin.y;
    }
    _imageView2.frame = frame;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_qrSession && ![_qrSession isRunning]) {
        [self startSYQRCodeReading];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self stopSYQRCodeReading];
}
#pragma mark - Lazyloading
- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.image = [UIImage imageNamed:@"registerByScanCode"];
    }
    return _imageView1;
}
- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.backgroundColor = KRGB(64, 186, 39, 1);
    }
    return _imageView2;
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
