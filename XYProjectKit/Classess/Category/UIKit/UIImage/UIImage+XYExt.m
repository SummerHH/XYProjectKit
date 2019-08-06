//
//  UIImage+XYExt.m
//  fula
//
//  Created by cby on 2016/10/29.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import "UIImage+XYExt.h"
#define KCompressibilityFactor 1280.00

@implementation UIImage (XYExt)

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight) {
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    //根据圆角路径绘制
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize) size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 开启位图上下文
    UIGraphicsBeginImageContext(size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    return [self imageWithColor:color size:rect.size];
}

- (UIImage *)roundedImage:(CGFloat)cornerRadius {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [path addClip];
    [self drawInRect:rect];
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (UIImage *)clipImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(contextRef, rect);
    CGContextClip(contextRef);
    
    // 画图片
    [self drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)compressImageTargetWidth:(CGFloat)targetWidth
{
    CGSize imageSize = self.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)gradientImage:(CGRect)rect startColor:(UIColor *)starColor endColor:(UIColor *)endColor
{
    if(!starColor || !endColor)
    {
        return nil;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[3] = {0.0f, 1.0f};
    
    NSInteger startColorNum = CGColorGetNumberOfComponents(starColor.CGColor);
    NSInteger endColorNum = CGColorGetNumberOfComponents(endColor.CGColor);
    CGFloat *startComponents = (CGFloat *)CGColorGetComponents(starColor.CGColor);
    CGFloat *endComponents = (CGFloat *)CGColorGetComponents(endColor.CGColor);
    CGFloat colors[startColorNum + endColorNum];
    NSInteger index = 0;
    for (; index < startColorNum; index ++)
    {
        colors[index] = startComponents[index];
    }
    for (; index < endColorNum + startColorNum; index ++)
    {
        colors[index] = endComponents[index - startColorNum];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

# pragma mark - UIImage+Tint.h
- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


#pragma mark - 压缩一张图片 最大宽高1280 类似于微信算法
+ (UIImage *)getJPEGImagerImg:(UIImage *)image {
    CGFloat oldImg_WID = image.size.width;
    CGFloat oldImg_HEI = image.size.height;
    //CGFloat aspectRatio = oldImg_WID/oldImg_HEI;//宽高比
    if(oldImg_WID > KCompressibilityFactor || oldImg_HEI > KCompressibilityFactor){
        //超过设置的最大宽度 先判断那个边最长
        if(oldImg_WID > oldImg_HEI){
            //宽度大于高度
            oldImg_HEI = (KCompressibilityFactor * oldImg_HEI)/oldImg_WID;
            oldImg_WID = KCompressibilityFactor;
        }else{
            oldImg_WID = (KCompressibilityFactor * oldImg_WID)/oldImg_HEI;
            oldImg_HEI = KCompressibilityFactor;
        }
    }
    UIImage *newImg = [self imageWithImage:image scaledToSize:CGSizeMake(oldImg_WID, oldImg_HEI)];
    NSData *dJpeg = nil;
    if (UIImagePNGRepresentation(newImg)==nil) {
        dJpeg = UIImageJPEGRepresentation(newImg, 0.5);
    }else{
        dJpeg = UIImagePNGRepresentation(newImg);
    }
    return [UIImage imageWithData:dJpeg];
}
#pragma mark - 压缩多张图片 最大宽高1280 类似于微信算法
+ (NSArray *)getJPEGImagerImgArr:(NSArray *)imageArr {
    NSMutableArray *newImgArr = [NSMutableArray new];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *newImg = [self getJPEGImagerImg:imageArr[i]];
        [newImgArr addObject:newImg];
    }
    return newImgArr;
}
#pragma mark - 压缩一张图片 自定义最大宽高
+ (UIImage *)getJPEGImagerImg:(UIImage *)image compressibilityFactor:(CGFloat)compressibilityFactor {
    CGFloat oldImg_WID = image.size.width;
    CGFloat oldImg_HEI = image.size.height;
    //CGFloat aspectRatio = oldImg_WID/oldImg_HEI;//宽高比
    if(oldImg_WID > compressibilityFactor || oldImg_HEI > compressibilityFactor){
        //超过设置的最大宽度 先判断那个边最长
        if(oldImg_WID > oldImg_HEI){
            //宽度大于高度
            oldImg_HEI = (compressibilityFactor * oldImg_HEI)/oldImg_WID;
            oldImg_WID = compressibilityFactor;
        }else{
            oldImg_WID = (compressibilityFactor * oldImg_WID)/oldImg_HEI;
            oldImg_HEI = compressibilityFactor;
        }
    }
    UIImage *newImg = [self imageWithImage:image scaledToSize:CGSizeMake(oldImg_WID, oldImg_HEI)];
    NSData *dJpeg = nil;
    if (UIImagePNGRepresentation(newImg)==nil) {
        dJpeg = UIImageJPEGRepresentation(newImg, 0.5);
    }else{
        dJpeg = UIImagePNGRepresentation(newImg);
    }
    return [UIImage imageWithData:dJpeg];
}
#pragma mark - 压缩多张图片 自定义最大宽高
+ (NSArray *)getJPEGImagerImgArr:(NSArray *)imageArr compressibilityFactor:(CGFloat)compressibilityFactor {
    NSMutableArray *newImgArr = [NSMutableArray new];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *newImg = [self getJPEGImagerImg:imageArr[i] compressibilityFactor:compressibilityFactor];
        [newImgArr addObject:newImg];
    }
    return newImgArr;
}

#pragma mark - 根据宽高压缩图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
