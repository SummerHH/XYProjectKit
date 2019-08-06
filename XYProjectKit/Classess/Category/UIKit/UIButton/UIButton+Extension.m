//
//  UIButton+Extension.m
//  LeRongRong
//
//  Created by RongZhengDe on 2018/10/8.
//  Copyright © 2018年 Rong Zheng De. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

/**
 *  获取短信验证码倒计时
 *
 *  @param duration 倒计时时间
 */

- (void)startTimeWithDuration:(NSInteger)duration {
    __block NSInteger timeout = duration;
    
    NSString *originalTitle = [self titleForState:UIControlStateNormal];
    UIColor *originalTitleColor = [self titleColorForState:UIControlStateNormal];
    UIFont *originalFont = self.titleLabel.font;
    UIColor *backColor = [self backgroundColor];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer_t,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer_t, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer_t);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮为最初的状态
                [self setTitle:originalTitle forState:UIControlStateNormal];
                [self setTitleColor:originalTitleColor forState:UIControlStateNormal];
                self.titleLabel.font = originalFont;
                self.userInteractionEnabled = YES;
                self.backgroundColor = [UIColor redColor];
                self.alpha =1;
                [self setBackgroundColor:backColor];
            });
        }else{
            NSInteger seconds = timeout % duration;
            if(seconds == 0){
                seconds = duration;
            }
            NSString *strTime = [NSString stringWithFormat:@"倒计时 %.2ldS", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{//根据自己需求设置倒计时显示
                [self setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [self setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
                self.titleLabel.adjustsFontSizeToFitWidth = NO;//字体自适应大小
                [self setBackgroundColor:[UIColor grayColor]];
                self.alpha = 0.5;
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer_t);
}


@end


/// 切圆角按钮
@implementation APRoundedButton

- (void)makeCorner {
    UIRectCorner corners;
    
    switch ( self.style ) {
        case 0:
            corners = UIRectCornerBottomLeft;
            break;
        case 1:
            corners = UIRectCornerBottomRight;
            break;
        case 2:
            corners = UIRectCornerTopLeft;
            break;
        case 3:
            corners = UIRectCornerTopRight;
            break;
        case 4:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case 5:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case 6:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case 7:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case 8:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case 9:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
            break;
        default:
            corners = UIRectCornerAllCorners;
            break;
    }
    
    _nj_cornerRaduous = _nj_cornerRaduous ?: 10.0;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(_nj_cornerRaduous, _nj_cornerRaduous)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUIOnce];
    }
    return self;
}


- (void)setupUIOnce {
    [self makeCorner];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeCorner];
}

@end
