//
//  MBProgressHUD+XYExt.m
//  fula
//
//  Created by xiaoye on 2018/2/28.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "MBProgressHUD+XYExt.h"

// 默认消失的时间
static const CGFloat hideTime = 2.0f;

@implementation MBProgressHUD (XYExt)

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow {

    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[[AppDelegate shareAppDelegate] getCurrentUIVC].view;
    
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        [hud showAnimated:YES];
    }
    hud.animationType = MBProgressHUDAnimationZoom;
//    hud.minSize = CGSizeMake(90, 90);
    hud.label.text=message;
    hud.label.font=[UIFont systemFontOfSize:15.0f];
    hud.label.textColor= [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8f];
    hud.bezelView.layer.cornerRadius = 6.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud setContentColor:[UIColor whiteColor]];
    return hud;
}
#pragma mark-------------------- show Tip----------------------------

+ (void)showTipMessageInWindow:(NSString*)message {
    [self showTipMessage:message isWindow:true timer:hideTime];
}

+ (void)showTipMessageInView:(NSString*)message {
    [self showTipMessage:message isWindow:false timer:hideTime];
}

+ (void)showTipMessageInWindow:(NSString*)message timer:(float)aTimer {
    [self showTipMessage:message isWindow:true timer:aTimer];
}

+ (void)showTipMessageInView:(NSString*)message timer:(float)aTimer {
    [self showTipMessage:message isWindow:false timer:aTimer];
}

+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {

    if (strIsNullOrNoContent(message)) {
        return;
    }
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:hideTime];
        });
    }
    else {
        MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:hideTime];
    }
}
#pragma mark-------------------- show Activity----------------------------

+ (void)showActivityMessageInWindow:(NSString*)message {
    [self showActivityMessage:message isWindow:true timer:0];
}

+ (void)showActivityMessageInView:(NSString*)message {
    [self showActivityMessage:message isWindow:false timer:0];
}

+ (void)showActivityMessageInWindow:(NSString*)message timer:(float)aTimer {
    [self showActivityMessage:message isWindow:true timer:aTimer];
}

+ (void)showActivityMessageInView:(NSString*)message timer:(float)aTimer {
    [self showActivityMessage:message isWindow:false timer:aTimer];
}

+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
            hud.mode = MBProgressHUDModeIndeterminate;
            if (aTimer>0) {
                [hud hideAnimated:YES afterDelay:aTimer];
            }
        });
    }
    else {
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        hud.mode = MBProgressHUDModeIndeterminate;
        if (aTimer>0) {
            [hud hideAnimated:YES afterDelay:aTimer];
        }
    }
}

+ (void)showLoadingMessageInWindow:(NSString *)message {
    
    [self showLoadingMessage:message isWindow:true];
}

+ (void)showLoadingMessageInView:(NSString *)message {
    
    [self showLoadingMessage:message isWindow:false];
}

+ (void)showLoadingMessage:(NSString *)message isWindow:(BOOL)isWindow {
    
    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"MBHUD" ofType:@"bundle"];
    NSString *iconName = [[NSBundle bundleWithPath:strResourcesBundle] pathForResource:@"circle_loading" ofType:@"png"];
    UIImage *circleLoadingImage = [UIImage imageWithContentsOfFile:iconName];
    
    [self showLoadingCircleMessage:message imageView:[self getCircleLoadingImageView:[circleLoadingImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]] isWindow:isWindow timer:0];
}

+ (void)showLoadingMessage:(NSString *)message {

    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"MBHUD" ofType:@"bundle"];
    NSString *iconName = [[NSBundle bundleWithPath:strResourcesBundle] pathForResource:@"chase_r_loading" ofType:@"png"];
    UIImage *chaseRLoadingImage = [UIImage imageWithContentsOfFile:iconName];
    
    [self showLoadingCircleMessage:message imageView:[self getCircleLoadingImageView:[chaseRLoadingImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]] isWindow:true timer:0];
}

