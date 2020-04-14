//
//  XYNoSideslipViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYNoSideslipViewController.h"

@interface XYNoSideslipViewController ()

@end

@implementation XYNoSideslipViewController
- (void)dealloc {
    
    NSLog(@"%@ :已经销毁了", NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"禁止侧滑";

    self.rt_disableInteractivePop = YES;

}

- (IBAction)popBtnClick:(UIButton *)sender {
    
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
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
