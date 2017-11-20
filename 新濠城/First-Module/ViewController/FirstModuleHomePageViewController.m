//
//  FirstModuleHomePageViewController.m
//  新濠城
//
//  Created by XHC on 2017/9/25.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "FirstModuleHomePageViewController.h"
#import "BaccaratViewController.h"
#import "BaccaratChatViewController.h"
#import "FirstModuleHomePageTableViewCell.h"
#import "UITableView+KTV.h"

static NSString *cellID = @"FirstModuleHomePageTableViewCell";

@interface FirstModuleHomePageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *itemArr;
@end

@implementation FirstModuleHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initializedData];
    [self _initTableView];
}
- (void)_initializedData {
    self.view.layer.contents = (id)[UIImage imageNamed:@"FirstModuleHomePageViewControllerBG"].CGImage;
    _itemArr = @[@"firstModuleHomePage_1", @"firstModuleHomePage_2", @"firstModuleHomePage_3"];
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KScreenL(60);
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakfy(self);
    CGFloat height = [tableView kCalculation_HeightForCellByIdentifier:cellID configuration:^(FirstModuleHomePageTableViewCell *cell) {
        kStrongfy(kWeakSelf);
        [kStrongSelf configureFirstModuleHomePageTableViewCell:cell atIndexPAth:indexPath];
    }];
    return height;
}
- (void)configureFirstModuleHomePageTableViewCell:(FirstModuleHomePageTableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    cell.dataModel = _itemArr[indexPath.section];
    cell.selectIndex = indexPath.section;
    kWeakfy(self);
    [cell setKCompletedBlock:^(NSInteger selectIndex) {
        kStrongfy(kWeakSelf);
        if (selectIndex == 0) {
            BaccaratViewController *viewController = [[BaccaratViewController alloc] init];
            viewController.title = @"百家乐";
            [kStrongSelf.navigationController pushViewController:viewController animated:YES];
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstModuleHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [self configureFirstModuleHomePageTableViewCell:cell atIndexPAth:indexPath];
    return cell;
}
#pragma mark - Lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[FirstModuleHomePageTableViewCell class] forCellReuseIdentifier:cellID];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
