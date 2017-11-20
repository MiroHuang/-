//
//  KPublicCustomServiceViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KPublicCustomServiceViewController.h"
#import "KPublicOtherMemberInfoViewController.h"
#import "UIImage+KImage.h"

@interface KPublicCustomServiceViewController ()

@end

@implementation KPublicCustomServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initNavigationBar];
}
- (void)_initNavigationBar {
    kWeakfy(self);
    UIImage *image = [UIImage imageNamed:@"tabBarIcon_4"];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[image imageWithColor:[UIColor whiteColor]] style:UIBarButtonItemStyleDone handler:^(id sender) {
        kStrongfy(kWeakSelf);
        KPublicOtherMemberInfoViewController *viewController = [KPublicOtherMemberInfoViewController new];
        viewController.title = @"个人资料";
        viewController.targetId = kStrongSelf.targetId;
        [kStrongSelf.navigationController pushViewController:viewController animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
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
