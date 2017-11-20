//
//  OperationRecordViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/6.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "OperationRecordViewController.h"
#import "KScrollMaskView.h"
#import "OperationRecordForLoginTableViewCell.h"
#import "OperationRecordForSafeBalanceTableViewCell.h"
#import "OperationRecordForEditPasswordTableViewCell.h"
#import "OperationRecordForUTSBTableViewCell.h"

static NSString *cellID1 = @"OperationRecordForLoginTableViewCell";
static NSString *cellID2 = @"OperationRecordForSafeBalanceTableViewCell";
static NSString *cellID3 = @"OperationRecordForEditPasswordTableViewCell";
static NSString *cellID4 = @"OperationRecordForUTSBTableViewCell";

@interface OperationRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KScrollMaskView *kScrollMaskView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSArray *firstDataArr;
@property (nonatomic, copy) NSArray *secondDataArr;
@property (nonatomic, copy) NSArray *thirdDataArr;
@property (nonatomic, copy) NSArray *fourthDataArr;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *handleStr;
@end

@implementation OperationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initializedData];
    [self _initKScrollMaskView];
    [self _initTableView];
}
- (void)_initializedData {
    self.currentIndex = 0;
    self.firstDataArr = [NSArray array];
    self.secondDataArr = [NSArray array];
    self.thirdDataArr = [NSArray array];
    self.fourthDataArr = [NSArray array];
}
- (void)_initKScrollMaskView {
    [self.view addSubview:self.kScrollMaskView];
    CGFloat kScrollMaskView_height = KScreenL(140);
    _kScrollMaskView.frontTitleColor = [UIColor clearColor];
    _kScrollMaskView.behindTitleColor = KRGB(33, 33, 33, 1);
    _kScrollMaskView.lineViewColor = KRGB(243.0, 107.0, 42.0, 1);
    [_kScrollMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kScrollMaskView_height);
    }];
    KScrollMaskViewDataModel *dataModel1 = [[KScrollMaskViewDataModel alloc] init];
    dataModel1.name = @"登录记录";
    KScrollMaskViewDataModel *dataModel2 = [[KScrollMaskViewDataModel alloc] init];
    dataModel2.name = @"保险箱存取";
    KScrollMaskViewDataModel *dataModel3 = [[KScrollMaskViewDataModel alloc] init];
    dataModel3.name = @"密码修改";
    KScrollMaskViewDataModel *dataModel4 = [[KScrollMaskViewDataModel alloc] init];
    dataModel4.name = @"转分给他人";
    [_kScrollMaskView reloadKScrollMaskViewWithSenders:@[dataModel1, dataModel2, dataModel3, dataModel4] Width:KScreenW Height:kScrollMaskView_height TitleFont:SystemFontAll(54)];
    kWeakfy(self);
    [_kScrollMaskView setKScrollMaskViewCompletedBlock:^(NSInteger selectIndex) {
        kStrongfy(kWeakSelf);
        kStrongSelf.currentIndex = selectIndex;
        [kStrongSelf sendRequestForGetHandle:RefreshDataStyleHeaderRefresh];
    }];
    
    [self sendRequestForGetHandle:RefreshDataStyleHeaderRefresh];
}
- (void)_initTableView {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_kScrollMaskView.mas_bottom);
    }];
    
    kWeakfy(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongfy(kWeakSelf);
        kStrongSelf.currentPage = 0;
        [kStrongSelf sendRequestForGetHandle:RefreshDataStyleHeaderRefresh];
    }];
    _tableView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        kStrongfy(kWeakSelf);
        [kStrongSelf sendRequestForGetHandle:RefreshDataStyleFooterRefresh];
    }];
    _tableView.mj_footer = footer;
}
#pragma mark - Method
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (_currentIndex == 0) {
        _handleStr = @"login";
    }else if (_currentIndex == 1) {
        _handleStr = @"safebalance";
    }else if (_currentIndex == 2) {
        _handleStr = @"editpassword";
    }else if (_currentIndex == 3) {
        _handleStr = @"usertousersafebalance";
    }
}
#pragma mark - Request
- (void)sendRequestForGetHandle:(RefreshDataStyle)refreshDataStyle {
    kWeakfy(self);
    [KMBProgressHUDManager showHUDAtViewController];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInteger:_currentPage+1] forKey:@"Page"];
    [parameters setValue:_handleStr forKey:@"handle"];
    [KRequestManager sendHttpRequestWithHTTPURLString:[NSString stringWithFormat:@"%@%@", [KRequestURLObject shareInstance].activeRequestURLStr, @"/api/mycenter/gethandle"] parameters:parameters success:^(NSHTTPURLResponse *response, KBasicModel *kBasicModel) {
        [KMBProgressHUDManager hide];
        kStrongfy(kWeakSelf);
        NSArray *itemArr = [NSArray yy_modelArrayWithClass:NSClassFromString(@"KOperationRecordModel") json:[kBasicModel.data yy_modelToJSONObject]];
        if (itemArr.count > 0) {
            kStrongSelf.currentPage += 1;
        }
        
        NSArray * itemDataArr = nil;
        if (kStrongSelf.currentIndex == 0) {
            itemDataArr = kStrongSelf.firstDataArr;
        }else if (kStrongSelf.currentIndex == 1) {
            itemDataArr = kStrongSelf.secondDataArr;
        }else if (kStrongSelf.currentIndex == 2) {
            itemDataArr = kStrongSelf.thirdDataArr;
        }else{
            itemDataArr = kStrongSelf.fourthDataArr;
        }
        
        if (refreshDataStyle == RefreshDataStyleFooterRefresh) {
            NSMutableArray *addDataModels = [NSMutableArray arrayWithArray:itemDataArr];
            for (int i = 0; i < itemArr.count; i++) {
                KOperationRecordModel *kOperationRecordModel = [itemArr objectAtIndex:i];
                [addDataModels insertObject:kOperationRecordModel atIndex:addDataModels.count-1];
            }
            itemDataArr = [NSMutableArray arrayWithArray:addDataModels];
        }else{
            itemDataArr = itemArr;
        }

        if (kStrongSelf.currentIndex == 0) {
            kStrongSelf.firstDataArr = itemDataArr;
        }else if (kStrongSelf.currentIndex == 1) {
            kStrongSelf.secondDataArr = itemDataArr;
        }else if (kStrongSelf.currentIndex == 2) {
            kStrongSelf.thirdDataArr = itemDataArr;
        }else if (kStrongSelf.currentIndex == 3) {
            kStrongSelf.fourthDataArr = itemDataArr;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongfy(kWeakSelf);
            [kStrongSelf.tableView.mj_header endRefreshing];
            [kStrongSelf.tableView.mj_footer endRefreshing];
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
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *itemArr;
    if (_currentIndex == 0) {
        itemArr = _firstDataArr;
    }else if (_currentIndex == 1) {
        itemArr = _secondDataArr;
    }else if (_currentIndex == 2) {
        itemArr = _thirdDataArr;
    }else if (_currentIndex == 3) {
        itemArr = _fourthDataArr;
    }
    return itemArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScreenL(160);
}
- (void)configureFirstPageForTableViewCell:(OperationRecordForLoginTableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    cell.dataModel = _firstDataArr[indexPath.row];
}
- (void)configureSecondPageForTableViewCell:(OperationRecordForSafeBalanceTableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    cell.dataModel = _secondDataArr[indexPath.row];
}
- (void)configureThirdPageForTableViewCell:(OperationRecordForEditPasswordTableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    cell.dataModel = _thirdDataArr[indexPath.row];
}
- (void)configureFourthPageForTableViewCell:(OperationRecordForUTSBTableViewCell *)cell atIndexPAth:(NSIndexPath *)indexPath {
    cell.dataModel = _fourthDataArr[indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    if (_currentIndex == 0) {
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        [self configureFirstPageForTableViewCell:(OperationRecordForLoginTableViewCell *)tableViewCell atIndexPAth:indexPath];
    }else if (_currentIndex == 1) {
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        [self configureSecondPageForTableViewCell:(OperationRecordForSafeBalanceTableViewCell *)tableViewCell atIndexPAth:indexPath];
    }else if (_currentIndex == 2) {
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        [self configureThirdPageForTableViewCell:(OperationRecordForEditPasswordTableViewCell *)tableViewCell atIndexPAth:indexPath];
    }else if (_currentIndex == 3) {
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellID4];
        [self configureFourthPageForTableViewCell:(OperationRecordForUTSBTableViewCell *)tableViewCell atIndexPAth:indexPath];
    }
    NSAssert(tableViewCell != nil, @"Cell must be registered to table view");
    return tableViewCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
        [_tableView registerClass:[OperationRecordForLoginTableViewCell class] forCellReuseIdentifier:cellID1];
        [_tableView registerClass:[OperationRecordForSafeBalanceTableViewCell class] forCellReuseIdentifier:cellID2];
        [_tableView registerClass:[OperationRecordForEditPasswordTableViewCell class] forCellReuseIdentifier:cellID3];
        [_tableView registerClass:[OperationRecordForUTSBTableViewCell class] forCellReuseIdentifier:cellID4];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (KScrollMaskView *)kScrollMaskView {
    if (!_kScrollMaskView) {
        KScrollMaskView *kScrollMaskView = [[KScrollMaskView alloc] init];
        kScrollMaskView.frontTitleColor = [UIColor blackColor];
        _kScrollMaskView = kScrollMaskView;
    }
    return _kScrollMaskView;
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
