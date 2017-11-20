//
//  KValidateObject.m
//  新濠城
//
//  Created by XHC on 2017/10/13.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "KValidateObject.h"

@implementation KValidateObject

+ (BOOL)JudgeRegularExpression:(NSString *)judgeType content:(NSString *)content {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", judgeType];
    BOOL isMatch = [pred evaluateWithObject:content];
    return isMatch;
}

@end
