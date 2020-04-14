//
//  XYNavigationBarHiddenViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYNavigationBarHiddenViewController.h"

@interface XYNavigationBarHiddenViewController ()

@end

@implementation XYNavigationBarHiddenViewController
- (void)dealloc {
    
    NSLog(@"%@ :已经销毁了", NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    /// 隐藏导航栏,千万记住可不是rt_navigationController
    self.navigationController.navigationBar.hidden = YES;
    
}

- (IBAction)nextStep:(UIButton *)sender {
   
    UIViewController *itemVC = VCLOADFROMUISB(@"NavigationBar", @"XYNoSideslipViewController");
    
    [self.rt_navigationController pushViewController:itemVC animated:YES complete:nil];
}

- (IBAction)onBack:(UIButton *)sender {
    
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}

- (IBAction)pushAndRemoveBtnClick:(UIButton *)sender {
    
    [self.rt_navigationController pushViewController:VCLOADFROMUISB(@"NavigationBar", @"XYNormalViewController") animated:YES complete:^(BOOL finished) {
        [self.rt_navigationController removeViewController:self];
    }];
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
