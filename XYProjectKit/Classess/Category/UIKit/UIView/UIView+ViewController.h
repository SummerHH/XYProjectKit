//
//  UIView+ViewController.h
//  ycweibo项目二
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewController)

/**
 *  获取当前控制器
 */
- (UIViewController *)viewController;

/**
 *  获取当前navigationController
 */
- (UINavigationController *)navigationController;

/**
 *  获取当前tabBarController
 */
- (UITabBarController *)tabBarController;



@end

NS_ASSUME_NONNULL_END
