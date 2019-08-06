//
//  CALayer+XYExt.h
//  fula
//
//  Created by cby on 2017/5/20.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (XYExt)

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

@end
