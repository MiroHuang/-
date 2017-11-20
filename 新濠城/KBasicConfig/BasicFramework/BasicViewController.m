//
//  BasicViewController.m
//  CowX.Wallet
//
//  Created by 黄凯 on 16/4/7.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import "BasicViewController.h"
#import "AppDelegate.h"

@interface BasicViewController ()
@property (nonatomic, strong) UIImageView *navBarHairLineImageView;
@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KRGB(236, 236, 236, 1);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (!self.navigationController.navigationBar.translucent) {
        _navBarHairLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
        _navBarHairLineImageView.hidden = YES;
    }else{
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    
    [self _initLeftNaviBarItem];
    
    #ifdef DEBUG_MODE
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appdelegate.viewcontrollers) {
        appdelegate.viewcontrollers = [NSMutableArray array];
    }
    [appdelegate.viewcontrollers addObject:NSStringFromClass([self class])];
    NSLog(@"viewcontrollers(viewDidLoad) = %@", appdelegate.viewcontrollers);
    #endif
}
- (void)_initLeftNaviBarItem {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.tabBarController.navigationItem.hidesBackButton = YES;
    if (self.navigationController.viewControllers.count == 1 && [self.navigationController.viewControllers.firstObject isKindOfClass:[LoginViewController class]]) {
        [self.navigationController.navigationBar setBarTintColor:KRGB(236, 236, 236, 1)];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (![self.navigationController.viewControllers.firstObject isKindOfClass:[LoginViewController class]]) {
        self.tabBarController.navigationItem.hidesBackButton = NO;
        self.tabBarController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }
}
#pragma mark - Method
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)dealloc {
    NSLog(@"dealloc = %@", self);
    #ifdef DEBUG_MODE
    __block NSString *viewcontrollerStr = NSStringFromClass([self class]);
    __block AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate.viewcontrollers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([viewcontrollerStr isEqualToString:obj]) {
            [appdelegate.viewcontrollers removeObject:obj];
            *stop = YES;
        }
    }];
    NSLog(@"viewcontrollers(dealloc) = %@", appdelegate.viewcontrollers);
    #endif
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
