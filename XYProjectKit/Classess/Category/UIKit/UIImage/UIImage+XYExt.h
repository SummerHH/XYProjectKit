//
//  UIImage+XYExt.h
//  fula
//
//  Created by cby on 2016/10/29.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XYExt)

//给图片着色
+ (UIImage *)imageWithColor:(UIColor *)color;
//通过颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize) size;
//切圆角图片
- (UIImage *)roundedImage:(CGFloat)cornerRadius;
//绘制圆角图片
- (UIImage *)clipImage;

// 使用 blend 改变图片的颜色
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
//过度颜色
+ (UIImage *)gradientImage:(CGRect)rect startColor:(UIColor *)starColor endColor:(UIColor *)endColor;

//压缩一张图片 最大宽高1280 类似于微信算法
+ (UIImage *)getJPEGImagerImg:(UIImage *)image;
//压缩多张图片 最大宽高1280 类似于微信算法
+ (NSArray *)getJPEGImagerImgArr:(NSArray *)imageArr;
//压缩一张图片 自定义最大宽高
+ (UIImage *)getJPEGImagerImg:(UIImage *)image compressibilityFactor:(CGFloat)compressibilityFactor;
//压缩多张图片 自定义最大宽高
+ (NSArray *)getJPEGImagerImgArr:(NSArray *)imageArr compressibilityFactor:(CGFloat)compressibilityFactor;
//压缩图片的宽度
- (UIImage *)compressImageTargetWidth:(CGFloat)targetWidth;
//根据宽高压缩图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
