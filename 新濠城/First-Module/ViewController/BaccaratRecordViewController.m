//
//  BaccaratRecordViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/18.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "BaccaratRecordViewController.h"

static NSString *CellIdentifier = @"UICollectionViewCell";
static NSString *HeaderIdentifier = @"KCollectionViewHeader";
static NSString *FooterIdentifier = @"KCollectionViewFooter";

@interface BaccaratRecordViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *kBottomView;
@property (nonatomic, strong) KLabel *kNicknameLabel;
@property (nonatomic, strong) KLabel *kPlayerpairLabel;
@property (nonatomic, strong) KLabel *kDealerpairLabel;
@property (nonatomic, strong) KLabel *kDealerLabel;
@property (nonatomic, strong) KLabel *kPlayerLabel;
@property (nonatomic, strong) KLabel *kTieLabel;

@property (nonatomic, copy) UIFont *kLabelFont;
@property (nonatomic, assign) CGFloat kCell_Number;
@property (nonatomic, assign) CGFloat kCell_Width1;
@property (nonatomic, assign) CGFloat kCell_Width2;
@property (nonatomic, assign) CGFloat kCellWidthMargin;
@property (nonatomic, assign) CGFloat kCellDeafult_Height;
@property (nonatomic, assign) CGFloat kCellMargin_Length;
@end

