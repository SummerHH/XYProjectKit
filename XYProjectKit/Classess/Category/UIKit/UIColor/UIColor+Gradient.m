//
//  UIColor+Gradient.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIColor+Gradient.h"

@implementation UIColor (Gradient)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    

    return [self colorFromHexString:hexString alpha:1.0f];

}

#pragma mark - Color from Hex
+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:alpha];
}

#pragma mark - RGBA Helper method
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

/**
 *  @brief 适配暗黑模式颜色   传入的UIColor对象
 *  @param lightColor 普通模式颜色
 *  @param darkColor 暗黑模式颜色
 */
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor DarkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return lightColor;
            } else {
                return darkColor;
            }
        }];
    } else {
        return lightColor ? lightColor : (darkColor ? darkColor : [UIColor clearColor]);
    }
}

/**
 *  @brief 适配暗黑模式   颜色传入的是 16 进制字符串
 *  @param lightColor 普通模式颜色
 *  @param darkColor 暗黑模式颜色
 */
+ (UIColor *)colorWithLightColorHexString:(NSString *)lightColor DarkColor:(NSString *)darkColor {
    return [UIColor colorWithLightColor:[UIColor colorFromHexString:lightColor] DarkColor:[UIColor colorFromHexString:darkColor]];
}

/**
 *  @brief 适配暗黑模式   颜色传入的是 16 进制字符串 还有透明度
 *  @param lightColor 普通模式颜色
 *  @param lightAlpha 普通模式颜色透明度
 *  @param darkColor 暗黑模式颜色
 *  @param darkAlpha 暗黑模式颜色透明度
 */
+ (UIColor *)colorWithLightColorHexString:(NSString *)lightColor WithLightColorAlpha:(CGFloat)lightAlpha DarkColor:(NSString *)darkColor WithDarkColorAlpha:(CGFloat)darkAlpha {
    
    return [UIColor colorWithLightColor:[UIColor colorFromHexString:lightColor alpha:lightAlpha] DarkColor:[UIColor colorFromHexString:darkColor alpha:darkAlpha]];
}

#pragma mark - Gradient Color
/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height {
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
