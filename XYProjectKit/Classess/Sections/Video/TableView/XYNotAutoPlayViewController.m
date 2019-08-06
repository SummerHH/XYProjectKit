//
//  XYNotAutoPlayViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/6/14.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYNotAutoPlayViewController.h"

@interface XYNotAutoPlayViewController ()

@end

@implementation XYNotAutoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kRandColor;
    
    UIBarButtonItem *rightBarItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"icon-nav-close_15x15_"] highImage:nil target:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"bblink_ic_nav_back_22x22_"] highImage:nil target:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[leftBarItem,rightBarItem];
    /// 设置了自定义按钮侧滑返回会强制失效,可以使用rt_disableInteractivePop 强制开启
    self.rt_disableInteractivePop = NO;
}

- (void)closeButtonClick {
    NSLog(@"点击了关闭按钮");
}

- (void)backButtonClick {
    NSLog(@"点击了返回按钮");
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
