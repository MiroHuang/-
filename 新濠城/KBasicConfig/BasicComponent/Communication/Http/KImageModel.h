//
//  KImageModel.h
//  TuBa3.0
//
//  Created by XHC on 2017/4/25.
//  Copyright © 2017年 air. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KImageModel : NSObject
@property (nonatomic, copy) UIImage *kImage;
@property (nonatomic, copy) NSString *kImageKey;
@property (nonatomic, assign) CGFloat kCompressionQuality;
@property (nonatomic, copy) NSData *kImageData;
@property (nonatomic, copy) NSString *kImageUrl;
@property (nonatomic, assign) BOOL kSelected;
@end
