
//
//  UIView+XYExt.m
//  fula
//
//  Created by cby on 2016/12/27.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import "UIView+XYExt.h"

// 默认圆角
#define kCornerRadius   5.0f

@implementation UIView (XYExt)

- (void)solveUIWidgetFuzzy {
    
    CGRect frame = self.frame;
    int x = floor(frame.origin.x);
    int y = floor(frame.origin.y);
    int w = floor(frame.size.width);
    int h = floor(frame.size.height);
    
    self.frame = CGRectMake(x, y, w, h);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

-(void)setCircle {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
}

- (void)setCornerRadius:(CGFloat)radius {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

-(void)setCornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = kCornerRadius;
}

-(void)setBorderColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
}
@end
