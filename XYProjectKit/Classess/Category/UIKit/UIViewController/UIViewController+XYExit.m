//
//  UIViewController+XYExit.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/5/6.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "UIViewController+XYExit.h"

@implementation UIViewController (XYExit)

# pragma mark - private method

/**
 *  @brief 找到当前 TabBarController 使用的 navigation ViewController
 *
 *  @return 返回当前最顶层的 navigationVC
 */
+ (UINavigationController *)currentNavigationController {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *rootViewController = keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootViewController;
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UINavigationController *vc = [self findNavigationControllerInTabBarController:(UITabBarController *)rootViewController];
        if (vc) {
            return vc;
        } else {
            return [[UINavigationController alloc]init];
        }
    }
    return [[UINavigationController alloc] init];
}

// 递归
+ (UINavigationController *)findNavigationControllerInTabBarController:(UITabBarController *)currentTabBarControler {
    if (!currentTabBarControler) {
        NSLog(@"无法跳转");
        return nil;
    }
    
    UITabBarController *tabBarController = (UITabBarController *)currentTabBarControler;
    if (tabBarController.viewControllers.count == 0) {
        return nil;
    }
    // tabbar 中当前显示的视图索引
    NSInteger selectedIndex = tabBarController.selectedIndex;
    // tabbar 中被 selected 的视图
    UIViewController *tabBarSelecedViewController = tabBarController.viewControllers[selectedIndex];
    if ([tabBarSelecedViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)tabBarSelecedViewController;
    } else {
        if([tabBarSelecedViewController isKindOfClass:[UITabBarController class]]) {
            return [self findNavigationControllerInTabBarController:(UITabBarController *)tabBarSelecedViewController];
        } else {
            NSLog(@"无法跳转");
            return nil;
        }
    }
}

@end
