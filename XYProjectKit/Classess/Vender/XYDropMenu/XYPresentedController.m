//
//  XYPresentedController.m
//  fula
//
//  Created by xiyedev on 2017/9/16.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYPresentedController.h"

@interface XYPresentedController ()

//动画管理
@property (nonatomic, strong) XYPresentAnimationManager *animationManager;

@end

@implementation XYPresentedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithShowFrame:(CGRect)showFrame ShowStyle:(XYPresentedViewShowStyle)showStyle callback:(handleBack)callback
{
    //断言
    //    NSParameterAssert(![@(showStyle)isKindOfClass:[NSNumber class]]||![@(isBottomMenu)isKindOfClass:[NSNumber class]]);
    if (self = [super init]) {
        
        //设置管理
        self.transitioningDelegate          = self.animationManager;
        self.modalPresentationStyle         = UIModalPresentationCustom;
        self.callback                       = callback;
        self.animationManager.showStyle     = showStyle;
        self.animationManager.showViewFrame = showFrame;
    }
    return self;
}



- (void)setClearBack:(BOOL)clearBack {
    _clearBack = clearBack;
    
    self.animationManager.clearBack = clearBack;
}


//管理
- (XYPresentAnimationManager *)animationManager
{
    if (!_animationManager) {
        _animationManager = [[XYPresentAnimationManager alloc]init];
    }
    return _animationManager;
}

@end
