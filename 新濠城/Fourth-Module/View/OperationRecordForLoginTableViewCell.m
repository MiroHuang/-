//
//  OperationRecordForLoginTableViewCell.m
//  新濠城
//
//  Created by XHC on 2017/10/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "OperationRecordForLoginTableViewCell.h"

@interface OperationRecordForLoginTableViewCell ()
@property (nonatomic, strong) UILabel *kLabel1;
@property (nonatomic, strong) UILabel *kLabel2;
@end
@implementation OperationRecordForLoginTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self reloadCellContentView];
    }
    return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
}
- (void)reloadCellContentView {
    [self.contentView addSubview:self.kLabel1];
    CGFloat kLabel1_Left = KScreenL(70);
    [_kLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kLabel1_Left);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.kLabel2];
    CGFloat kLabel2_Right = KScreenL(70);
    [_kLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kLabel2_Right);
        make.centerY.equalTo(self.contentView);
    }];
}
#pragma mark - Method
- (void)setDataModel:(KOperationRecordModel *)dataModel {
    _kLabel1.text = dataModel.handlename;
    _kLabel2.text = dataModel.createtime;
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
        _kLabel2.textColor = KRGB(100, 100, 100, 1);
        _kLabel2.font = SystemFontAll(54);
    }
    return _kLabel2;
}

@end
