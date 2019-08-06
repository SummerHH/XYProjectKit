//
//  CALayer+XYExt.m
//  fula
//
//  Created by cby on 2017/5/20.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "CALayer+XYExt.h"

@implementation CALayer (XYExt)

- (CGPoint)center
{
    CGPoint center = CGPointMake(self.x + self.width / 2.0, self.y + self.height / 2.0);
    return center;
}

- (void)setCenter:(CGPoint)center
{
    CGFloat x = center.x - self.width / 2.0;
    CGFloat y = center.y - self.height / 2.0;
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)centerY
{
    CGFloat centerY = self.y + self.height / 2.0;
    return centerY;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGFloat y = centerY - self.height / 2.0;
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)centerX
{
    CGFloat centerX = self.x + self.width / 2.0;
    return centerX;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGFloat x = centerX - self.width / 2.0;
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
