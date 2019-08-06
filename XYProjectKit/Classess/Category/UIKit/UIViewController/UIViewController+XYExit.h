//
//  UIViewController+XYExit.h
//  XYProjectKit
//
//  Created by xiaoye on 2019/5/6.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XYExit)

/**
 *  @brief 找到当前 TabBarController 使用的 navigation ViewController
 *
 *  @return 返回当前最顶层的 navigationVC
 */

+ (UINavigationController *)currentNavigationController;

@end

NS_ASSUME_NONNULL_END
