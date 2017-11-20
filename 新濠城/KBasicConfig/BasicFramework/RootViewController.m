//
//  RootViewController.m
//  博汇通
//
//  Created by 黄凯 on 15/11/10.
//  Copyright © 2015年 黄凯. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initializedData];
}
- (void)_initializedData {
    self.tabBar.hidden = NO;
    self.tabBar.opaque = YES;
    //[self.tabBar setTranslucent:NO];
    [self.tabBar setBackgroundImage:[[UIImage imageNamed:@"tabBarBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar setTintColor:APPColor];
}
#pragma mark - Method
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.navigationItem.title = item.title;
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    self.navigationItem.title = [[self.tabBar.items objectAtIndex:selectedIndex] title];
    [super setSelectedIndex:selectedIndex];
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
