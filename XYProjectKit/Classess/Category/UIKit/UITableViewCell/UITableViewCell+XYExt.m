//
//  UITableViewCell+XYExt.m
//  fula
//
//  Created by cby on 2016/11/1.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import "UITableViewCell+XYExt.h"

static NSString * mainVcKey = @"MainViewController";

@implementation UITableViewCell (XYExt)

- (UIViewController *)mainViewController{
    
    UIViewController *vc = objc_getAssociatedObject(self, &mainVcKey);
    if (vc) {
        return vc;
    }
    UIResponder *nextResponder = self.nextResponder;
    while (![nextResponder isKindOfClass:[UIViewController class]]) {
        
        nextResponder = nextResponder.nextResponder;
    }
    objc_setAssociatedObject(self, &mainVcKey, (UIViewController *)nextResponder, OBJC_ASSOCIATION_RETAIN);
    return (UIViewController *)nextResponder;
}

- (UINavigationController *)navigationController{
    return self.mainViewController.navigationController;
}
@end
