//
//  XYDebugTableViewController.m
//  ProjectUkitSet
//
//  Created by xiaoye on 2018/7/5.
//  Copyright © 2018年 xiaoye. All rights reserved.
//

#import "XYDebugTableViewController.h"
#import "XLPaymentLoadingHUD.h"

@interface XYDebugTableViewController ()

@end

@implementation XYDebugTableViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self xy_setNavBarShadowImageHidden:YES];

//    [self xy_setNavBarBarTintColor:[UIColor purpleColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            [MBProgressHUD showSuccessMessage:@"加载成功...."];
        }
            break;
        case 1: {
            [MBProgressHUD showErrorMessage:@"加载错误...."];
        }
            break;
        case 2: {
            [MBProgressHUD showWarnMessage:@"这是一个警告"];
        }
            break;
        case 3: {
            [MBProgressHUD showMessage:@"今天吃什么啊,你推荐个吧"];
        }
            break;
        case 4: {
            
            [MBProgressHUD showActivityMessageInWindow:@"显示菊花3秒"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
            break;
        case 5: {
            [MBProgressHUD showActivityMessageInWindow:@"这是在window" timer:2.0f];
        }
            break;
        case 6: {
            [MBProgressHUD showTipMessageInWindow:@"我在上面哈哈哈哈"];
        }
            break;
        case 7: {
          
            [MBProgressHUD showLoadingMessageInWindow:@"loading..."];
        }
            break;
        case 8: {
         
            [XLPaymentLoadingHUD showIn:self.view];
            
        }
            break;
        case 9: {
         
            
        }
            break;
        case 10: {
         
            
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
