//
//  XYPresentationController.m
//  fula
//
//  Created by xiyedev on 2017/9/16.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYPresentationController.h"
#import "XYColorBackView.h"

@interface XYPresentationController ()

//蒙板点击层 (只处理点击)
@property (nonatomic, strong) UIControl *coverView;
//蒙板背景展示图(只处理颜色展示)
@property (nonatomic, strong) XYColorBackView *colorBackView;

@end

@implementation XYPresentationController

- (XYColorBackView *)colorBackView
{
    if (!_colorBackView) {
        _colorBackView = [[XYColorBackView alloc]initWithFrame:my_Screen_Bounds];
        if (self.isNeedClearBack) {
            
            _colorBackView.backColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.000001];
        }else{
            
            _colorBackView.backColorView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
            if (_showFrame.origin.y > kTopHeight) {
                _colorBackView.topView.backgroundColor   = [UIColor colorWithWhite:0.1 alpha:0.4];
            }
        }
        [_colorBackView addSubview:self.coverView];
    }
    return _colorBackView;
}

//蒙板
- (UIControl *)coverView
{
    if (!_coverView) {
        
        _coverView = [[UIControl alloc]initWithFrame:my_Screen_Bounds];
        [_coverView addTarget:self action:@selector(coverViewTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverView;
}


//重写布局
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    //容器frame,不能遮挡导航栏 , 透明除外
    self.containerView.frame = my_Screen_Bounds;
    self.presentedView.frame = self.showFrame;
    [self.containerView insertSubview:self.colorBackView belowSubview:self.presentedView];
}


//蒙板点击
- (void)coverViewTouch {

    //    CGFloat duraration = [self animationDuration];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.colorBackView.backColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.001];
        self.colorBackView.topView.backgroundColor       = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.001];
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    } completion:^(BOOL finished) {
        
        if ([self.presentedViewController isKindOfClass:[XYPresentedController class]]) {
            XYPresentedController *presentedVc           = (XYPresentedController *)self.presentedViewController;
            presentedVc.presented                        = NO;
        }
        [self.coverView removeFromSuperview];
    }];
}

- (CGFloat)animationDuration
{
    CGFloat duration = 0.0;
    switch (_style) {
        case XYPresentedViewShowStyleFromTopDropStyle:
        case XYPresentedViewShowStyleFromBottomDropStyle:
        case XYPresentedViewShowStyleFromTopSpreadStyle:
        case XYPresentedViewShowStyleFromBottomSpreadStyle:
            
            duration = 0.25;
            break;
        case XYPresentedViewShowStyleFromTopSpringStyle:
        case XYPresentedViewShowStyleFromBottomSpringStyle:
            
            duration = 0.5;
            break;
        case XYPresentedViewShowStyleSuddenStyle:
            
            duration = 0.1;
            break;
        default:
            break;
    }
    return duration;
}


@end