@implementation BaccaratRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initializedData];
    [self _initKBottomView];
    [self _initCollectionView];
}
- (void)_initializedData {
    _kCellMargin_Length = 3;
    _kCellDeafult_Height = KScreenL(140);
    _kLabelFont = SystemFontAll(42);
    _kCell_Width1 = KScreenL(270);
    _kCellWidthMargin = 1;
    _kCell_Number = 6;
    _kCell_Width2 = floor((KScreenW - (_kCell_Number-1)*_kCellWidthMargin - _kCell_Width1)/(_kCell_Number-1));
    
    __block NSInteger kPlayerpairAll = 0;
    __block NSInteger kPlayerAll = 0;
    __block NSInteger kDealerpairAll = 0;
    __block NSInteger kDealerAll = 0;
    __block NSInteger kTieAll = 0;
    [_dataModelArr enumerateObjectsUsingBlock:^(KBaccaratRecordModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kPlayerpairAll += obj.playerpair;
        kPlayerAll += obj.player;
        kDealerpairAll += obj.dealerpair;
        kDealerAll += obj.dealer;
        kTieAll += obj.tie;
    }];
    self.kNicknameLabel.text = [NSString stringWithFormat:@"总计(%ld人)", (unsigned long)_dataModelArr.count];
    self.kPlayerLabel.text = [NSString stringWithFormat:@"%ld", (long)kPlayerAll];
    self.kPlayerpairLabel.text = [NSString stringWithFormat:@"%ld", (long)kPlayerpairAll];
    self.kDealerLabel.text = [NSString stringWithFormat:@"%ld", (long)kDealerAll];
    self.kDealerpairLabel.text = [NSString stringWithFormat:@"%ld", (long)kDealerpairAll];
    self.kTieLabel.text = [NSString stringWithFormat:@"%ld", (long)kTieAll];
}
- (void)_initKBottomView {
    [self.view addSubview:self.kBottomView];
    CGFloat kBottomView_Height = [self getThemaximumHeightForBottomView] + _kCellWidthMargin;
    [_kBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KExtraBottomHeight);
        make.height.mas_equalTo(kBottomView_Height);
    }];
    
    [_kBottomView addSubview:self.kNicknameLabel];
    _kNicknameLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kNicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_kBottomView);
        make.width.mas_equalTo(_kCell_Width1);
    }];
    
    [_kBottomView addSubview:self.kPlayerLabel];
    _kPlayerLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kPlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_kBottomView);
        make.left.equalTo(_kNicknameLabel.mas_right).offset(_kCellWidthMargin);
        make.width.mas_equalTo(_kCell_Width2);
    }];
    
    [_kBottomView addSubview:self.kDealerLabel];
    _kDealerLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kDealerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_kBottomView);
        make.left.equalTo(_kPlayerLabel.mas_right).offset(_kCellWidthMargin);
        make.width.mas_equalTo(_kCell_Width2);
    }];
    
    [_kBottomView addSubview:self.kPlayerpairLabel];
    _kPlayerpairLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kPlayerpairLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_kBottomView);
        make.left.equalTo(_kDealerLabel.mas_right).offset(_kCellWidthMargin);
        make.width.mas_equalTo(_kCell_Width2);
    }];
    
    [_kBottomView addSubview:self.kDealerpairLabel];
    _kDealerpairLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kDealerpairLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_kBottomView);
        make.left.equalTo(_kPlayerpairLabel.mas_right).offset(_kCellWidthMargin);
        make.width.mas_equalTo(_kCell_Width2);
    }];
    
    [_kBottomView addSubview:self.kTieLabel];
    _kTieLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kTieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_kBottomView);
        make.left.equalTo(_kDealerpairLabel.mas_right).offset(_kCellWidthMargin);
    }];
}
- (void)_initCollectionView {
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(_kBottomView.mas_top);
    }];
}
#pragma mark - Method
- (CGFloat)getThemaximumHeightForCellView:(KBaccaratRecordModel *)dataModel {
    CGFloat kCell_Height = 0;
    
    CGFloat height1 = [NSString checkSizeFromString:dataModel.nickname Font:_kLabelFont Width:_kCell_Width1-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height1) ? kCell_Height : height1;
    
    CGFloat height2 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.tie] Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height2) ? kCell_Height : height2;
    
    CGFloat height3 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.player] Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height3) ? kCell_Height : height3;
    
    CGFloat height4 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.playerpair] Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height4) ? kCell_Height : height4;
    
    CGFloat height5 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.dealer] Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height5) ? kCell_Height : height5;
    
    CGFloat height6 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.dealerpair] Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height6) ? kCell_Height : height6;
    
    return kCell_Height + 2*_kCellMargin_Length;
}
- (CGFloat)getThemaximumHeightForBottomView {
    CGFloat kBottomView_Height = 0;
    
    CGFloat height1 = [NSString checkSizeFromString:self.kNicknameLabel.text Font:_kLabelFont Width:_kCell_Width1-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height1) ? kBottomView_Height : height1;
    
    CGFloat height2 = [NSString checkSizeFromString:self.kPlayerLabel.text Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height2) ? kBottomView_Height : height2;
    
    CGFloat height3 = [NSString checkSizeFromString:self.kPlayerpairLabel.text Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height3) ? kBottomView_Height : height3;
    
    CGFloat height4 = [NSString checkSizeFromString:self.kDealerLabel.text Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height4) ? kBottomView_Height : height4;
    
    CGFloat height5 = [NSString checkSizeFromString:self.kDealerpairLabel.text Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height5) ? kBottomView_Height : height5;
    
    CGFloat height6 = [NSString checkSizeFromString:self.kTieLabel.text Font:_kLabelFont Width:_kCell_Width2-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height6) ? kBottomView_Height : height6;
    
    return kBottomView_Height + 2*_kCellMargin_Length;
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _kCell_Number;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataModelArr.count+1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cell_width = 0;
    if (indexPath.row != 0) {
        cell_width = _kCell_Width2;
    }else{
        cell_width = _kCell_Width1;
    }
    
    if (indexPath.section == 0) {
        return CGSizeMake(cell_width, _kCellDeafult_Height);
    }else{
        CGFloat cell_height = [self getThemaximumHeightForCellView:_dataModelArr[indexPath.section-1]] + _kCellWidthMargin+_kCellWidthMargin;//底部间距为1；
        return CGSizeMake(cell_width, cell_height);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        return headerView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = KRGB(242, 242, 242, 1);
    
    KLabel *label = [[KLabel alloc] init];
    label.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    label.backgroundColor = [UIColor clearColor];
    label.font = _kLabelFont;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section != 0 && indexPath.section%2 == 0) {
        label.backgroundColor = KRGB(220, 220, 220, 1);
    }else{
        label.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 1) {
        label.textColor = KRGB(0, 137, 222, 1);
    }else if (indexPath.row == 2) {
        label.textColor = KRGB(239, 1, 147, 1);
    }else if (indexPath.row == 5) {
        label.textColor = KRGB(63, 217, 101, 1);
    }else{
        label.textColor = KRGB(33, 33, 33, 1);
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            label.text = @"用户";
        }else if (indexPath.row == 1) {
            label.text = @"闲";
        }else if (indexPath.row == 2) {
            label.text = @"庄";
        }else if (indexPath.row == 3) {
            label.text = @"闲对";
        }else if (indexPath.row == 4) {
            label.text = @"庄对";
        }else if (indexPath.row == 5) {
            label.text = @"和";
        }
    }else{
        if (indexPath.row == 0) {
            label.text = _dataModelArr[indexPath.section-1].nickname;
        }else if (indexPath.row == 1) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].player];
        }else if (indexPath.row == 2) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].dealer];
        }else if (indexPath.row == 3) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].playerpair];
        }else if (indexPath.row == 4) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].dealerpair];
        }else if (indexPath.row == 5) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].tie];
        }
    }
    
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, _kCellWidthMargin, 0));
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return;
}
#pragma mark - Lazyloading
- (KLabel *)kNicknameLabel {
    if (!_kNicknameLabel) {
        _kNicknameLabel = [[KLabel alloc] init];
        _kNicknameLabel.font = _kLabelFont;
        _kNicknameLabel.numberOfLines = 2;
        _kNicknameLabel.textAlignment = NSTextAlignmentCenter;
        _kNicknameLabel.textColor = [UIColor whiteColor];
        _kNicknameLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kNicknameLabel;
}
- (KLabel *)kPlayerLabel {
    if (!_kPlayerLabel) {
        _kPlayerLabel = [[KLabel alloc] init];
        _kPlayerLabel.font = _kLabelFont;
        _kPlayerLabel.numberOfLines = 2;
        _kPlayerLabel.textAlignment = NSTextAlignmentCenter;
        _kPlayerLabel.textColor = [UIColor whiteColor];
        _kPlayerLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kPlayerLabel;
}
- (KLabel *)kPlayerpairLabel {
    if (!_kPlayerpairLabel) {
        _kPlayerpairLabel = [[KLabel alloc] init];
        _kPlayerpairLabel.font = _kLabelFont;
        _kPlayerpairLabel.numberOfLines = 2;
        _kPlayerpairLabel.textAlignment = NSTextAlignmentCenter;
        _kPlayerpairLabel.textColor = [UIColor whiteColor];
        _kPlayerpairLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kPlayerpairLabel;
}
- (KLabel *)kDealerLabel {
    if (!_kDealerLabel) {
        _kDealerLabel = [[KLabel alloc] init];
        _kDealerLabel.font = _kLabelFont;
        _kDealerLabel.numberOfLines = 2;
        _kDealerLabel.textAlignment = NSTextAlignmentCenter;
        _kDealerLabel.textColor = [UIColor whiteColor];
        _kDealerLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kDealerLabel;
}
- (KLabel*)kDealerpairLabel {
    if (!_kDealerpairLabel) {
        _kDealerpairLabel = [[KLabel alloc] init];
        _kDealerpairLabel.font = _kLabelFont;
        _kDealerpairLabel.numberOfLines = 2;
        _kDealerpairLabel.textAlignment = NSTextAlignmentCenter;
        _kDealerpairLabel.textColor = [UIColor whiteColor];
        _kDealerpairLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kDealerpairLabel;
}
- (KLabel *)kTieLabel {
    if (!_kTieLabel) {
        _kTieLabel = [[KLabel alloc] init];
        _kTieLabel.font = _kLabelFont;
        _kTieLabel.numberOfLines = 2;
        _kTieLabel.textAlignment = NSTextAlignmentCenter;
        _kTieLabel.textColor = [UIColor whiteColor];
        _kTieLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kTieLabel;
}
- (UIView *)kBottomView {
    if (!_kBottomView) {
        _kBottomView = [UIView new];
        _kBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _kBottomView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVBAR_H+STATUS_H, KScreenW, KScreenH-NAVBAR_H-STATUS_H-KExtraTopHeight-KExtraBottomHeight) collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FooterIdentifier];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        _collectionView = collectionView;
    }
    return _collectionView;
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
