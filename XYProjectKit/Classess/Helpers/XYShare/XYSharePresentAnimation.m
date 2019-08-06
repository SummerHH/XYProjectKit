//
//  XYSharePresentAnimation.m
//  fula
//
//  Created by cby on 2017/4/25.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYSharePresentAnimation.h"
#import "XYShareUIViewController.h"

@implementation XYSharePresentAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    XYShareUIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    [container addSubview:toVc.view];
    toVc.view.alpha = 0.0f;
    CGFloat imageViewHeight = (kScreenWidth - 160) * kScreenHeight / kScreenWidth;
    toVc.imageView.transform = CGAffineTransformMakeTranslation(0, -imageViewHeight - kScreenHeight * 0.2);
    [UIView animateWithDuration:0.3 animations:^{
        toVc.view.alpha = 1.0f;
    }];
    [UIView animateWithDuration:0.3 delay:0.4 usingSpringWithDamping:0.8f initialSpringVelocity:20.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toVc.imageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

@end
