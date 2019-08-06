//
//  UIColor+Gradient.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Gradient)

/**
 *  Creates a Color from a Hex representation string
 *  @param hexString   Hex string that looks like @"#FF0000" or @"FF0000"
 *  @return    Color
 */

+ (UIColor *)colorFromHexString:(NSString *)hexString;

/**i
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;


@end
