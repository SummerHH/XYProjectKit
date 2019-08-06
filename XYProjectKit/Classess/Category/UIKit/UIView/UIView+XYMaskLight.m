//
//  UIView+XYMaskLight.m
//  fula
//
//  Created by 叶炯 on 2017/12/2.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "UIView+XYMaskLight.h"
#import <objc/runtime.h>


static const char lightRotationAngleKey = '1';
static const char lightWidthKey = '2';
static const char lightAnimationIntervalKey = '3';
static const char lightAnimationNextShowIntervalKey = '4';
static const char lightAniDirectionKey = '5';
static const char lightBackLayerKey = '6';
static const char grandLayerKey = '7';
static const char nextAnimationTimerKey = '8';

@interface UIView() <CAAnimationDelegate>

@property (strong, nonatomic) CALayer *lightBackLayer;

@property (strong, nonatomic) CALayer *grandLayer;

@property (strong, nonatomic) NSTimer *nextAnimationTimer;

@end

@implementation UIView (XYMaskLight)

/**
 开启动画
 */
- (void)startLightAnimation {
    
    if ([self isKindOfClass:[UIImageView class]]) { //如果是ImageView
        if (!self.lightBackLayer) {
            //亮光的背景Layer 到时候就在这个页面添加Mask
            CALayer *lightBackLayer = [[CALayer alloc] init];
            lightBackLayer.backgroundColor = [UIColor clearColor].CGColor;
            lightBackLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            [self.layer addSublayer:lightBackLayer];
            self.lightBackLayer = lightBackLayer;
            
            //亮光渐变的Layer
            CAGradientLayer *grandLayer = [[CAGradientLayer alloc] init];
            grandLayer.colors = @[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor,(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor,(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor];
            grandLayer.frame = CGRectMake(-self.lightWidth, 0, self.lightWidth, CGRectGetHeight(self.frame));
            grandLayer.startPoint = CGPointMake(0, 0.5);//渲染的开始
            grandLayer.endPoint = CGPointMake(1, 0.5);//渲染的结束
            [self.layer addSublayer:grandLayer];
            grandLayer.transform = CATransform3DMakeRotation(self.lightRotationAngle, 0.0, 0.0, 1);
            self.grandLayer = grandLayer;
            
            [lightBackLayer addSublayer:grandLayer];
            lightBackLayer.mask = [self maskLayer];
        }
    } else {//View
        if (!self.lightBackLayer) {
            self.lightBackLayer = [[CALayer alloc] init];
            self.lightBackLayer.frame = CGRectMake(0, 0, self.lightWidth, CGRectGetHeight(self.bounds));
            
            CGRect frame = self.lightBackLayer.frame;
            CGFloat width = CGRectGetWidth(frame);
            CGFloat height = CGRectGetHeight(frame);
            CGFloat tanCornerValue = tan(M_PI / 6.0); //倾斜30°
            CGFloat cornerWidth = height * tanCornerValue; //倾斜30°的边的宽度
            
            //创建底部的白色的layer
            CAShapeLayer *bottomHalfLayer = [[CAShapeLayer alloc] init];
            CGFloat path1Width = width / 3.0;
            //画贝塞尔曲线 倾斜45°角
            UIBezierPath *path1 = [UIBezierPath bezierPath];
            [path1 moveToPoint:CGPointMake(width, 0)];
            //计算
            [path1 addLineToPoint:CGPointMake(width - cornerWidth, height)];
            [path1 addLineToPoint:CGPointMake(width - cornerWidth - path1Width, height)];
            [path1 addLineToPoint:CGPointMake(width - path1Width, 0)];
            [path1 addLineToPoint:CGPointMake(width, 0)];
            bottomHalfLayer.path = path1.CGPath;
            bottomHalfLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
            [self.lightBackLayer addSublayer:bottomHalfLayer];
            
            
            //创建上面的菱形渐变效果
            CGFloat path2Width = width - (path1Width * 0.5);
            CAGradientLayer *topGradientLayer = [[CAGradientLayer alloc] init];
            topGradientLayer.frame = CGRectMake(0, 0, path2Width, height);
            topGradientLayer.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0].CGColor,(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:1].CGColor];
            topGradientLayer.startPoint = CGPointMake(0, 0);
            topGradientLayer.endPoint = CGPointMake(1, 0);
            [self.lightBackLayer addSublayer:topGradientLayer];
            
            //创建Mask
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            UIBezierPath *path2 = [UIBezierPath bezierPath];
            [path2 moveToPoint:CGPointMake(cornerWidth, 0)];
            [path2 addLineToPoint:CGPointMake(path2Width, 0)];
            [path2 addLineToPoint:CGPointMake(width - cornerWidth - (path1Width * 0.5), height)];
            [path2 addLineToPoint:CGPointMake(0, height)];
            [path2 addLineToPoint:CGPointMake(cornerWidth, 0)];
            maskLayer.path = path2.CGPath;
            topGradientLayer.mask = maskLayer;
            
            [self.layer addSublayer:self.lightBackLayer];
        }
    }
    [self beginAnimation];
}

