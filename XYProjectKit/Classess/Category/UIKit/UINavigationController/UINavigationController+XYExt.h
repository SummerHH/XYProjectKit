//
//  UINavigationController+XYExt.h
//  fula
//
//  Created by cby on 2017/5/15.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (XYExt)

- (UIViewController *)popToViewControllerAtIndex:(NSInteger)index
                                        animated:(BOOL)animated;

@end
