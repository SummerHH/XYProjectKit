//
//  XYPresentationController.h
//  fula
//
//  Created by xiyedev on 2017/9/16.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPresentedController.h"

@interface XYPresentationController : UIPresentationController

@property (nonatomic, assign) XYPresentedViewShowStyle style;
@property (nonatomic, assign,getter=isNeedClearBack) BOOL clearBack;
//frame
@property (assign, nonatomic) CGRect showFrame;

@end
