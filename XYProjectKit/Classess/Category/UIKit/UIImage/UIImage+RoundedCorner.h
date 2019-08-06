//
//  UIImage+RoundedCorner.h
//  SelectTags
//
//  Created by jm on 16/2/22.
//  Copyright © 2016年 Jim. All rights reserved.
//  生成带圆角的图片

#import <UIKit/UIKit.h>

struct XYRadius {
    CGFloat topLeftRadius;
    CGFloat topRightRadius;
    CGFloat bottomLeftRadius;
    CGFloat bottomRightRadius;
};
typedef struct XYRadius XYRadius;

static inline XYRadius XYRadiusMake(CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius) {
    XYRadius radius;
    radius.topLeftRadius = topLeftRadius;
    radius.topRightRadius = topRightRadius;
    radius.bottomLeftRadius = bottomLeftRadius;
    radius.bottomRightRadius = bottomRightRadius;
    return radius;
}

@interface UIImage (RoundedCorner)

/**
 *  @brief 生成带圆角的图片
 *
 *  @param sizeToFit 图片的大小
 *  @param radius 圆角的角度
 *  @return 生成之后指定圆角的图片
 */

- (UIImage *)xy_imageWithRoundedCornersAndSize:(CGSize)sizeToFit cornerRadius:(CGFloat)radius;

/**
 *  @brief 生成带圆角的图片
 *
 *  @param sizeToFit 图片的大小
 *  @param radius 圆角的角度
 *  @param contentMode 填充图片的模式
 *  @return 生成之后指定图片
 */

- (UIImage *)xy_imageWithRoundedCornersAndSize:(CGSize)sizeToFit cornerRadius:(CGFloat)radius withContentMode:(UIViewContentMode)contentMode;

/**
 *  @brief 生成带圆角的图片
 *
 *  @param sizeToFit 图片的大小
 *  @param radius 圆角的角度
 *  @param borderColor 边框的颜色
 *  @param borderWidth 边框的宽度
 *  @return 生成之后指定图片
 */

+ (UIImage *)xy_imageWithRoundedCornersAndSize:(CGSize)sizeToFit cornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  @brief 生成带圆角的图片
 *
 *  @param sizeToFit 图片的大小
 *  @param radius 圆角的角度
 *  @param backgroundColor 背景颜色
 *  @return 生成之后指定图片
 */

+ (UIImage *)xy_imageWithRoundedCornersAndSize:(CGSize)sizeToFit cornerRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor;

/**
 *  @brief 生成带圆角的图片
 *
 *  @param sizeToFit 图片的大小
 *  @param radius 圆角的角度
 *  @param borderColor 边框的颜色
 *  @param borderWidth 边框的宽度
 *  @param backgroundColor 背景颜色
 *  @param backgroundImage 背景图片
 *  @param contentMode 填充图片的模式
 *  @return 生成之后指定图片
 */

+ (UIImage *)xy_imageWithRoundedCornersAndSize:(CGSize)sizeToFit cornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode;

/**
 *  @brief 生成带圆角的图片
 *
 *  @param sizeToFit 图片的大小
 *  @param radius  XYRadius
 *  @param borderColor 边框的颜色
 *  @param borderWidth 边框的宽度
 *  @param backgroundColor 背景颜色
 *  @param backgroundImage 背景图片
 *  @param contentMode 填充图片的模式
 *  @return 生成之后指定图片
 */
+ (UIImage *)xy_imageWithRoundedCornersAndSize:(CGSize)sizeToFit radius:(XYRadius)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode;

@end

