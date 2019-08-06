//
//  XYBaseViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/9.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYBaseViewController ()

@end

@implementation XYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    /// 自定义导航栏返回按钮,单个不同的按钮样式可在单独 viewController 中实现下面 rt_customBackItemWithTarget 方法
    self.rt_navigationController.useSystemBackBarButtonItem = NO;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
