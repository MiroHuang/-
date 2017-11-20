//
//  KShowBigImageViewController.m
//  新濠城
//
//  Created by XHC on 2017/11/7.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KShowBigImageViewController.h"

#define MaxSCale 2.0  //最大缩放比例
#define MinScale 0.5  //最小缩放比例

@interface KShowBigImageViewController ()
@property (nonatomic, strong) UIImageView *kImageView;
@property (nonatomic, assign) CGFloat totalScale;
@end

@implementation KShowBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initMainView];
    [self _initBlocksKit];
}
- (void)_initMainView {
    _kImageView = [[UIImageView alloc] init];
    _kImageView.backgroundColor = [UIColor clearColor];
    kWeakfy(self);
    _kImageView.image = [UIImage imageNamed:@"placeholder"];
    [self.view addSubview:_kImageView];
    [[KImageDownloader shareInstance] startDownloadImageWithImageUrl:self.imageStr completion:^(UIImage *image) {
        kStrongfy(kWeakSelf);
        kStrongSelf.kImageView.image = image;
        CGFloat image_height = image.size.height;
        CGFloat image_width = image.size.width;
        CGFloat kImageView_height;
        CGFloat kImageView_width;
        if (image_width > image_height) {
            kImageView_width = KScreenW;
            kImageView_height = image_height/image_width*kImageView_width;
        }else{
            kImageView_height = KScreenH;
            kImageView_width = image_width/image_height*kImageView_height;
        }
        [kStrongSelf.kImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(kStrongSelf.view);
            make.width.mas_equalTo(kImageView_width);
            make.height.mas_equalTo(kImageView_height);
        }];
    }];
}
- (void)_initBlocksKit {
    self.totalScale = 1.0;
    self.kImageView.userInteractionEnabled = YES;
    kWeakfy(self);
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        kStrongfy(kWeakSelf);
        UIPinchGestureRecognizer *recognizer = (UIPinchGestureRecognizer *)sender;
        
        CGFloat scale = recognizer.scale;
        
        //放大情况
        if(scale > 1.0){
            if(kStrongSelf.totalScale > MaxSCale) return;
        }
        
        //缩小情况
        if (scale < 1.0) {
            if (kStrongSelf.totalScale < MinScale) return;
        }
        
        kStrongSelf.kImageView.transform = CGAffineTransformScale(kStrongSelf.kImageView.transform, scale, scale);
        kStrongSelf.totalScale *=scale;
        recognizer.scale = 1.0;
    }];
    [self.view addGestureRecognizer:pinch];
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
