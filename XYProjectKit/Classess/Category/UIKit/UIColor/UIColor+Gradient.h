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

+ (instancetype)colorFromHexString:(NSString *)hexString;

/**
 *  @brief 颜色传入的是十六进制字符串
 *  @param alpha 颜色的透明度
 *  @return color
 */
+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  @brief 适配暗黑模式颜色   传入的UIColor对象
 *  @param lightColor 普通模式颜色
 *  @param darkColor 暗黑模式颜色
 */
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor DarkColor:(UIColor *)darkColor;

/**
 *  @brief 适配暗黑模式   颜色传入的是 16 进制字符串
 *  @param lightColor 普通模式颜色
 *  @param darkColor 暗黑模式颜色
 */
+ (UIColor *)colorWithLightColorHexString:(NSString *)lightColor DarkColor:(NSString *)darkColor;

/**
 *  @brief 适配暗黑模式   颜色传入的是 16 进制字符串 还有透明度
 *  @param lightColor 普通模式颜色
 *  @param lightAlpha 普通模式颜色透明度
 *  @param darkColor 暗黑模式颜色
 *  @param darkAlpha 暗黑模式颜色透明度
 */
+ (UIColor *)colorWithLightColorHexString:(NSString *)lightColor WithLightColorAlpha:(CGFloat)lightAlpha DarkColor:(NSString *)darkColor WithDarkColorAlpha:(CGFloat)darkAlpha;

/**
 *  @brief  渐变颜色
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *  @return 渐变颜色
 */
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;


@end
