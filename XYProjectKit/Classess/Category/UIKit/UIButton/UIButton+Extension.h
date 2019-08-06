//
//  UIButton+Extension.h
//  LeRongRong
//
//  Created by RongZhengDe on 2018/10/8.
//  Copyright © 2018年 Rong Zheng De. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extension)

/**
 *  获取短信验证码倒计时
 *
 *  @param duration 倒计时时间
 */
- (void)startTimeWithDuration:(NSInteger)duration;

@end

NS_ASSUME_NONNULL_END

//  切按钮多边圆角

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface APRoundedButton : UIButton

@property (nonatomic, assign) IBInspectable NSUInteger style;
@property (nonatomic, assign) IBInspectable CGFloat nj_cornerRaduous;

@end
