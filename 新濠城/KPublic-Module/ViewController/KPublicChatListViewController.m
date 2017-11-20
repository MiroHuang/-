//
//  KPublicChatListViewController.m
//  新濠城
//
//  Created by XHC on 2017/10/30.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KPublicChatListViewController.h"
#import "KPublicCustomServiceViewController.h"

@interface KPublicChatListViewController ()
@property (nonatomic, assign) BOOL isSelectedForCell;
@end

@implementation KPublicChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    self.conversationListTableView.tableFooterView = [UIView new];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _isSelectedForCell = NO;
}
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    [dataSource enumerateObjectsUsingBlock:^(RCConversationModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KRCGifMessage * kRCGifMessage = (KRCGifMessage *)obj.lastestMessage;
        if ([kRCGifMessage isMemberOfClass:[KRCGifMessage class]] && obj.conversationType == ConversationType_PRIVATE) {
            if ([kRCGifMessage.name isEqualToString:@"refreshuserinfo"]) {
                if (!kRCGifMessage.data || kRCGifMessage.data.length == 0) {
                    [dataSource removeObject:obj];
                }
            }
        }
        if (!kRCGifMessage) {
            [dataSource removeObject:obj];
        }
    }];
    return dataSource;
}
- (void)didDeleteConversationCell:(RCConversationModel *)model {
    [[RCIMClient sharedRCIMClient] deleteMessages:model.conversationType targetId:model.targetId success:nil error:nil];
    [super didDeleteConversationCell:model];
}
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    if (!_isSelectedForCell) {
        _isSelectedForCell = YES;
        KPublicCustomServiceViewController *viewController = [KPublicCustomServiceViewController new];
        viewController.conversationType = model.conversationType;
        viewController.targetId = model.targetId;
        viewController.title = model.conversationTitle;
        viewController.displayUserNameInCell = NO;
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
