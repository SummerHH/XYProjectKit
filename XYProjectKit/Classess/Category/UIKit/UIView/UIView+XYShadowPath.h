//
//  UIView+XYShadowPath.h
//  LeRongRong
//
//  Created by xiaoye on 2019/3/23.
//  Copyright © 2019 Rong Zheng De. All rights reserved.
//  给 UIView 添加阴影

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,XYShadowPathSide) {
    XYShadowPathLeft,       //左边
    XYShadowPathRight,      //右边
    XYShadowPathTop,        //顶部
    XYShadowPathBottom,     //底部
    XYShadowPathNoTop,      //去除顶部
    XYShadowPathAllSide     //四角
};
@interface UIView (XYShadowPath)

/**
 * shadowColor 阴影颜色
 * shadowOpacity 阴影透明度，默认0
 * shadowRadius  阴影半径，默认3
 * shadowPathSide 设置哪一侧的阴影，
 * shadowPathWidth 阴影的宽度，
 */

-(void)xy_SetShadowPathWith:(UIColor *)shadowColor
              shadowOpacity:(CGFloat)shadowOpacity
               shadowRadius:(CGFloat)shadowRadius
                 shadowSide:(XYShadowPathSide)shadowPathSide
            shadowPathWidth:(CGFloat)shadowPathWidth;

@end

NS_ASSUME_NONNULL_END
