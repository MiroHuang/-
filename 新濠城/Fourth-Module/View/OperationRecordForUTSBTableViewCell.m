//
//  OperationRecordForUTSBTableViewCell.m
//  新濠城
//
//  Created by XHC on 2017/10/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "OperationRecordForUTSBTableViewCell.h"

@interface OperationRecordForUTSBTableViewCell ()
@property (nonatomic, strong) UILabel *kLabel1;
@property (nonatomic, strong) UILabel *kLabel2;
@property (nonatomic, strong) UILabel *kLabel3;
@end
@implementation OperationRecordForUTSBTableViewCell

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
    CGFloat kLabel2_Bottom = KScreenL(3);
    [_kLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kLabel2_Right);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-kLabel2_Bottom);
    }];
    
    [self.contentView addSubview:self.kLabel3];
    CGFloat kLabel3_Top = KScreenL(9);
    [_kLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_kLabel2);
        make.top.equalTo(self.contentView.mas_centerY).offset(kLabel3_Top);
    }];
}
#pragma mark - Method
- (void)setDataModel:(KOperationRecordModel *)dataModel {
    if ([dataModel.log integerValue] < 0) {
        _kLabel1.textColor = KRGB(33, 33, 33, 1);
        _kLabel1.text = [NSString stringWithFormat:@"%@", dataModel.log];
    }else{
        _kLabel1.textColor = KRGB(243, 107, 42, 1);
        _kLabel1.text = [NSString stringWithFormat:@"+%@", dataModel.log];
    }
    _kLabel2.text = dataModel.handlename;
    _kLabel3.text = dataModel.createtime;
}
#pragma mark - Lazyloading
- (UILabel *)kLabel1 {
    if (!_kLabel1) {
        _kLabel1 = [UILabel new];
        _kLabel1.font = SystemFontAll(58);
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
- (UILabel *)kLabel3 {
    if (!_kLabel3) {
        _kLabel3 = [UILabel new];
        _kLabel3.textColor = KRGB(199, 199, 199, 1);
        _kLabel3.font = SystemFontAll(45);
    }
    return _kLabel3;
}

@end
