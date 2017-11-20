//
//  FirstModuleHomePageTableViewCell.h
//  新濠城
//
//  Created by XHC on 2017/9/27.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstModuleHomePageTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *dataModel;
@property (nonatomic, copy) void(^kCompletedBlock)(NSInteger selectIndex);
@property (nonatomic, assign) NSInteger selectIndex;
@end
