//
//  BaccaratTableViewCell.m
//  新濠城
//
//  Created by XHC on 2017/9/25.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "BaccaratTableViewCell.h"
#import "UIImage+KImage.h"

@interface BaccaratTableViewCell ()
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@end
@implementation BaccaratTableViewCell

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
    [self.contentView addSubview:self.imageView1];
    CGFloat imageView1_leftAndright = KScreenL(45);
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, imageView1_leftAndright, 0, imageView1_leftAndright));
    }];
    
    [_imageView1 addSubview:self.label2];
    CGFloat label2_left = KScreenL(70);
    CGFloat label2_height = KScreenL(48);
    CGFloat imageView1_right = KScreenL(400);
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView1).offset(label2_left);
        make.right.mas_equalTo(_imageView1).offset(-imageView1_right);
        make.centerY.equalTo(_imageView1.mas_centerY);
        make.height.mas_equalTo(label2_height);
    }];

    [_imageView1 addSubview:self.imageView2];
    
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imageView1.mas_centerY);
        make.right.equalTo(_label2.mas_right);
    }];

    [_imageView1 addSubview:self.label3];
    CGFloat label3_left = KScreenL(25);
    _label3.font = SystemFontAll(51);
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView2.mas_right).offset(label3_left);
        make.centerY.equalTo(_imageView2);
    }];
    
    [_imageView1 addSubview:self.imageView3];
    CGFloat imageView3_right = KScreenL(36);
    CGFloat imageView3_width = KScreenL(102);
    CGFloat imageView3_height = KScreenL(50);
    [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imageView1).offset(-imageView3_right);
        make.centerY.equalTo(_imageView1);
        make.size.mas_equalTo(CGSizeMake(imageView3_width, imageView3_height));
    }];
}
#pragma mark - Method
- (void)setDataModel:(KRoomModel *)dataModel {
    _label2.text = dataModel.roomname;
    _label3.text = [NSString stringWithFormat:@"%ld分", dataModel.minstake];
    
    [_imageView3 startAnimating];
}
#pragma mark - Lazyloading
- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [UILabel new];
        _label2.textColor = KRGB(247, 175, 63, 1);
        _label2.transform = CGAffineTransformMake(1, 0, tanf(-190 * (CGFloat)M_PI /180), 1, 0, 0);
    }
    return _label2;
}
- (UILabel *)label3 {
    if (!_label3) {
        _label3 = [UILabel new];
        _label3.textColor = KRGB(247, 175, 63, 1);
        _label3.transform = CGAffineTransformMake(1, 0, tanf(-180 * (CGFloat)M_PI /180), 1, 0, 0);
    }
    return _label3;
}
- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [UIImageView new];
        _imageView1.image = [UIImage imageNamed:@"baccarat1"];
    }
    return _imageView1;
}
- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [UIImageView new];
        _imageView2.image = [UIImage imageNamed:@"baccarat2"];
    }
    return _imageView2;
}
- (UIImageView *)imageView3 {
    if (!_imageView3) {
        _imageView3 = [UIImageView new];
        _imageView3.image = [UIImage imageNamed:@"baccarat3_1.png"];
        NSArray *animateNames = @[@"baccarat3_1.png",@"baccarat3_2.png",@"baccarat3_3.png"];
        NSMutableArray *animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
        for (NSString *animateName in animateNames) {
            UIImage * animateImage = [UIImage imageNamed:animateName];
            [animationImages addObject:animateImage];
        }
        _imageView3.animationImages = animationImages;
        _imageView3.animationDuration = 1.0;
    }
    return _imageView3;
}
@end
