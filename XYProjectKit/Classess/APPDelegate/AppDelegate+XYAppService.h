//
//  AppDelegate+XYAppService.h
//  ProjectUkitSet
//
//  Created by xiaoye on 2018/7/4.
//  Copyright © 2018年 xiaoye. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (XYAppService)

/// 初始化 window
- (void)initWindow;

/// 初始化网络配置
- (void)NetWorkConfig;

/// 初始化导航栏
- (void)setNavBarAppearence;

/// 初始化服务
- (void)initService;

/// 初始化 umeng
- (void)initUmengService;

/// 初始化 bugly
- (void)initBugly;

/// 当前顶层控制器
- (UIViewController*)getCurrentVC;

/// 当前的根控制器
- (UIViewController*)getCurrentUIVC;

/// 单例
+ (AppDelegate *)shareAppDelegate;

@end