+ (void)showLoadingCircleMessage:(NSString *)message imageView:(UIImageView *)imageView isWindow:(BOOL)isWindow timer:(int)aTimer {


    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = imageView;
            if (aTimer>0) {
                [hud hideAnimated:YES afterDelay:aTimer];
            }
        });
    }
    else {
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = imageView;
        if (aTimer>0) {
            [hud hideAnimated:YES afterDelay:aTimer];
        }
    }
}

+ (MBProgressHUD *)defaultMBProgress:(UIView *)view {
    MBProgressHUD *HUD = [self createMBProgressHUDviewWithMessage:nil isWindiw:false];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.bezelView.color = [UIColor blackColor];//默认黑色
//    HUD.contentColor = [UIColor clearColor];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
     [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];//菊花颜色
#pragma clang diagnostic pop
    [HUD hideAnimated:YES afterDelay:3.0f];
    return HUD;
}



#pragma mark-------------------- show Image----------------------------

+ (void)showMessage:(NSString *)message {

    if (strIsNullOrNoContent(message)) {
        return;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:true];
            [hud setMinSize:CGSizeZero];
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:hideTime];
        });
    }
    else {
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:true];
        [hud setMinSize:CGSizeZero];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:hideTime];
    }
}

+ (void)showSuccessMessage:(NSString *)message {
    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"MBHUD" ofType:@"bundle"];
    NSString *iconName = [[NSBundle bundleWithPath:strResourcesBundle] pathForResource:@"success" ofType:@"png"];
    UIImage *successImage = [UIImage imageWithContentsOfFile:iconName];
    
    [self showCustomIcon:[successImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] message:message isWindow:true];
}

+ (void)showErrorMessage:(NSString *)message {
    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"MBHUD" ofType:@"bundle"];
    NSString *iconName = [[NSBundle bundleWithPath:strResourcesBundle] pathForResource:@"error" ofType:@"png"];
    UIImage *errorImage = [UIImage imageWithContentsOfFile:iconName];
    
    [self showCustomIcon:[errorImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] message:message isWindow:true];
}

+ (void)showWarnMessage:(NSString *)message {
    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"MBHUD" ofType:@"bundle"];
    NSString *iconName = [[NSBundle bundleWithPath:strResourcesBundle] pathForResource:@"warning" ofType:@"png"];
    UIImage *warningImage = [UIImage imageWithContentsOfFile:iconName];
    
    [self showCustomIcon:[warningImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] message:message isWindow:true];
}

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message {
    [self showCustomIcon:[UIImage imageNamed:iconName] message:message isWindow:true];
}

+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message {
    [self showCustomIcon:[UIImage imageNamed:iconName] message:message isWindow:false];
}

+ (void)showCustomIcon:(UIImage *)iconImgae message:(NSString *)message isWindow:(BOOL)isWindow {
    
    if (strIsNullOrNoContent(message)) {
        return;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
            hud.customView = [[UIImageView alloc] initWithImage:iconImgae];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hideAnimated:YES afterDelay:hideTime];
        });
    }
    else {
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        hud.customView = [[UIImageView alloc] initWithImage:iconImgae];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hideAnimated:YES afterDelay:hideTime];
    }
}

+ (MBProgressHUD *)showAnnularProgressInView:(UIView *)view Message:(NSString *)message {
    
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:true];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.mode = MBProgressHUDModeDeterminate;
    return hud;
}

+ (void)hideHUD {
    
    // 此处应稍微延迟消失,让 UIkit有足够的时间去更新 UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
        [self hideHUDForView:winView animated:YES];
        [self hideHUDForView:[[AppDelegate shareAppDelegate] getCurrentUIVC].view animated:YES];
        
    });
}

+ (UIImageView *)getCircleLoadingImageView:(UIImage *)img {
    UIImageView *imgView = [[UIImageView alloc] initWithImage: img];
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.18;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    [imgView.layer addAnimation:animation forKey:@"rotate360"];
    return imgView;
}

@end
