//
//  XYPresentAnimationManager.m
//  fula
//
//  Created by xiyedev on 2017/9/16.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYPresentAnimationManager.h"
#import "XYPresentationController.h"

@interface XYPresentAnimationManager ()

@end

@implementation XYPresentAnimationManager

//返回自定义模态容器
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    
    XYPresentationController *presentationVc = [[XYPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    //蒙版属性传入
    presentationVc.clearBack = _clearBack;
    presentationVc.showFrame = _showViewFrame;
    return presentationVc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

//转场动画持续时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

//自定义转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    CGRect bottomStopFrame  = CGRectMake(_showViewFrame.origin.x, my_Screen_Height + _showViewFrame.size.height, _showViewFrame.size.width, _showViewFrame.size.height);
    CGRect topStopFrame     = CGRectMake(_showViewFrame.origin.x, -_showViewFrame.size.height, _showViewFrame.size.width, _showViewFrame.size.height);
    CGRect beginFrame       = CGRectZero;
    CGRect stopFrame        = CGRectZero;
    UIView *presentedView   = nil;
    
    if (_presented) {
        
        presentedView       = [transitionContext viewForKey:UITransitionContextFromViewKey];
        beginFrame          = _showViewFrame;
        stopFrame           = [self beginStopFrame:topStopFrame bottomStop:bottomStopFrame];
        
    }else{
        
        presentedView       = [transitionContext viewForKey:UITransitionContextToViewKey];
        stopFrame           = _showViewFrame;
        beginFrame          = [self beginStopFrame:topStopFrame bottomStop:bottomStopFrame];
    }
    
    UIView *container       = [transitionContext containerView];
    [container addSubview:presentedView];
    
    //动画
    [self animationBeginFrame:beginFrame stop:stopFrame view:presentedView context:transitionContext];
}



- (void)animationBeginFrame:(CGRect)beginFrame stop:(CGRect)stopFrame view:(UIView *)presentedView context:(id<UIViewControllerContextTransitioning>)transitionContext
{
    __weak typeof(self)weakSelf = self;
    //位移动画
    if ((_showStyle == XYPresentedViewShowStyleFromTopDropStyle)||(_showStyle == XYPresentedViewShowStyleFromBottomDropStyle)) {
        
        presentedView.frame     = beginFrame;
        [UIView animateWithDuration:0.25 animations:^{
            
            presentedView.frame = stopFrame;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            weakSelf.presented = !weakSelf.presented;
        }];
        
        //伸展动画
    }else if((_showStyle == XYPresentedViewShowStyleFromTopSpreadStyle)||(_showStyle ==XYPresentedViewShowStyleFromBottomSpreadStyle)){
        
        if (_showStyle == XYPresentedViewShowStyleFromTopSpreadStyle) {
            presentedView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        }else{
            presentedView.layer.anchorPoint = CGPointMake(0.5, 1);
        }
        
        CGFloat scaleY   = 0;
        if (_presented) {
            
            scaleY       = 0.0001;
        }else{
            
            scaleY       = 1.0;
            presentedView.transform      = CGAffineTransformMakeScale(1.0, 0.0001);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            presentedView.transform      = CGAffineTransformMakeScale(1.0, scaleY);
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            weakSelf.presented = scaleY == 0.00001 ? NO : YES;
        }];
        //弹簧效果
    }else if ((_showStyle == XYPresentedViewShowStyleFromBottomSpringStyle)||(_showStyle == XYPresentedViewShowStyleFromTopSpringStyle)){
        
        presentedView.frame     = beginFrame;
        [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:8.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            presentedView.frame = stopFrame;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
           weakSelf.presented = !weakSelf.presented;
        }];
        //直接呈现
    }else if(_showStyle == XYPresentedViewShowStyleSuddenStyle){
        
        _presented ? (presentedView.alpha = 1.0) : (presentedView.alpha = 0.00001);
        [UIView animateWithDuration:0.1 animations:^{
            
            weakSelf.presented ? (presentedView.alpha = 0.00001) : (presentedView.alpha = 1.0);
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            weakSelf.presented = !weakSelf.presented;
        }];
    }else if (_showStyle ==XYPresentedViewShowStyleShrinkBottomRightStyle||
              _showStyle == XYPresentedViewShowStyleShrinkBottomLeftStyle||
              _showStyle == XYPresentedViewShowStyleShrinkTopRightStyle||
              _showStyle == XYPresentedViewShowStyleShrinkTopLeftStyle){
        //设置锚点
        switch (_showStyle) {
            case XYPresentedViewShowStyleShrinkBottomRightStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(1, 1);
            }
                break;
            case XYPresentedViewShowStyleShrinkBottomLeftStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(0, 1);
            }
                break;
            case XYPresentedViewShowStyleShrinkTopRightStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(1, 0);
            }
                break;
            case XYPresentedViewShowStyleShrinkTopLeftStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(0, 0);
            }
                break;
            default:
                break;
        }
        if (_presented) {
            [UIView animateWithDuration:0.3 animations:^{
                presentedView.alpha = 0.0001;
                presentedView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
                weakSelf.presented = !weakSelf.presented;
            }];
        }else{
            presentedView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            presentedView.alpha = 0.0001;
            [UIView animateWithDuration:0.3 animations:^{
                presentedView.alpha = 1;
                presentedView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
                weakSelf.presented = !weakSelf.presented;
            }];
        }
    }
}


- (CGRect)beginStopFrame:(CGRect)topStopFrame bottomStop:(CGRect)bottomStopFrame
{
    CGRect frame       = CGRectZero;
    switch (_showStyle) {
        case XYPresentedViewShowStyleFromTopDropStyle:
            
            frame      = topStopFrame;
            break;
        case XYPresentedViewShowStyleFromBottomDropStyle:
            
            frame      = bottomStopFrame;
            break;
        case XYPresentedViewShowStyleFromTopSpreadStyle:
            
            frame      = topStopFrame;
            break;
        case XYPresentedViewShowStyleFromBottomSpreadStyle:
            
            frame      = bottomStopFrame;
            break;
        case XYPresentedViewShowStyleFromTopSpringStyle:
            
            frame      = topStopFrame;
            break;
        case XYPresentedViewShowStyleFromBottomSpringStyle:
            
            frame      = bottomStopFrame;
            break;
        case XYPresentedViewShowStyleSuddenStyle:
            
            frame      = _showViewFrame;
            break;
        case XYPresentedViewShowStyleShrinkTopLeftStyle:
        case XYPresentedViewShowStyleShrinkTopRightStyle:
        case XYPresentedViewShowStyleShrinkBottomLeftStyle:
        case XYPresentedViewShowStyleShrinkBottomRightStyle:
            frame      = _showViewFrame;
            break;
        default:
            break;
    }
    return frame;
}


@end
