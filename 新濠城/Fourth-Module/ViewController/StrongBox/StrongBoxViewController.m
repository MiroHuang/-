//
//  StrongBoxViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/2.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "StrongBoxViewController.h"
#import "StrongBoxTurnOutViewController.h"
#import "StrongBoxTurnBackViewController.h"

@interface StrongBoxViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation StrongBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initTableView];
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScreenL(160);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KScreenL(60);
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *kLeftLabel = [UILabel new];
    kLeftLabel.textColor = KRGB(33, 33, 33, 1);
    kLeftLabel.font = SystemFontAll(54);
    kLeftLabel.numberOfLines = 1;
    if (indexPath.row == 0) {
        kLeftLabel.text = @"保险箱转到身上分";
    }else if (indexPath.row == 1) {
        kLeftLabel.text = @"身上分转到保险箱";
    }
    [cell.contentView addSubview:kLeftLabel];
    CGFloat kLeftLabel_Left = KScreenL(45);
    [kLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(kLeftLabel_Left);
        make.centerY.equalTo(cell.contentView);
    }];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        StrongBoxTurnOutViewController *viewController = [StrongBoxTurnOutViewController new];
        viewController.title = @"保险箱转到身上分";
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 1) {
        StrongBoxTurnBackViewController *viewController = [StrongBoxTurnBackViewController new];
        viewController.title = @"身上分转到保险箱";
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - Lazyloading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = YES;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
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
