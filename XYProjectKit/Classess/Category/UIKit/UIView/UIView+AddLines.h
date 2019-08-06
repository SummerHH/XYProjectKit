//
//  UIView+AddLines.h
//  fula
//
//  Created by cby on 16/9/10.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYGridLayer.h"

@interface UIView (XYSwizzing)

@end

@interface UIView (AddLines)

/**
 *   底部添加线
 * color 颜色
 */
- (XYGridLayer *)addBottomLine:(UIColor *)color;
/**
 * @param color 颜色
 * @param offset 左右相等相等间距
 */
- (XYGridLayer *)addBottomLine:(UIColor *)color offset:(CGFloat)offset;
/**
 * @param color 颜色
 * @param offset 居左边间距
 */
- (XYGridLayer *)addBottomLine:(UIColor *)color leftOffset:(CGFloat)offset;
/**
 * @param color 颜色
 * @param offset 居右边间距
 */
- (XYGridLayer *)addBottomLine:(UIColor *)color rightOffset:(CGFloat)offset;
/**
 * @param color 颜色
 * @param offset 左右相等相等间距
 * @param lineWidth 宽度
 */
- (XYGridLayer *)addBottomLine:(UIColor *)color offset:(CGFloat)offset lineWidth:(CGFloat)lineWidth;
/**
 * @param color 颜色
 * @param bottomOffset 底部间距
 * @param leftOffset 左边间距
 * @param rightOffset 右边间距
 */
- (XYGridLayer *)addBottomLine:(UIColor *)color bottomOffset:(CGFloat)bottomOffset leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset;
/**
 * @param color 颜色
 */
- (void)setBottomLineColor:(UIColor *)color;

/**
 * 右边添加线
 */
- (XYGridLayer *)addRightLine:(UIColor *)color;
/**
 * @param color 颜色
 * @param offset 上下间距
 */
- (XYGridLayer *)addRightLine:(UIColor *)color
                       offset:(CGFloat)offset;
/**
 * @param color 颜色
 * @param offset 上下间距
 * @param lineWidth 宽
 */
- (XYGridLayer *)addRightLine:(UIColor *)color
                       offset:(CGFloat)offset
                    lineWidth:(CGFloat)lineWidth;

/**
 * 顶部添加线
 */
- (void)addTopLine:(UIColor *)color;
/**
 * @param color 颜色
 */
- (void)addTopLine:(UIColor *)color
         withFrame:(CGRect)frame;
/**
 * @param color 颜色
 * @param height 高度
 */
- (void)addTopLine:(UIColor *)color
            height:(CGFloat)height;

/**
 * @param color 颜色
 * @param width 宽度
 */
- (void)addTopLine:(UIColor *)color
             width:(CGFloat)width;

- (void)addLeftLine:(UIColor *)color;

@end
