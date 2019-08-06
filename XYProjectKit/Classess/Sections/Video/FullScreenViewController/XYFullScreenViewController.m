//
//  XYFullScreenViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/9.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYFullScreenViewController.h"
#import "XYDebugTableViewController.h"

@interface XYFullScreenViewController ()

@end

@implementation XYFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alertButton.frame = CGRectMake(150, 200, 100, 44);
    [alertButton setTitle:@"菊花" forState:UIControlStateNormal];
    [alertButton setBackgroundColor:[UIColor blueColor]];
    [alertButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alertButton addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:alertButton];
    
}

- (void)alertButtonClick:(UIButton *)sender {
    
    XYDebugTableViewController *vc = VCLOADFROMUISB(@"Debug", @"XYDebugTableViewController");
    
    [self.rt_navigationController pushViewController:vc animated:YES];
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
