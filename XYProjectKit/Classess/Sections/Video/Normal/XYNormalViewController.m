//
//  XYNormalViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/6/14.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYNormalViewController.h"

@interface XYNormalViewController ()

@end

@implementation XYNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kRandColor;
    
    [self xy_setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)nextStepClick:(UIButton *)sender {
    
    XYNormalViewController *normalViewController = [[XYNormalViewController alloc] init];
    [self.rt_navigationController pushViewController:normalViewController animated:YES];
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
