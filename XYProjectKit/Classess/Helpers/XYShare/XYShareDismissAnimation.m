//
//  XYShareDismissAnimation.m
//  fula
//
//  Created by cby on 2017/4/25.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYShareDismissAnimation.h"
#import "XYShareUIViewController.h"

@implementation XYShareDismissAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    XYShareUIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    [container addSubview:toVc.view];
    [container addSubview:fromVc.view];
    CGFloat imageViewHeight = (kScreenWidth - 160) * kScreenHeight / kScreenWidth;
    [UIView animateWithDuration:0.2 animations:^{
        fromVc.imageView.transform = CGAffineTransformMakeTranslation(0, - imageViewHeight - kScreenHeight * 0.2);
    }];
    [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVc.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

@end
