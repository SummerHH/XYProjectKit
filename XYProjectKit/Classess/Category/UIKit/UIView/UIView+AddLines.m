
//
//  UIView+AddLines.m
//  fula
//
//  Created by cby on 16/9/10.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import "UIView+XYExt.h"
#import "UIView+AddLines.h"
#import <objc/runtime.h>
#import "NSObject+XYSwizzle.h"

@implementation UIView (AddLines)

static NSString *bottomKey = @"bottomLine";
static NSString *rightKey = @"rightLine";
static NSString *leftKey = @"leftLine";
static NSString *topKey = @"topLine";

static NSString *bottomLineFrameKey = @"bottomLineFrame";
static NSString *rightLineFrameKey = @"rightLineFrame";
static NSString *leftLineFrameKey = @"leftLineFrame";
static NSString *topLineFrameKey = @"topLineFrame";

# pragma mark - bottomLine

- (XYGridLayer *)addBottomLineType:(XYGridType)type color:(UIColor *)color {
    
    XYGridLayer *bottomLine = objc_getAssociatedObject(self, &bottomLine);
    if (bottomLine) {
        [self.layer addSublayer:bottomLine];
        return bottomLine;
    }
    bottomLine = [[XYGridLayer alloc] initWithType:type color:color];
    objc_setAssociatedObject(self, &bottomKey, bottomLine, OBJC_ASSOCIATION_RETAIN);
    [self.layer addSublayer:bottomLine];
    return bottomLine;
}

- (XYGridLayer *)addBottomLine:(UIColor *)color {
    XYGridLayer *layer = [self addBottomLineType:XYGridTypeBottom color:color];
  
    return layer;
}

- (XYGridLayer *)addBottomLine:(UIColor *)color offset:(CGFloat)offset {
    XYGridLayer *layer = [self addBottomLine:color];
    layer.offset = @(offset);
    return layer;
}

- (XYGridLayer *)addBottomLine:(UIColor *)color rightOffset:(CGFloat)offset {
    
    XYGridLayer *layer = [self addBottomLineType:XYGridTypeBottomOffsetRight color:color];
    layer.offset = @(offset);
    return layer;
}

- (XYGridLayer *)addBottomLine:(UIColor *)color leftOffset:(CGFloat)offset {
    
    XYGridLayer *layer = [self addBottomLineType:XYGridTypeBottomOffsetLefit color:color];
    layer.offset = @(offset);
    return layer;
}

- (XYGridLayer *)addBottomLine:(UIColor *)color offset:(CGFloat)offset lineWidth:(CGFloat)lineWidth {
    XYGridLayer *layer = [self addBottomLine:color];
    layer.offset = @(offset);
    layer.lineWidth = @(lineWidth);
    return layer;
}

- (XYGridLayer *)addBottomLine:(UIColor *)color bottomOffset:(CGFloat)bottomOffset leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset; {
    
    XYGridLayer *lineLayer = [self addBottomLineType:XYGridTypeBottomFrame color:color];
    lineLayer.offset = @(bottomOffset);
    lineLayer.leftOffset = @(leftOffset);
    lineLayer.rightOffset = @(rightOffset);
    return lineLayer;
}

- (XYGridLayer *)xy_bottomLine {
    return objc_getAssociatedObject(self, &bottomKey);
}

- (void)setBottomLineColor:(UIColor *)color {
    XYGridLayer *bottomLine = objc_getAssociatedObject(self, &bottomKey);
    bottomLine.backgroundColor = color.CGColor;
}

# pragma mark - rightLine
- (XYGridLayer *)addRightLine:(UIColor *)color {
    XYGridLayer *rightLine = [self rightLine];
    if (rightLine) {
        [self.layer addSublayer:rightLine];
        return rightLine;
    }
    rightLine = [[XYGridLayer alloc] initWithType:XYGridTypeRight color:color];
    objc_setAssociatedObject(self, &rightKey, rightLine, OBJC_ASSOCIATION_RETAIN);
    [self.layer addSublayer:rightLine];
    return rightLine;
}

- (XYGridLayer *)addRightLine:(UIColor *)color offset:(CGFloat)offset {
    XYGridLayer *rightLine = [self addRightLine:color];
    rightLine.offset = @(offset);
    return rightLine;
}

