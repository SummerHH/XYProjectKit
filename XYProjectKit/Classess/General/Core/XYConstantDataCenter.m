//
//  XYConstantDataCenter.m
//  fula
//
//  Created by xiaoye on 2018/2/26.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "XYConstantDataCenter.h"

@implementation XYConstantDataCenter

static XYConstantDataCenter *instance;

- (void)dealloc {
    
}

+ (instancetype)sharedConstantData {
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYConstantDataCenter alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self xy_setKeyBord];
        
        [self networkReachableStatus];
    }
    return self;
}

#pragma mark - 键盘回收相关
- (void)xy_setKeyBord {
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.toolbarTintColor = [UIColor blackColor];
    // 控制是否显示键盘上的工具条
    manager.enableAutoToolbar = YES;
    //// 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    manager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    manager.shouldShowToolbarPlaceholder = YES;
    manager.placeholderFont = SYSTEMFONT(16.0f);
}

#pragma mark － 检测网络相关
- (void)networkReachableStatus {
    
    [XYNetworkingHelper networkStatusWithBlock:^(XYNetworkingStatusType status) {
        
        self.netWorkingStatus = status;

        if (status == XYNetworkingStatusNotReachable) {
            [MBProgressHUD showMessage:@"网络竟然崩溃了"];
            NSLog(@"无网络");
        } else if (status == XYNetworkingStatusUnKnown) {
            NSLog(@"未知网络");
        } else if (status == XYNetworkingStatusReachableViaWWAN) {
            NSLog(@"手机网络");
        } else if (status == XYNetworkingStatusReachableViaWiFi) {
            NSLog(@"WIfI网络");
        }
    }];
}

@end
