//
//  KPublicGMICollectionViewCell.m
//  Tuba2.0
//
//  Created by 黄凯 on 2016/12/28.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import "KPublicGMICollectionViewCell.h"

@interface KPublicGMICollectionViewCell ()
@property (nonatomic, strong) UIImageView *kImageView;
@property (nonatomic, strong) UILabel *kLabel;
@end

@implementation KPublicGMICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.kImageView];
        CGFloat kImageView_Height = KScreenL(150);
        [_kImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kImageView_Height);
            make.top.and.left.and.right.equalTo(self.contentView);
        }];

        [self.contentView addSubview:self.kLabel];
        [_kLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.centerX.equalTo(_kImageView);
            make.top.equalTo(_kImageView.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}
#pragma mark - Method
- (void)setDataModel:(KRoomUserModel *)dataModel {
    [_kImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _kLabel.text = dataModel.nickname;
}
#pragma mark - Lazyloading
- (UIImageView *)kImageView {
    if (!_kImageView) {
        _kImageView = [[UIImageView alloc] init];
        _kImageView.backgroundColor = RandomColor;
        _kImageView.layer.cornerRadius = 3.f;
    }
    return _kImageView;
}
- (UILabel *)kLabel {
    if (!_kLabel) {
        _kLabel = [UILabel new];
        _kLabel.textColor = KRGB(33, 33, 33, 1);
        _kLabel.font = SystemFontAll(45);
        _kLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _kLabel;
}
@end
