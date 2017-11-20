//
//  FirstModuleHomePageTableViewCell.m
//  新濠城
//
//  Created by XHC on 2017/9/27.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "FirstModuleHomePageTableViewCell.h"

@interface FirstModuleHomePageTableViewCell ()
@property (nonatomic, strong) UIButton *kButton;
@end
@implementation FirstModuleHomePageTableViewCell

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
    [self.contentView addSubview:self.kButton];
    UIImage *image = [UIImage imageNamed:@"firstModuleHomePage_1"];
    _kButton.layer.cornerRadius = 6.f;
    _kButton.userInteractionEnabled = YES;
    CGFloat kButton_leftAndright = KScreenL(70);
    CGFloat kButton_height = ceil((KScreenW - 2 * kButton_leftAndright) * (image.size.height / image.size.width));
    [_kButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kButton_leftAndright);
        make.right.equalTo(self.contentView).offset(-kButton_leftAndright);
        make.top.and.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kButton_height);
    }];
}
#pragma mark - Method
- (void)setDataModel:(NSString *)dataModel {
    [_kButton setImage:[UIImage imageNamed:dataModel] forState:UIControlStateNormal];
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _kButton.tag = selectIndex;
}
#pragma mark - Lazyloading
- (UIButton *)kButton {
    if (!_kButton) {
        _kButton = [UIButton new];
        kWeakfy(self);
        [_kButton bk_addEventHandler:^(UIButton *sender) {
            kStrongfy(kWeakSelf);
            if (kStrongSelf.kCompletedBlock) {
                kStrongSelf.kCompletedBlock(sender.tag);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _kButton;
}

@end
