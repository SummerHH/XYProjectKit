//
//  XYPushRemoveViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYPushRemoveViewController.h"

@interface XYPushRemoveViewController ()

@property (nonatomic, assign) BOOL isOn;
@end

@implementation XYPushRemoveViewController
- (void)dealloc {
    
    NSLog(@"%@ :已经销毁了", NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isOn = YES;

}

- (IBAction)pushAndRemove:(UIButton *)sender {
   
    [self.rt_navigationController pushViewController:VCLOADFROMUISB(@"NavigationBar", @"XYNormalViewController") animated:self.isOn complete:^(BOOL finished) {
        [self.rt_navigationController removeViewController:self];
    }];

}

- (IBAction)onSwitch:(UISwitch *)sender {
    
    self.isOn = sender.on;
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