- (XYGridLayer *)addRightLine:(UIColor *)color offset:(CGFloat)offset lineWidth:(CGFloat)lineWidth {
    XYGridLayer *rightLine = [self addRightLine:color];
    rightLine.offset = @(offset);
    rightLine.lineWidth = @(lineWidth);
    return rightLine;
}

- (XYGridLayer *)rightLine {
    XYGridLayer *layer = objc_getAssociatedObject(self, &rightKey);
    return layer;
}

# pragma mark - topLine
- (void)addTopLine:(UIColor *)color {
    CALayer *topLine = objc_getAssociatedObject(self, &topKey);
    //    NSLog(@"%@  __ topLine %@  lineFrame %@", topLine.superlayer, topLine, NSStringFromCGRect(topLine.frame));
    if (topLine) {
        [self.layer addSublayer:topLine];
        return;
    }
    topLine = [CALayer layer];
    objc_setAssociatedObject(self, &topKey, topLine, OBJC_ASSOCIATION_RETAIN);
    topLine.frame = CGRectMake(0, 0, self.width, 1);
    topLine.backgroundColor = color.CGColor;
    [self.layer addSublayer:topLine];
}

- (void)addTopLine:(UIColor *)color withFrame:(CGRect)frame {
    [self addTopLine:color];
    self.xy_topLine.frame = frame;
}

- (void)addTopLine:(UIColor *)color height:(CGFloat)height {
    [self addTopLine:color];
    self.xy_topLine.frame = CGRectMake(0, 0, self.width, height);
}

- (void)addTopLine:(UIColor *)color width:(CGFloat)width {
    [self addTopLine:color];
    self.xy_topLine.frame = CGRectMake(0, 0, width, 1);
}

- (CALayer *)xy_topLine {
    return objc_getAssociatedObject(self, &topKey);
}

# pragma mark - leftLine
- (void)addLeftLine:(UIColor *)color {
    [self addLeftLine:color height:self.height - 10];
}

- (void)addLeftLine:(UIColor *)color height:(CGFloat)height {
    [self addLeftLine:color frame:CGRectMake(0, 5, 1, height - 10)];
}

- (void)addLeftLine:(UIColor *)color frame:(CGRect)frame {
    CALayer *leftView = [self leftLine];
    if (leftView) {
        [self.layer addSublayer:leftView];
        return;
    }
    leftView = [[CALayer alloc] init];
    leftView.frame = frame;
    objc_setAssociatedObject(self, &leftKey, leftView, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &leftLineFrameKey, [NSValue valueWithCGRect:frame], OBJC_ASSOCIATION_RETAIN);
    leftView.backgroundColor = color.CGColor;
    [self.layer addSublayer:leftView];
}

- (CGRect)leftLineFrame {
    NSValue *frameValue = objc_getAssociatedObject(self, &leftLineFrameKey);
    CGRect frame = [frameValue CGRectValue];
    frame.size.height = self.height - 10;
    return frame;
}

- (CALayer *)leftLine {
    return objc_getAssociatedObject(self, &leftKey);
}

@end

@implementation UIView (XYSwizzing)

+ (void)load {
    // swizzle
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // hook 函数
        [UIView swizzleOriSelector:@selector(layoutSubviews)
                   withNewSelector:@selector(xy_layoutSubviews)];
    });
}

# pragma mark - addLineXY_layoutSubviewsSwizzing
- (void)xy_layoutSubviews {
    [self xy_layoutSubviews];
    
    if(self.xy_bottomLine) {
//        self.bottomLine.frame = [self bottomLineFrame];
        [self.xy_bottomLine layoutWithSuperViewFrame:self.frame];
    }
//    if(self.xy_topLine)
//    {
//        self.xy_topLine.frame = CGRectMake(0, 0, self.width, 1);
//    }
    
    if(self.leftLine) {
        self.leftLine.frame = [self leftLineFrame];
    }
    
    if(self.rightLine) {
//        self.rightLine.frame = [self rightLineFrame];
        [self.rightLine layoutWithSuperViewFrame:self.frame];
    }
}

@end
