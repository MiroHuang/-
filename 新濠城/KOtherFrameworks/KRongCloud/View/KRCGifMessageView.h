//
//  KRCGifMessageView.h
//  新濠城
//
//  Created by XHC on 2017/10/17.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRCGifMessageView : UIView

- (void)reloadCellContentView;

@property(nonatomic, strong) RCMessageModel *dataModel;

@end
