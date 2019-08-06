//
//  UIView+ViewController.m
//  ycweibo项目二
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)


- (UIViewController *)viewController {
    //事件下一个响应者
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者类型是否为视图控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    while (next != nil);
    return nil;
}

- (UINavigationController *)navigationController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}

- (UITabBarController *)tabBarController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}


@end
