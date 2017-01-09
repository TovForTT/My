//
//  UIImage+QRCode.h
//  TTT
//
//  Created by Tov_ on 16/5/12.
//  Copyright © 2016年 Tov_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

//默认
+ (UIImage *)qrImageByContent:(NSString *)content;

//自定义大小
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size;

//自定义颜色
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

//logo
+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

@end
