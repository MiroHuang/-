//
//  UIButton+KButton.m
//  新濠城
//
//  Created by XHC on 2017/11/1.
//  Copyright © 2017年 XHC. All rights reserved.
//

#import "UIButton+KButton.h"

@implementation UIButton (KButton)
- (CGFloat)setLeftImage:(UIImage *)image andImageSize:(CGSize)imageSize withRightTitle:(NSString *)title andTitleFont:(UIFont *)titlefont withImageMargin:(CGFloat)imageMargin forState:(UIControlState)stateType {
    self.titleLabel.font = titlefont;
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titlefont} context:nil].size;
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imageMargin)];
    [self setImage:image forState:stateType];
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, imageMargin, 0, 0)];
    [self setTitle:title forState:stateType];
    
    CGFloat width = textSize.width + imageMargin;
    if (imageSize.width == 0 || imageSize.height == 0) {
        width += image.size.width;
    }else{
        width += imageSize.width;
    }
    return ceil(width);
}
@end
