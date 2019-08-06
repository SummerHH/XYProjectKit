//
//  UINavigationController+XYExt.m
//  fula
//
//  Created by cby on 2017/5/15.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "UINavigationController+XYExt.h"

@implementation UINavigationController (XYExt)

- (UIViewController *)popToViewControllerAtIndex:(NSInteger)index
                                        animated:(BOOL)animated {
    
    NSArray *viewControllers = self.viewControllers;
    if(index < viewControllers.count) {
        UIViewController *viewController = viewControllers[index];
        [self popToViewController:viewController animated:YES];
        return viewController;
    }
    return nil;
}

@end
