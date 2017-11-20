//
//  KPublicBetCollectionView.h
//  CowX.Wallet
//
//  Created by 黄凯 on 16/5/7.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KPublicBetCollectionView_Height 300.f
#define KPublicBetCollectionViewTop_Height 100.f
#define KPublicBetCollectionViewBottom_Height 200.f

@protocol KPublicBetCollectionViewDelegate <NSObject>
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath andItemsArr:(NSArray *)itemsArr;
@end

@interface KPublicBetCollectionView : UICollectionView
@property (nonatomic, assign)id<KPublicBetCollectionViewDelegate> KPublicBetCollectionViewDelegate;
@property (nonatomic, copy) NSIndexPath *lastIndexPath;
@end
