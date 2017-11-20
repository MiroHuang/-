//
//  KRCGifMessageView.m
//  新濠城
//
//  Created by XHC on 2017/10/17.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KRCGifMessageView.h"

#define KBetRed_Width KScreenL(26*3/5)
#define KBetRed_Height KScreenL(36*3/5)

#define KBetWhite_Width KScreenL(84*3/5)
#define KBetWhite_Height KScreenL(122*3/5)

#define KBetPane_Width KScreenL(146*3/5)
#define KBetPane_Height KScreenL(176*3/5)

@interface KRCGifMessageView ()
@property (nonatomic, strong) UIImageView *homeBGImageView;
@property (nonatomic, strong) UIImageView *kImageView1;
@property (nonatomic, strong) UIImageView *kImageView5;
@property (nonatomic, strong) UIImageView *kImageView6;
@property (nonatomic, strong) UIImageView *kImageView6_1;
@property (nonatomic, strong) UIImageView *kImageView7;
@property (nonatomic, strong) UIImageView *kImageView7_1;
@property (nonatomic, strong) UIImageView *kImageView8;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeoutInterval;
@end

@implementation KRCGifMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    @synchronized(self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self _initBlocksKit];
        [self reloadCellContentView];
    }
    return self;
}
- (void)_initBlocksKit {
    _timer = nil;
     [_timer invalidate];
    kWeakfy(self);
    _timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.f block:^(NSTimer *timer) {
        kStrongfy(kWeakSelf);
        if (kStrongSelf.timeoutInterval <= 0) {
            [kStrongSelf.timer setFireDate:[NSDate distantFuture]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            kStrongSelf.kImageView6_1.image = [UIImage imageNamed:[NSString stringWithFormat:@"betWhite_%ld", kStrongSelf.timeoutInterval/10]];
            kStrongSelf.kImageView7_1.image = [UIImage imageNamed:[NSString stringWithFormat:@"betWhite_%ld", kStrongSelf.timeoutInterval%10]];
            kStrongSelf.timeoutInterval--;
        });

    } repeats:YES];
}
- (void)reloadCellContentView {
    [self addSubview:self.kImageView1];
    CGFloat kImageView1_Top = KScreenL(100*3/5);
    CGFloat kImageView1_Width = KScreenL(433*3/5);
    CGFloat kImageView1_Height = KScreenL(112*3/5);
    [_kImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(kImageView1_Top);
        make.size.mas_equalTo(CGSizeMake(kImageView1_Width, kImageView1_Height));
    }];
    
    [self addSubview:self.kImageView5];
    CGFloat kImageView5_Top = KScreenL(25*3/5);
    CGFloat kImageView5_Width = KScreenL(_kImageView5.image.size.width*3/5);
    CGFloat kImageView5_Height = KScreenL(_kImageView5.image.size.height*3/5);
    [_kImageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kImageView1.mas_bottom).offset(kImageView5_Top);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kImageView5_Width, kImageView5_Height));
    }];
    
    [_kImageView5 addSubview:self.kImageView6];
    CGFloat kImageView6_Left = KScreenL(30*3/5);
    [_kImageView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kImageView5).offset(kImageView6_Left);
        make.centerY.equalTo(_kImageView5);
        make.size.mas_equalTo(CGSizeMake(KBetPane_Width, KBetPane_Height));
    }];
    
    [_kImageView5 addSubview:self.kImageView7];
    CGFloat kImageView7_Left = KScreenL(15*3/5);
    [_kImageView7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kImageView6.mas_right).offset(kImageView7_Left);
        make.centerY.equalTo(_kImageView5);
        make.size.mas_equalTo(CGSizeMake(KBetPane_Width, KBetPane_Height));
    }];
    
    [_kImageView5 addSubview:self.kImageView8];
    CGFloat kImageView8_Right = KScreenL(5*3/5);
    CGFloat kImageView8_Bottom = KScreenL(36*3/5);
    CGFloat kImageView8_Width = KScreenL(_kImageView8.image.size.width*3/5);
    CGFloat kImageView8_Height = KScreenL(_kImageView8.image.size.height*3/5);
    [_kImageView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_kImageView5).offset(-kImageView8_Right);
        make.bottom.equalTo(_kImageView5).offset(-kImageView8_Bottom);
        make.size.mas_equalTo(CGSizeMake(kImageView8_Width, kImageView8_Height));
    }];
    
    [_kImageView6 addSubview:self.kImageView6_1];
    [_kImageView6_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_kImageView6);
        make.size.mas_equalTo(CGSizeMake(KBetWhite_Width, KBetWhite_Height));
    }];
    
    [_kImageView7 addSubview:self.kImageView7_1];
    [_kImageView7_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_kImageView7);
        make.size.mas_equalTo(CGSizeMake(KBetWhite_Width, KBetWhite_Height));
    }];
}
- (void)setDataModel:(RCMessageModel *)dataModel {
    KRCGifMessage *testMessage = (KRCGifMessage *)dataModel.content;
    
    if ([testMessage.name isEqualToString:@"stakestart"]) {
        _kImageView1.image = [UIImage imageNamed:@"bet_1"];
    }else if ([testMessage.name isEqualToString:@"stakecountdown"]) {
        _kImageView1.image = [UIImage imageNamed:@"bet_2"];
    }
    
    NSInteger timeNum = [[NSString stringWithFormat:@"%@", testMessage.data] integerValue];
    long long nowTime = (long long)(floor([[NSDate date] timeIntervalSince1970]*1000));
    _timeoutInterval = timeNum - (nowTime - dataModel.sentTime)/1000;
    if (_timeoutInterval <= 0) {
        _timeoutInterval = 0;
    }else if (_timeoutInterval >= timeNum) {
        _timeoutInterval = timeNum;
    }
    
    _kImageView6_1.image = [UIImage imageNamed:[NSString stringWithFormat:@"betWhite_%ld", _timeoutInterval/10]];
    _kImageView7_1.image = [UIImage imageNamed:[NSString stringWithFormat:@"betWhite_%ld", _timeoutInterval%10]];
    [_timer setFireDate:[NSDate distantPast]];
}
- (void)dealloc {
    _timer = nil;
    [_timer invalidate];
}
#pragma mark - Lazyloading
- (UIImageView *)kImageView1 {
    if (!_kImageView1) {
        _kImageView1 = [[UIImageView alloc] init];
        _kImageView1.userInteractionEnabled = YES;
    }
    return _kImageView1;
}
- (UIImageView *)kImageView5 {
    if (!_kImageView5) {
        _kImageView5 = [[UIImageView alloc] init];
        _kImageView5.image = [UIImage imageNamed:@"bet_3"];
        _kImageView5.userInteractionEnabled = YES;
    }
    return _kImageView5;
}
- (UIImageView *)kImageView6 {
    if (!_kImageView6) {
        _kImageView6 = [[UIImageView alloc] init];
        _kImageView6.image = [UIImage imageNamed:@"bet_4"];
        _kImageView6.userInteractionEnabled = YES;
    }
    return _kImageView6;
}
- (UIImageView *)kImageView7 {
    if (!_kImageView7) {
        _kImageView7 = [[UIImageView alloc] init];
        _kImageView7.image = [UIImage imageNamed:@"bet_4"];
        _kImageView7.userInteractionEnabled = YES;
    }
    return _kImageView7;
}
- (UIImageView *)kImageView8 {
    if (!_kImageView8) {
        _kImageView8 = [[UIImageView alloc] init];
        _kImageView8.image = [UIImage imageNamed:@"bet_5"];
        _kImageView8.userInteractionEnabled = YES;
    }
    return _kImageView8;
}
- (UIImageView *)kImageView6_1 {
    if (!_kImageView6_1) {
        _kImageView6_1 = [[UIImageView alloc] init];
        _kImageView6_1.userInteractionEnabled = YES;
    }
    return _kImageView6_1;
}
- (UIImageView *)kImageView7_1 {
    if (!_kImageView7_1) {
        _kImageView7_1 = [[UIImageView alloc] init];
        _kImageView7_1.userInteractionEnabled = YES;
    }
    return _kImageView7_1;
}
- (UIImageView *)homeBGImageView {
    if (!_homeBGImageView) {
        _homeBGImageView = [[UIImageView alloc] init];
        _homeBGImageView.userInteractionEnabled = YES;
    }
    return _homeBGImageView;
}
@end
