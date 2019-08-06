//
//  UIView+RoundedCorner.m
//  UIImageRoundedCornerDemo
//
//  Created by jm on 16/2/25.
//  Copyright © 2016年 Jim. All rights reserved.
//

#import "UIView+RoundedCorner.h"
#import <objc/runtime.h>

static NSOperationQueue *xy_operationQueue;
static char xy_operationKey;

@implementation UIView (RoundedCorner)

+ (void)load {
    xy_operationQueue = [[NSOperationQueue alloc] init];
}

- (NSOperation *)xy_getOperation {
    id operation = objc_getAssociatedObject(self, &xy_operationKey);
    return operation;
}

- (void)xy_setOperation:(NSOperation *)operation {
    objc_setAssociatedObject(self, &xy_operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xy_cancelOperation {
    NSOperation *operation = [self xy_getOperation];
    [operation cancel];
    [self xy_setOperation:nil];
}

- (void)xy_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    [self xy_setCornerRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)xy_setRadius:(XYRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    [self xy_setRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)xy_setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor {
    [self xy_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)xy_setRadius:(XYRadius)radius withBackgroundColor:(UIColor *)backgroundColor {
    [self xy_setRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)xy_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image {
    [self xy_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)xy_setRadius:(XYRadius)radius withImage:(UIImage *)image {
    [self xy_setRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)xy_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    [self xy_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)xy_setRadius:(XYRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    [self xy_setRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)xy_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    [self xy_setRadius:XYRadiusMake(radius, radius, radius, radius) withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode];
}

- (void)xy_setRadius:(XYRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    [self xy_cancelOperation];
    
    [self xy_setRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode size:CGSizeZero];
}

- (void)xy_setRadius:(XYRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    
    __block CGSize _size = size;
    
    __weak typeof(self) wself = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if ([[wself xy_getOperation] isCancelled]) return;
        
        if (CGSizeEqualToSize(_size, CGSizeZero)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _size = wself.bounds.size;
            });
        }
        
        CGSize size2 = CGSizeMake(pixel(_size.width), pixel(_size.height));
        
        UIImage *image = [UIImage xy_imageWithRoundedCornersAndSize:size2 radius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(wself) self = wself;
            if ([[self xy_getOperation] isCancelled]) return;
            
            self.frame = CGRectMake(pixel(self.frame.origin.x), pixel(self.frame.origin.y), size2.width, size2.height);
            if ([self isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)self).image = image;
            } else if ([self isKindOfClass:[UIButton class]] && backgroundImage) {
                [((UIButton *)self) setBackgroundImage:image forState:UIControlStateNormal];
            } else if ([self isKindOfClass:[UILabel class]]) {
                self.layer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
            } else {
                self.layer.contents = (__bridge id _Nullable)(image.CGImage);
            }
        }];
    }];
    
    [self xy_setOperation:blockOperation];
    [xy_operationQueue addOperation:blockOperation];
}

static inline float pixel(float num) {
    float unit = 1.0 / [UIScreen mainScreen].scale;
    double remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0? unit: 0);
}

@end
