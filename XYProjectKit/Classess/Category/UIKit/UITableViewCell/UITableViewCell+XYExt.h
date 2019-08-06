//
//  UITableViewCell+XYExt.h
//  fula
//
//  Created by cby on 2016/11/1.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (XYExt)
    
/**
 返回持有该 cell 的 viewcontroller

 @return 该 cell 的 viewcontroller
 */
- (UIViewController *)mainViewController;

/**
 
 @return 该 cell 的 navigationController
 */
- (UINavigationController *)navigationController;
@end