/**
 清除动画 将外面的东西移除
 */
- (void)removeAnimation {
    [self.nextAnimationTimer invalidate];
    self.nextAnimationTimer = nil;
    [self.lightBackLayer removeFromSuperlayer];
    self.lightBackLayer = nil;
    self.grandLayer = nil;
}

- (void)beginAnimation {
    //然后移动的动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    if (self.lightAniDirection == LightLetYourBlindAnimationDirectionRightBottom) {
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-self.lightWidth, 0)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) + self.lightWidth, CGRectGetHeight(self.bounds) + self.lightWidth)];
    }else if (self.lightAniDirection == LightLetYourBlindAnimationDirectionRightTop) {
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-self.lightWidth, CGRectGetHeight(self.bounds))];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) + self.lightWidth, -self.lightWidth)];
    }else {
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-self.lightWidth, CGRectGetHeight(self.bounds) * 0.5)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) + self.lightWidth, CGRectGetHeight(self.bounds) * 0.5)];
    }
    animation.repeatCount = 2;
    animation.duration = self.lightAnimationInterval * 2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    if ([self isKindOfClass:[UIImageView class]]) {
        [self.grandLayer removeAnimationForKey:@"imageLightBlindAnimation"];
        [self.grandLayer addAnimation:animation forKey:@"imageLightBlindAnimation"];
    }else {
        [self.lightBackLayer removeAnimationForKey:@"viewLightBlindAnimation"];
        [self.lightBackLayer addAnimation:animation forKey:@"viewLightBlindAnimation"];
    }
}

- (CALayer *)maskLayer {
    CALayer *layer = [[CALayer alloc] init];
    UIImageView *imageView = (UIImageView *)self;
    layer.contents = (__bridge id _Nullable)(imageView.image.CGImage);
    layer.frame = self.bounds;
    return layer;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.lightAnimationNextShowInterval == 0) {
        [self.lightBackLayer removeFromSuperlayer];
        self.lightBackLayer = nil;
        self.grandLayer = nil;
    } else {
        [self.nextAnimationTimer invalidate];
        self.nextAnimationTimer = nil;
        self.nextAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:self.lightAnimationNextShowInterval target:self selector:@selector(beginAnimation) userInfo:nil repeats:NO];
    }
}

#pragma mark -
#pragma mark - 属性
- (void)setLightRotationAngle:(CGFloat)lightRotationAngle {
    objc_setAssociatedObject(self, &lightRotationAngleKey, @(lightRotationAngle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lightRotationAngle {
    NSNumber *value = objc_getAssociatedObject(self, &lightRotationAngleKey);
    return [value floatValue];
}

- (void)setLightWidth:(CGFloat)lightWidth {
    objc_setAssociatedObject(self, &lightWidthKey, @(lightWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lightWidth {
    NSNumber *value = objc_getAssociatedObject(self, &lightWidthKey);
    if (!value) {
        value = @(50);
    }
    return [value floatValue];
}

- (void)setLightAnimationInterval:(NSTimeInterval)lightAnimationInterval {
    objc_setAssociatedObject(self, &lightAnimationIntervalKey, @(lightAnimationInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)lightAnimationInterval {
    NSNumber *value = objc_getAssociatedObject(self, &lightAnimationIntervalKey);
    if (!value) {
        value = @(0.5);
    }
    return [value floatValue];
}

- (void)setLightAniDirection:(LightLetYourBlindAnimationDirection)lightAniDirection {
    objc_setAssociatedObject(self, &lightAniDirectionKey, @(lightAniDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LightLetYourBlindAnimationDirection)lightAniDirection {
    NSNumber *value = objc_getAssociatedObject(self, &lightAniDirectionKey);
    return [value floatValue];
}

- (void)setLightAnimationNextShowInterval:(NSTimeInterval)lightAnimationNextShowInterval {
    objc_setAssociatedObject(self, &lightAnimationNextShowIntervalKey, @(lightAnimationNextShowInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)lightAnimationNextShowInterval {
    NSNumber *value = objc_getAssociatedObject(self, &lightAnimationNextShowIntervalKey);
    return [value floatValue];
}

- (void)setLightBackLayer:(CALayer *)lightBackLayer {
    objc_setAssociatedObject(self, &lightBackLayerKey, lightBackLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)lightBackLayer {
    return objc_getAssociatedObject(self, &lightBackLayerKey);
}

- (void)setGrandLayer:(CALayer *)grandLayer {
    objc_setAssociatedObject(self, &grandLayerKey, grandLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)grandLayer {
    return objc_getAssociatedObject(self, &grandLayerKey);
}

- (void)setNextAnimationTimer:(NSTimer *)nextAnimationTimer {
    objc_setAssociatedObject(self, &nextAnimationTimerKey, nextAnimationTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)nextAnimationTimer {
    return objc_getAssociatedObject(self, &nextAnimationTimerKey);
}

@end
