//
//  KBaccaratRecordModel.h
//  新濠城
//
//  Created by XHC on 2017/10/18.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBaccaratRecordModel : NSObject
@property (nonatomic, assign) NSInteger tie;
@property (nonatomic, assign) NSInteger playerpair;
@property (nonatomic, assign) NSInteger dealerpair;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger dealer;
@property (nonatomic, assign) NSInteger player;
@end
