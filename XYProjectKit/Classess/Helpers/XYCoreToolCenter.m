//
//  XYCoreToolCenter.m
//  fula
//
//  Created by xiyedev on 2017/11/1.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYCoreToolCenter.h"
#import "SVProgressHUD.h"

@implementation XYCoreToolCenter

+ (void)load {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //菊花模式
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}

void ShowSuccessStatus(NSString *statues){
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:statues];
        });
    }else{
        [SVProgressHUD showSuccessWithStatus:statues];
    }
}

void ShowMessage(NSString *statues){
    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:statues];
        });
    }else{
        [SVProgressHUD showInfoWithStatus:statues];
    }
}

void ShowErrorStatus(NSString *statues){
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:statues];
        });
    }else{
        [SVProgressHUD showErrorWithStatus:statues];
    }
}


void ShowMaskStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:statues];

        });
    }else{
        [SVProgressHUD showWithStatus:statues];
    }
}

void ShowProgress(CGFloat progress){
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress];
        });
    }else{
        [SVProgressHUD showProgress:progress];
    }
}

void DismissHud(void) {
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
        });
    }else {
        [SVProgressHUD dismiss];
    }
}

@end
