//
//  XYDynamicViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/5/15.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYDynamicViewController.h"
#import "XYHomeViewController.h"

@interface XYDynamicViewController ()

@end

@implementation XYDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
 
    UIButton *persent = [UIButton buttonWithType:UIButtonTypeCustom];
    persent.frame = CGRectMake(100, 100, 80, 40);
    [persent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [persent setTitle:@"模态视图" forState:UIControlStateNormal];
    [persent addTarget:self action:@selector(persentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:persent];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(100, 180, 200, 50);
    textField.backgroundColor = [UIColor purpleColor];
    textField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:textField];
}

- (void)persentClick:(UIButton *)sender {

    XYHomeViewController *homeVC = [[XYHomeViewController alloc] init];
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:homeVC];
    
    [self presentViewController:nav animated:YES completion:nil];
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
