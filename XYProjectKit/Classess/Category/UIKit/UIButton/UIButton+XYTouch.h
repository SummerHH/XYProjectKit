//
//  UIButton+XYTouch.h
//  ProjectUkitSet
//
//  Created by xiaoye on 2018/7/4.
//  Copyright © 2018年 xiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultInterval 0.5  //默认时间间隔

@interface UIButton (XYTouch)

/* 防止button重复点击，设置间隔 */
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

@end
