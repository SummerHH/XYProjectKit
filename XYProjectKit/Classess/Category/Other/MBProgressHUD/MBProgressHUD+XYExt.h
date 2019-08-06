//
//  MBProgressHUD+XYExt.h
//  fula
//
//  Created by xiaoye on 2018/2/28.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (XYExt)

+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(float)aTimer;
+ (void)showTipMessageInView:(NSString*)message timer:(float)aTimer;

/** 菊花 loading */
+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInView:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message timer:(float)aTimer;
+ (void)showActivityMessageInView:(NSString*)message timer:(float)aTimer;

/** loading */
+ (void)showLoadingMessageInWindow:(NSString *)message;
+ (void)showLoadingMessageInView:(NSString *)message;
//+ (void)showLoadingMessage:(NSString *)message;

/** 在 window 上添加一个提示`默认`的 HUD, 需要手动关闭 */
+ (MBProgressHUD *)defaultMBProgress:(UIView *)view;

/** 显示纯文本信息 */
+ (void)showMessage:(NSString *)message;
+ (void)showSuccessMessage:(NSString *)message;
+ (void)showErrorMessage:(NSString *)message;
+ (void)showWarnMessage:(NSString *)message;

/** 自定义提示信息 */
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;

/** 圆形进度条+文字 */
+ (MBProgressHUD *)showAnnularProgressInView:(UIView *)view Message:(NSString *)message;

+ (void)hideHUD;

@end
