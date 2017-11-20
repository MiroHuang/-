//
//  ThirdModuleHomePageViewController.m
//  新濠城
//
//  Created by XHC on 2017/9/25.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "ThirdModuleHomePageViewController.h"

@interface ThirdModuleHomePageViewController ()
@property (nonatomic, strong) KPublicChatListViewController *kPublicChatListViewController;
@end

@implementation ThirdModuleHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initMainView];
}
- (void)_initMainView {
    [self addChildViewController:self.kPublicChatListViewController];
    [self.view addSubview:_kPublicChatListViewController.view];
    [_kPublicChatListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [((BasicNavigationController *)self.navigationController) removeGestureRecognizer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [((BasicNavigationController *)self.navigationController) addGestureRecognizer];
}
#pragma mark - Lazyloading
- (KPublicChatListViewController *)kPublicChatListViewController {
    if (!_kPublicChatListViewController) {
        _kPublicChatListViewController = [[KPublicChatListViewController alloc] init];
        _kPublicChatListViewController.isEnteredToCollectionViewController = YES;
    }
    return _kPublicChatListViewController;
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
