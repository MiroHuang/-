//
//  BasicNavigationController.h
//  CowX.Wallet
//
//  Created by 黄凯 on 15/11/10.
//  Copyright © 2015年 黄凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MLTransitionAnimationTypePush,
    MLTransitionAnimationTypePop,
    MLTransitionAnimationTypeNone,
} MLTransitionAnimationType;

/** BasicNavigationController */
@interface BasicNavigationController : UINavigationController<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>
- (void)removeGestureRecognizer;
- (void)addGestureRecognizer;
@end
