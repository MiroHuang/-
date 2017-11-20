//
//  BaccaratResultViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/18.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "BaccaratResultViewController.h"

static NSString *CellIdentifier = @"UICollectionViewCell";
static NSString *HeaderIdentifier = @"KCollectionViewHeader";
static NSString *FooterIdentifier = @"KCollectionViewFooter";

@interface BaccaratResultViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *kBottomView;
@property (nonatomic, strong) KLabel *kNicknameLabel;
@property (nonatomic, strong) KLabel *kIncomeLabel;
@property (nonatomic, strong) KLabel *kBalanceLabel;
@property (nonatomic, strong) KLabel *kTodaybalanceLabel;

@property (nonatomic, copy) UIFont *kLabelFont;
@property (nonatomic, assign) CGFloat kCell_Number;
@property (nonatomic, assign) CGFloat kCell_Width;
@property (nonatomic, assign) CGFloat kCellWidthMargin;
@property (nonatomic, assign) CGFloat kCellDeafult_Height;
@property (nonatomic, assign) CGFloat kCellMargin_Length;
@end

@implementation BaccaratResultViewController

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
    _kCellWidthMargin = 1;
    _kCell_Number = 3;
    _kCell_Width = floor((KScreenW - (_kCell_Number-1)*_kCellWidthMargin)/_kCell_Number);
    
    __block NSInteger kIncomeAll = 0;
    __block NSInteger kBalanceAll = 0;
    __block NSInteger kTodaybalanceAll = 0;
    [_dataModelArr enumerateObjectsUsingBlock:^(KBaccaratResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kIncomeAll += obj.income;
        kBalanceAll += obj.balance;
        kTodaybalanceAll += obj.todaybalance;
    }];
    self.kNicknameLabel.text = [NSString stringWithFormat:@"总计(%ld人)", _dataModelArr.count];
    self.kIncomeLabel.text = [NSString stringWithFormat:@"%ld", kIncomeAll];
    self.kBalanceLabel.text = [NSString stringWithFormat:@"%ld", kBalanceAll];
    self.kTodaybalanceLabel.text = [NSString stringWithFormat:@"%ld", kTodaybalanceAll];
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
        make.width.mas_equalTo(_kCell_Width);
    }];
    
    [_kBottomView addSubview:self.kIncomeLabel];
    _kIncomeLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_kBottomView);
        make.left.equalTo(_kNicknameLabel.mas_right).offset(_kCellWidthMargin);
        make.width.mas_equalTo(_kCell_Width);
    }];
    
    [_kBottomView addSubview:self.kBalanceLabel];
    _kBalanceLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_kBottomView);
        make.left.equalTo(_kIncomeLabel.mas_right).offset(_kCellWidthMargin);
        make.width.mas_equalTo(_kCell_Width);
    }];
    
    [_kBottomView addSubview:self.kTodaybalanceLabel];
    _kTodaybalanceLabel.textInsets = UIEdgeInsetsMake(_kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length, _kCellMargin_Length);
    [_kTodaybalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_kBottomView);
        make.left.equalTo(_kBalanceLabel.mas_right).offset(_kCellWidthMargin);
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
- (CGFloat)getThemaximumHeightForCellView:(KBaccaratResultModel *)dataModel {
    CGFloat kCell_Height = 0;
    
    CGFloat height1 = [NSString checkSizeFromString:dataModel.nickname Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height1) ? kCell_Height : height1;
    
    CGFloat height2 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.income] Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height2) ? kCell_Height : height2;

    CGFloat height3 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.balance] Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height3) ? kCell_Height : height3;

    CGFloat height4 = [NSString checkSizeFromString:[NSString stringWithFormat:@"%ld", dataModel.todaybalance] Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kCell_Height = (kCell_Height >= height4) ? kCell_Height : height4;
    
    return kCell_Height + 2*_kCellMargin_Length;
}
- (CGFloat)getThemaximumHeightForBottomView {
    CGFloat kBottomView_Height = 0;
    
    CGFloat height1 = [NSString checkSizeFromString:self.kNicknameLabel.text Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height1) ? kBottomView_Height : height1;
    
    CGFloat height2 = [NSString checkSizeFromString:self.kIncomeLabel.text Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height2) ? kBottomView_Height : height2;
    
    CGFloat height3 = [NSString checkSizeFromString:self.kBalanceLabel.text Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height3) ? kBottomView_Height : height3;
    
    CGFloat height4 = [NSString checkSizeFromString:self.kTodaybalanceLabel.text Font:_kLabelFont Width:_kCell_Width-2*_kCellMargin_Length Height:MAXFLOAT].height;
    kBottomView_Height = (kBottomView_Height >= height4) ? kBottomView_Height : height4;
 
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
    if (indexPath.section == 0) {
        return CGSizeMake(_kCell_Width, _kCellDeafult_Height);
    }else{
        CGFloat cell_height = [self getThemaximumHeightForCellView:_dataModelArr[indexPath.section-1]] + _kCellWidthMargin + _kCellWidthMargin;
        return CGSizeMake(_kCell_Width, cell_height);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        return headerView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        footerView.backgroundColor = RandomColor;
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
    }else if (indexPath.row == 3) {
        label.textColor = KRGB(63, 217, 101, 1);
    }else{
        label.textColor = KRGB(33, 33, 33, 1);
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            label.text = @"用户";
        }else if (indexPath.row == 1) {
            label.text = @"本局得分";
        }else if (indexPath.row == 2) {
            label.text = @"身上分";
        }else if (indexPath.row == 3) {
            label.text = @"初始分";
        }
    }else{
        if (indexPath.row == 0) {
            label.text = _dataModelArr[indexPath.section-1].nickname;
        }else if (indexPath.row == 1) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].income];
        }else if (indexPath.row == 2) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].balance];
        }else if (indexPath.row == 3) {
            label.text = [NSString stringWithFormat:@"%ld", _dataModelArr[indexPath.section-1].todaybalance];
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
- (KLabel *)kIncomeLabel {
    if (!_kIncomeLabel) {
        _kIncomeLabel = [[KLabel alloc] init];
        _kIncomeLabel.font = _kLabelFont;
        _kIncomeLabel.numberOfLines = 2;
        _kIncomeLabel.textAlignment = NSTextAlignmentCenter;
        _kIncomeLabel.textColor = [UIColor whiteColor];
        _kIncomeLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kIncomeLabel;
}
- (KLabel *)kBalanceLabel {
    if (!_kBalanceLabel) {
        _kBalanceLabel = [[KLabel alloc] init];
        _kBalanceLabel.font = _kLabelFont;
        _kBalanceLabel.numberOfLines = 2;
        _kBalanceLabel.textAlignment = NSTextAlignmentCenter;
        _kBalanceLabel.textColor = [UIColor whiteColor];
        _kBalanceLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kBalanceLabel;
}
- (KLabel *)kTodaybalanceLabel {
    if (!_kTodaybalanceLabel) {
        _kTodaybalanceLabel = [[KLabel alloc] init];
        _kTodaybalanceLabel.font = _kLabelFont;
        _kTodaybalanceLabel.numberOfLines = 2;
        _kTodaybalanceLabel.textAlignment = NSTextAlignmentCenter;
        _kTodaybalanceLabel.textColor = [UIColor whiteColor];
        _kTodaybalanceLabel.backgroundColor = KRGB(33, 33, 33, 1);
    }
    return _kTodaybalanceLabel;
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
