//
//  KPublicBetCollectionView.m
//  CowX.Wallet
//
//  Created by 黄凯 on 16/5/7.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import "KPublicBetCollectionView.h"

static NSInteger defaultTag = 10000;

@interface KPublicBetCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray *itemsArr1;
@property (nonatomic, copy) NSArray *itemsArr2;
@end

@implementation KPublicBetCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = KRGB(206, 206, 206, 1);
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self reloadCellData];
    }
    return self;
}
- (void)reloadCellData {
    _itemsArr1 = @[@{@"title":@"闲", @"R":@"58", @"G":@"137", @"B":@"246"},
                   @{@"title":@"和", @"R":@"0", @"G":@"188", @"B":@"71"},
                   @{@"title":@"庄", @"R":@"221", @"G":@"36", @"B":@"45"},
                   @{@"title":@"闲对", @"R":@"58", @"G":@"137", @"B":@"246"},
                   @{@"title":@"庄对", @"R":@"221", @"G":@"36", @"B":@"45"},
                   @{@"title":@"双对", @"R":@"243", @"G":@"132", @"B":@"8"},
                   @{@"title":@"三宝", @"R":@"0", @"G":@"188", @"B":@"71"},
                   @{@"title":@"撤销", @"R":@"33", @"G":@"33", @"B":@"33"}];
    _itemsArr2 = @[@"1", @"2", @"3", @"✖️", @"4", @"5", @"6", @"", @"7", @"8", @"9", @"下注", @"", @"0", @"", @""];
    [self reloadData];
}
#pragma mark - Method
- (void)setLastIndexPath:(NSIndexPath *)lastIndexPath {
    /** 清空选中状态
     *  _lastIndexPath != nil
     *  lastIndexPath == nil
     */
    if (!lastIndexPath && _lastIndexPath) {
        UICollectionViewCell *oldCell = [self cellForItemAtIndexPath:_lastIndexPath];
        UILabel *oldLabel = [oldCell.contentView viewWithTag:(defaultTag + _lastIndexPath.row)];
        oldLabel.backgroundColor = KRGB(206, 206, 206, 1);
    }
    /** 初始设置选中状态
     *  _lastIndexPath == nil
     *  lastIndexPath != nil
     */
    if (!_lastIndexPath && lastIndexPath) {
        UICollectionViewCell *newCell = [self cellForItemAtIndexPath:lastIndexPath];
        UILabel *newLabel = [newCell.contentView viewWithTag:(defaultTag + lastIndexPath.row)];
        newLabel.backgroundColor = KRGB(0, 102, 255, 1);
    }
    /** 设置选中状态
     *  _lastIndexPath != nil
     *  lastIndexPath != nil
     *  lastIndexPath != _lastIndexPath
     */
    if (lastIndexPath && _lastIndexPath && lastIndexPath != _lastIndexPath) {
        UICollectionViewCell *newCell = [self cellForItemAtIndexPath:lastIndexPath];
        newCell.backgroundColor = KRGB(236, 236, 236, 1);
        UILabel *newLabel = [newCell.contentView viewWithTag:(defaultTag + lastIndexPath.row)];
        newLabel.backgroundColor = KRGB(0, 102, 255, 1);
        
        UICollectionViewCell *oldCell = [self cellForItemAtIndexPath:_lastIndexPath];
        oldCell.backgroundColor = KRGB(236, 236, 236, 1);
        UILabel *oldLabel = [oldCell.contentView viewWithTag:(defaultTag + _lastIndexPath.row)];
        oldLabel.backgroundColor = KRGB(206, 206, 206, 1);
    }
    _lastIndexPath = lastIndexPath;
}
- (void)reloadBackGroundColorByIndexPath:(NSIndexPath *)indexPath {
    self.lastIndexPath = indexPath;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _itemsArr1.count;
    }else if (section == 1) {
        return 16;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat cellW_1 = floor(CGRectGetWidth(self.frame)/5);
        CGFloat cellW_2 = floor((CGRectGetWidth(self.frame) - cellW_1)/2);
        CGFloat cellH = KPublicBetCollectionViewTop_Height/2;
        if (indexPath.row == 0 || indexPath.row == 2) {
            return CGSizeMake(cellW_2, cellH);
        }else{
            return CGSizeMake(cellW_1, cellH);
        }
    }else if (indexPath.section == 1) {
        CGFloat cellW = floor(CGRectGetWidth(self.frame)/4);
        CGFloat cellH = KPublicBetCollectionViewBottom_Height/4;
        return CGSizeMake(cellW, cellH);
    }
    return CGSizeMake(0, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView 
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = KRGB(236, 236, 236, 1);
        
        UILabel *titlelbl = [[UILabel alloc] init];
        titlelbl.tag = defaultTag + indexPath.row;
        titlelbl.backgroundColor = KRGB(206, 206, 206, 1);
        titlelbl.text = [_itemsArr1[indexPath.row] objectForKey:@"title"];
        titlelbl.textColor = KRGB([[_itemsArr1[indexPath.row] objectForKey:@"R"] floatValue], [[_itemsArr1[indexPath.row] objectForKey:@"G"] floatValue], [[_itemsArr1[indexPath.row] objectForKey:@"B"] floatValue], 1);
        titlelbl.textAlignment = NSTextAlignmentCenter;
        titlelbl.layer.masksToBounds = YES;
        titlelbl.layer.cornerRadius = 5.f;
        [cell.contentView addSubview:titlelbl];
        [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }else if (indexPath.section == 1) {
        cell.backgroundColor = KRGB(206, 206, 206, 1);
        UILabel *titlelbl = [[UILabel alloc] init];
        titlelbl.text = _itemsArr2[indexPath.row];
        titlelbl.font = SystemFontAll(54);
        titlelbl.backgroundColor = [UIColor whiteColor];
        titlelbl.textColor = KRGB(33, 33, 33, 1);
        titlelbl.textAlignment = NSTextAlignmentCenter;
        
        if (indexPath.row == 7) {
            [cell.contentView addSubview:titlelbl];
            [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 0, 5));
            }];
            [titlelbl.superview layoutIfNeeded];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titlelbl.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = titlelbl.bounds;
            maskLayer.path = maskPath.CGPath;
            titlelbl.layer.mask = maskLayer;
        }else if (indexPath.row == 11) {
            [cell.contentView addSubview:titlelbl];
            [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }else if (indexPath.row == 15) {
            [cell.contentView addSubview:titlelbl];
            [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 5, 5));
            }];
            [titlelbl.superview layoutIfNeeded];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titlelbl.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = titlelbl.bounds;
            maskLayer.path = maskPath.CGPath;
            titlelbl.layer.mask = maskLayer;
        }else if (indexPath.row == 12 || indexPath.row == 14) {
            //不显示
        }else{
            titlelbl.layer.masksToBounds = YES;
            titlelbl.layer.cornerRadius = 5.f;
            [cell.contentView addSubview:titlelbl];
            [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
            }];
        }
    }

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.KPublicBetCollectionViewDelegate && [self.KPublicBetCollectionViewDelegate respondsToSelector:@selector(didSelectItemAtIndexPath:andItemsArr:)]) {
        if (indexPath.section == 0) {
            if (indexPath.row != 7) {
                [self reloadBackGroundColorByIndexPath:indexPath];
            }
            [self.KPublicBetCollectionViewDelegate didSelectItemAtIndexPath:indexPath andItemsArr:_itemsArr1];
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 12 || indexPath.row == 14) {
                return;
            }
            [self.KPublicBetCollectionViewDelegate didSelectItemAtIndexPath:indexPath andItemsArr:_itemsArr2];
        }
    }
}

@end
