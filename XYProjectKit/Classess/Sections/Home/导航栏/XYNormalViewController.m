//
//  XYNormalViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYNormalViewController.h"

@interface XYNormalViewController ()

@end

@implementation XYNormalViewController

- (void)dealloc {
    
    NSLog(@"%@ :已经销毁了", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"rightitem" style:UIBarButtonItemStylePlain target:self action:@selector(rightitemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    /// 自定义导航栏返回按钮,单个不同的按钮样式可在单独 viewController 中实现下面 rt_customBackItemWithTarget 方法
    self.rt_navigationController.useSystemBackBarButtonItem = NO;
    
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"自定义Back" forState:UIControlStateNormal];
    [button setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)rightitemClick:(UIButton *)sender {
    
    XYNormalViewController *normalViewController = [[XYNormalViewController alloc] init];
    [self.rt_navigationController pushViewController:normalViewController animated:YES];
}

- (IBAction)nextStep:(UIButton *)sender {
    
    UIViewController *itemVC =  VCLOADFROMUISB(@"NavigationBar", @"XYNoSideslipViewController");
    
    [self.rt_navigationController pushViewController:itemVC animated:YES complete:nil];
}

@end
