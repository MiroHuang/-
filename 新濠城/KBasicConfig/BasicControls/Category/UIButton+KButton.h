//
//  UIButton+KButton.h
//  新濠城
//
//  Created by XHC on 2017/11/1.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KButton)
- (CGFloat)setLeftImage:(UIImage *)image andImageSize:(CGSize)imageSize withRightTitle:(NSString *)title andTitleFont:(UIFont *)titlefont withImageMargin:(CGFloat)imageMargin forState:(UIControlState)stateType;
@end
