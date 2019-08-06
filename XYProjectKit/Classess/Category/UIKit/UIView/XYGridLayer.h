//
//  XYGridLayer.h
//  fula
//
//  Created by cby on 2017/4/12.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

typedef NS_ENUM(NSInteger, XYGridType) {
    XYGridTypeLeft,
    XYGridTypeRight,
    XYGridTypeTop,
    XYGridTypeBottom,
    XYGridTypeBottomOffsetRight,
    XYGridTypeBottomOffsetLefit,
    XYGridTypeBottomFrame
};

@interface XYGridLayer : CALayer

@property (assign, nonatomic, readonly) XYGridType type;
@property (strong, nonatomic) NSNumber *offset;
@property (strong, nonatomic) NSNumber *leftOffset;
@property (strong, nonatomic) NSNumber *rightOffset;

@property (strong, nonatomic) NSNumber *lineWidth;




+(instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)layer UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithType:(XYGridType)type color:(UIColor *)color;
- (void)layoutWithSuperViewFrame:(CGRect)frame;

@end
