//
//  BasicViewController.h
//  CowX.Wallet
//
//  Created by 黄凯 on 16/4/7.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ResponseDataStyleNoneRequest,
    ResponseDataStyleDirectRequest,
    ResponseDataStyleAfterRequest,
} ResponseDataStyle;

typedef enum {
    RefreshDataStyleNoneRefresh,
    RefreshDataStyleHeaderRefresh,
    RefreshDataStyleFooterRefresh,
} RefreshDataStyle;

/** BasicViewController */
@interface BasicViewController : UIViewController

@end
