//
//  XYPresentedController.h
//  fula
//
//  Created by xiyedev on 2017/9/16.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPresentAnimationManager.h"

typedef void(^handleBack)(id callback);

@interface XYPresentedController : UIViewController

//创建菜单
- (instancetype)initWithShowFrame:(CGRect)showFrame ShowStyle:(XYPresentedViewShowStyle)showStyle callback:(handleBack)callback;
//获取菜单该属性可获知是否展开
@property (nonatomic, assign,getter=isPresented) BOOL presented;
//是否需要显示透明蒙板
@property (nonatomic, assign,getter=isNeedClearBack) BOOL clearBack;
//回调
@property (copy, nonatomic)handleBack callback;

@end
