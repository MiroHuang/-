//
//  KValidateObject.h
//  新濠城
//
//  Created by XHC on 2017/10/13.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 判断是否以字母开头 */
#define FirstLetterIsEnglish @"^[A-Za-z].+$"
/** 使用正则表达式判断只能含有字母和数字 */
#define OnlyContainLettersAndNumbers @"[a-zA-Z0-9]*"
/** 使用正则表达式判断只能含有中文，字母和数字 */
#define OnlyContainChineseAndLettersAndNumbers @"^[a-zA-Z\u4E00-\u9FA5\\d]*$"

@interface KValidateObject : NSObject
+ (BOOL)JudgeRegularExpression:(NSString *)judgeType content:(NSString *)content;
@end
