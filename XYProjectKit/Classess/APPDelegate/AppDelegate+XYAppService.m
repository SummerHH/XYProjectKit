//
//  AppDelegate+XYAppService.m
//  ProjectUkitSet
//
//  Created by xiaoye on 2018/7/4.
//  Copyright © 2018年 xiaoye. All rights reserved.
//

#import "AppDelegate+XYAppService.h"
#import "YYFPSLabel.h"
#import "XYShareHelp.h"
#import "KeychainUUID.h"
#import "XYAppCrashProcessManager.h"
#import "XYBaseTabBarViewController.h"
#import "XYNewFeatureViewController.h"
#import "XYLaunchAdManager.h"
#import "XYBaseNavigationViewController.h"

@implementation AppDelegate (XYAppService)

#pragma mark ————— 初始化window —————

-(void)initWindow {


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (@available(iOS 8.0, *)) {
        [[UIButton appearance] setExclusiveTouch:YES];
    }

//    if (@available(iOS 11.0, *)){
//        //UIScrollViewContentInsetAdjustmentAutomatic
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
    
    /// 显示引导页的时候不显示广告页
    NSString *lastVersion = [USER_DEFAULT objectForKey:kCurrentVersionKey];
    
    if ([kAppVersion isEqualToString:lastVersion]) {
        /// 加载广告页
        [[XYLaunchAdManager sharedInstance] loadLaunchImageAd];
        /// 指定视图
        XYBaseTabBarViewController *tabBarController = [[XYBaseTabBarViewController alloc] init];
        tabBarController.tabBar.translucent = NO;
        
        self.window.rootViewController = [[XYBaseNavigationViewController alloc] initWithRootViewControllerNoWrapping:tabBarController];
        
    }else {
        
        XYNewFeatureViewController *featureViewController = [[XYNewFeatureViewController alloc] init];
        self.window.rootViewController = featureViewController;
    }
    
    [self setNavBarAppearence];

#ifdef DEBUG
    // 刷新率
    [self.window addSubview:[[YYFPSLabel alloc] initWithFrame:CGRectMake(20, 100, 0, 0)]];
#endif
    //允许摇一摇
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
}

#pragma mark ******  初始化导航栏  *******
- (void)setNavBarAppearence {
 
    [XYNavigationBar xy_setNavigationControllerBlacklist:@[
                                                           @"XYDebugTableViewController"
                                                           ]];
    [XYNavigationBar xy_setTabBarControllerWhiteList:@[
                                                       @"XYHomeViewController",
                                                       @"XYChannelViewController",
                                                       @"XYDynamicViewController",
                                                       @"XYShopViewController",
                                                       @"XYPersonalViewController"
                                                       ]];
    /// 设置导航栏按钮颜色
    [XYNavigationBar xy_setDefaultNavBarTintColor:[UIColor greenColor]];
    /// 设置导航栏背景颜色
//    [XYNavigationBar xy_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    [XYNavigationBar xy_setDefaultNavBarBackgroundImage:[UIImage imageNamed:@"bm_up_navBg_375x64_.png"]];
    /// 设置导航栏按钮的颜色
    [XYNavigationBar xy_setDefaultNavBarTitleColor:[UIColor purpleColor]];
    /// 隐藏导航栏下面的线
    [XYNavigationBar xy_setDefaultNavBarShadowImageHidden:NO];
    [XYNavigationBar xy_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark ----- 初始化网络配置 ------

- (void)NetWorkConfig {
    //开启日志
#ifdef DEBUG
    [XYNetworkingHelper openLog];
#endif
    //设置请求超时时间
    [XYNetworkingHelper setRequestTimeoutInterval:30];
    //设置请求的路径
    [XYNetworkingHelper setBaseURL:API_BASE_URL_STRING];
}

- (void)initUmengService {

    [XYShareHelp configUSharePlatforms];
}

- (void)initBugly {
    
    [Bugly startWithAppId:kBuglyAppID];

    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.reportLogLevel = BuglyLogLevelVerbose;
    config.version = kAppVersion;
    NSString *UUID = [KeychainUUID UUID];

    config.deviceIdentifier = UUID;
    [Bugly startWithAppId:kBuglyAppID config:config];
}

#pragma mark ------ 初始化服务 ------
- (void)initService {

    //处理WKContentView的crash
    [XYAppCrashProcessManager progressWKContentViewCrash];
}

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC {
    
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }
    else if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}



@end
