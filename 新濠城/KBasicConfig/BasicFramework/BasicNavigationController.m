//
//  BasicNavigationController.m
//  CowX.Wallet
//
//  Created by 黄凯 on 15/11/10.
//  Copyright © 2015年 黄凯. All rights reserved.
//

#import "BasicNavigationController.h"
#import <objc/runtime.h>

#pragma mark - NavigationTransitionAnimation
@interface NavigationTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) MLTransitionAnimationType type;
@property (nonatomic, strong) UINavigationBar *naviBar;
@end

@implementation NavigationTransitionAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return kPopAnimatedTime;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC.view.frame = fromVC.view.frame;
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    if (self.type == MLTransitionAnimationTypePop) {
        toVC.view.transform = CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform, -toVC.view.frame.size.width * KOffsetScale, 0);
        UIView *backView = [[UIView alloc] initWithFrame:toVC.view.bounds];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = toVC.view.bounds;
        [backView addSubview:effectview];
        [toVC.view addSubview:backView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation(fromVC.view.frame.size.width, 0);
            toVC.view.transform = CGAffineTransformIdentity;
            backView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [effectview removeFromSuperview];
            [backView removeFromSuperview];
            fromVC.view.layer.shadowOpacity = 0;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            fromVC.view.transform = CGAffineTransformIdentity;
            toVC.view.transform = CGAffineTransformIdentity;
        }];
    }else if (self.type == MLTransitionAnimationTypePush) {
        toVC.view.transform = CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform, toVC.view.frame.size.width * (1 - KOffsetScale), 0);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation(-fromVC.view.frame.size.width, 0);
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            toVC.view.layer.shadowOpacity = 0;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            fromVC.view.transform = CGAffineTransformIdentity;
            toVC.view.transform = CGAffineTransformIdentity;
        }];
    }
}
@end

#pragma mark - NavigationController
@interface BasicNavigationController ()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) NavigationTransitionAnimation *animation;
@property (nonatomic, assign) BOOL interActiving;
@end

@implementation BasicNavigationController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarHidden = NO;
    self.navigationBar.opaque = YES;
    [self.navigationBar setTranslucent:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:APPColor}];

    _animation = [[NavigationTransitionAnimation alloc] init];
    _animation.naviBar = self.navigationBar;
    _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
    _interactionController.completionCurve = UIViewAnimationCurveLinear;
    
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer];
    self.delegate = self;
}
#pragma mark - UIPanGestureRecognizer
- (void)removeGestureRecognizer {
    [self.view removeGestureRecognizer:_panRecognizer];
}
- (void)addGestureRecognizer {
    [self.view addGestureRecognizer:_panRecognizer];
}
- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    [self handleWithNaviBar:gesture];
}
- (void)handleWithNaviBar:(UIPanGestureRecognizer *)gesture {
    UIView *view = self.view;
    [gesture.view.superview bringSubviewToFront:gesture.view];
    CGPoint location = [gesture locationInView:view];
    CGPoint translation = [gesture translationInView:view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _interActiving = YES;
            if (location.x < CGRectGetMidX(view.bounds) && self.viewControllers.count > 1) {
                _animation.type = MLTransitionAnimationTypePop;
                [self popViewControllerAnimated:YES];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat fraction = fabs(translation.x / view.bounds.size.width);
            if (translation.x > 0 && _interActiving) {
                [_interactionController updateInteractiveTransition:fraction];
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            _interActiving = NO;
            CGFloat fraction = fabs(translation.x / view.bounds.size.width);
            if (fraction < 0.5 || gesture.state == UIGestureRecognizerStateCancelled) {
                [_interactionController cancelInteractiveTransition];
            }else{
                [_interactionController finishInteractiveTransition];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        {
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        }
        default:
            break;
    }
}
#pragma mark - UIViewControllerAnimatedTransitioning
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        if ([@"LoginViewController" isEqualToString:NSStringFromClass([fromVC class])]) {
            [self.navigationBar setBarTintColor:[UIColor blackColor]];
        }
        _animation.type = MLTransitionAnimationTypePush;
        return self.animation;
    }
    if (operation == UINavigationControllerOperationPop) {
        if ([@"LoginViewController" isEqualToString:NSStringFromClass([toVC class])]) {
            [self.navigationBar setBarTintColor:KRGB(236, 236, 236, 1)];
        }
        _animation.type = MLTransitionAnimationTypePop;
        return self.animation;
    }
    return nil;
}
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController*)navigationController                           interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    return _interActiving ? _interactionController : nil;
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
