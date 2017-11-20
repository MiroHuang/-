//
//  BaccaratViewController.m
//  新濠城
//
//  Created by XHC on 2017/9/25.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "BaccaratViewController.h"
#import "BaccaratTableViewCell.h"
#import "BaccaratChatViewController.h"

static NSString *cellID = @"BaccaratTableViewCell";

@interface BaccaratViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topFuncView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, copy) NSArray<KRoomModel *> *kRoomModelArr;
@end

@implementation BaccaratViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initMainView];
    [self _initTableView];
}
- (void)_initMainView {
    [self.view addSubview:self.topFuncView];
    CGFloat topFuncView_height = KScreenL(120);
    [_topFuncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(topFuncView_height);
    }];
    [_topFuncView.superview layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_topFuncView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(topFuncView_height, topFuncView_height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _topFuncView.bounds;
    maskLayer.path = maskPath.CGPath;
    _topFuncView.layer.mask = maskLayer;
    
    [self.view addSubview:self.view1];
    CGFloat view1_left = KScreenL(150);
    CGFloat view1_right = KScreenL(60);
    CGFloat view1_height = topFuncView_height - 2 * KScreenL(20);
    _view1.layer.cornerRadius = view1_height/2;
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topFuncView).offset(view1_left);
        make.height.mas_equalTo(view1_height);
        make.centerY.equalTo(_topFuncView);
        make.right.equalTo(_topFuncView.mas_centerX).offset(-view1_right);
    }];
    
    [_view1 addSubview:self.label1];
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_view1).mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.view addSubview:self.view2];
    CGFloat view2_right = KScreenL(150);
    CGFloat view2_left = KScreenL(60);
    CGFloat view2_height = topFuncView_height - 2 * KScreenL(20);
    _view2.layer.cornerRadius = view2_height/2;
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topFuncView.mas_centerX).offset(view2_left);
        make.height.mas_equalTo(view2_height);
        make.centerY.equalTo(_topFuncView);
        make.right.equalTo(_topFuncView).offset(-view2_right);
    }];
    
    [_view2 addSubview:self.label2];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_view2).mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_topFuncView.mas_bottom);
    }];
    
    kWeakfy(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongfy(kWeakSelf);
        [kStrongSelf sendRequestForGetroomlist];
        [kStrongSelf.tableView.mj_header endRefreshing];
    }];
    _tableView.mj_header = header;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_kRoomModelArr.count == 0) {
        [self sendRequestForGetroomlist];
    }
}
#pragma mark - Request
- (void)sendRequestForGetroomlist {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/baccarat/getroomlist"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KMBProgressHUDManager hide];
        kStrongfy(kWeakSelf);
        kStrongSelf.kRoomModelArr = [NSArray yy_modelArrayWithClass:NSClassFromString(@"KRoomModel") json:[kBasicModel.data yy_modelToJSONObject]];
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.tableView reloadData];
        });
    } failure:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel, NSError *error, NSString *errorStr) {
        [KGlobalUtils getMainThread:^{
            [KMBProgressHUDManager hide];
            kStrongfy(kWeakSelf);
            [kStrongSelf.view hideToasts];
            [kStrongSelf.view makeToast:errorStr duration:kToastDurationTime position:CSToastPositionBottom];
        }];
    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (BaccaratTableViewCell *cell in _tableView.visibleCells) {
        [cell.imageView3 stopAnimating];
        [cell.imageView3 startAnimating];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _kRoomModelArr.count;
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
    return KScreenL(150);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaccaratTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [self configureBaccaratTableViewCell:cell atIndexPAth:indexPath];
    return cell;
}
- (void)configureBaccaratTableViewCell:(BaccaratTableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    cell.dataModel = _kRoomModelArr[indexPath.section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaccaratChatViewController *viewController = [BaccaratChatViewController new];
    viewController.conversationType = ConversationType_GROUP;
    viewController.displayUserNameInCell = YES;
    viewController.targetId = [NSString stringWithFormat:@"%ld", _kRoomModelArr[indexPath.section].roomid];
    viewController.minstake = _kRoomModelArr[indexPath.section].minstake;
    viewController.serviceid = _kRoomModelArr[indexPath.section].serviceid;
    viewController.roomname = _kRoomModelArr[indexPath.section].roomname;
    viewController.usercount = _kRoomModelArr[indexPath.section].usercount;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - Lazyloading
- (UIView *)view1 {
    if (!_view1) {
        _view1 = [UIView new];
        _view1.backgroundColor = [UIColor blackColor];
        _view1.alpha = 0.3;
    }
    return _view1;
}
- (UIView *)view2 {
    if (!_view2) {
        _view2 = [UIView new];
        _view2.backgroundColor = [UIColor blackColor];
        _view2.alpha = 0.3;
    }
    return _view2;
}
- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [UILabel new];
        _label1.text = @"房间名称";
        _label1.textColor = [UIColor whiteColor];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = SystemFontAll(54);
    }
    return _label1;
}
- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [UILabel new];
        _label2 = [UILabel new];
        _label2.text = @"最低投注";
        _label2.textColor = [UIColor whiteColor];
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.font = SystemFontAll(54);
    }
    return _label2;
}
- (UIView *)topFuncView {
    if (!_topFuncView) {
        _topFuncView = [UIView new];
        _topFuncView.backgroundColor = KRGB(243, 107, 42, 1);
    }
    return _topFuncView;
}
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
        [_tableView registerClass:[BaccaratTableViewCell class] forCellReuseIdentifier:cellID];
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
