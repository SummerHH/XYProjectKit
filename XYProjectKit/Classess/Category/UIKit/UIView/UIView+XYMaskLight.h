//
//  UIView+XYMaskLight.h
//  fula
//
//  Created by 叶炯 on 2017/12/2.
//  Copyright © 2017年 ixiye company. All rights reserved.
//  遮罩光

#import <UIKit/UIKit.h>

/**
 * 这个分类可以在View和ImageView中使用
 * 注意：在ImageView中 注意一定要先设置image，后期可能会在这个方面做一些处理
 */

typedef NS_ENUM(NSUInteger, LightLetYourBlindAnimationDirection) {

    LightLetYourBlindAnimationDirectionRight = 0, //水平向右
    LightLetYourBlindAnimationDirectionRightBottom, //斜向右下
    LightLetYourBlindAnimationDirectionRightTop, //斜向右上
};

@interface UIView (XYMaskLight)

/**< 亮光旋转的角度 默认为0*/
@property (assign, nonatomic) CGFloat lightRotationAngle;

/**< 亮光的宽度 默认50*/
@property (assign, nonatomic) CGFloat lightWidth;

/**< 动画时间 默认为0.5*/
@property (assign, nonatomic) NSTimeInterval lightAnimationInterval;

/**< 动画移动的方向 默认水平*/
@property (assign, nonatomic) LightLetYourBlindAnimationDirection lightAniDirection;

/**< 下一个周期显示动画的间隔时间 为0的时候 没有下一个周期*/
@property (assign, nonatomic) NSTimeInterval lightAnimationNextShowInterval;

/**
 开启动画
 */
- (void)startLightAnimation;

/**
 清除动画 将外面的东西移除
 */
- (void)removeAnimation;

@end
