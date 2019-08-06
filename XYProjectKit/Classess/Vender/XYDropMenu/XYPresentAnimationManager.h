//
//  XYPresentAnimationManager.h
//  fula
//
//  Created by xiyedev on 2017/9/16.
//  Copyright © 2017年 ixiye coXYany. All rights reserved.
//

#define my_Screen_Width  [UIScreen mainScreen].bounds.size.width
#define my_Screen_Height  [UIScreen mainScreen].bounds.size.height
#define my_Screen_Bounds [UIScreen mainScreen].bounds

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, XYPresentedViewShowStyle) {

    //从上到下降动画
    XYPresentedViewShowStyleFromTopDropStyle       = 0,
    //从上倒到下展开动画
    XYPresentedViewShowStyleFromTopSpreadStyle     = 1,
    //从上到下弹簧效果
    XYPresentedViewShowStyleFromTopSpringStyle     = 2,
    //从下到上下降动画
    XYPresentedViewShowStyleFromBottomDropStyle    = 3,
    //从下到上展开动画
    XYPresentedViewShowStyleFromBottomSpreadStyle  = 4,
    //从下到上弹簧效果
    XYPresentedViewShowStyleFromBottomSpringStyle  = 5,
    //直接呈现效果
    XYPresentedViewShowStyleSuddenStyle            = 6,
    //左上角收缩效果
    XYPresentedViewShowStyleShrinkTopLeftStyle     = 7,
    //左下角收缩效果
    XYPresentedViewShowStyleShrinkBottomLeftStyle  = 8,
    //右上角收缩效果
    XYPresentedViewShowStyleShrinkTopRightStyle    = 9,
    //右下角收缩效果
    XYPresentedViewShowStyleShrinkBottomRightStyle = 10

};


@interface XYPresentAnimationManager : NSObject <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

//记录当前模态状态
@property (nonatomic, assign,getter=isPresented) BOOL presented;
//动画类型
@property (assign, nonatomic) XYPresentedViewShowStyle showStyle;
//frame
@property (assign, nonatomic) CGRect showViewFrame;
//是否显示暗色蒙板
@property (nonatomic, assign,getter=isNeedClearBack) BOOL clearBack;

@end
