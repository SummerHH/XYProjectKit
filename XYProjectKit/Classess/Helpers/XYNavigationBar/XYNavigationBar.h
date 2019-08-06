//
//  XYNavigationBar.h
//  XYProjectKit
//
//  Created by xiaoye on 2019/8/1.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYNavigationBar : UIView

+ (BOOL)isIphoneX;
+ (CGFloat)navBarBottom;
+ (CGFloat)tabBarHeight;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

@end

@interface XYNavigationBar (XYDefault)

/// 设置需要屏蔽的控制器
/** warning: xy_setNavigationControllerBlacklist 在每个VC 都是单个独立的导航控制器中使用意义不大*/
+ (void)xy_setNavigationControllerBlacklist:(NSArray<NSString *> *)list;
/// 如果使用RTRootNavigationController包装 tabBarController 需要设置包装的tabBar包装的视图
+ (void)xy_setTabBarControllerWhiteList:(NSArray<NSString *> *)list;
/** set default barTintColor of UINavigationBar */
+ (void)xy_setDefaultNavBarBarTintColor:(UIColor *)color;

/** set default barBackgroundImage of UINavigationBar */
+ (void)xy_setDefaultNavBarBackgroundImage:(UIImage *)image;

/** set default tintColor of UINavigationBar */
+ (void)xy_setDefaultNavBarTintColor:(UIColor *)color;

/** set default titleColor of UINavigationBar */
+ (void)xy_setDefaultNavBarTitleColor:(UIColor *)color;

/** set default statusBarStyle of UIStatusBar */
+ (void)xy_setDefaultStatusBarStyle:(UIStatusBarStyle)style;

/** set default shadowImage isHidden of UINavigationBar */
+ (void)xy_setDefaultNavBarShadowImageHidden:(BOOL)hidden;

@end

//=============================================================================
#pragma mark - UINavigationBar
//=============================================================================

@interface UINavigationBar (XYAddition) <UINavigationBarDelegate>

/** 设置导航栏所有BarButtonItem的透明度 */
- (void)xy_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator;

/** 设置导航栏在垂直方向上平移多少距离 */
- (void)xy_setTranslationY:(CGFloat)translationY;

/** 获取当前导航栏在垂直方向上偏移了多少 */
- (CGFloat)xy_getTranslationY;

@end

//==========================================================================
#pragma mark - UIViewController
//==========================================================================
@interface UIViewController (XYAddition)

/** record current ViewController navigationBar backgroundImage */
- (void)xy_setNavBarBackgroundImage:(UIImage *)image;
- (UIImage *)xy_navBarBackgroundImage;

/** record current ViewController navigationBar barTintColor */
- (void)xy_setNavBarBarTintColor:(UIColor *)color;
- (UIColor *)xy_navBarBarTintColor;

/** record current ViewController navigationBar backgroundAlpha */
- (void)xy_setNavBarBackgroundAlpha:(CGFloat)alpha;
- (CGFloat)xy_navBarBackgroundAlpha;

/** record current ViewController navigationBar tintColor */
- (void)xy_setNavBarTintColor:(UIColor *)color;
- (UIColor *)xy_navBarTintColor;

/** record current ViewController titleColor */
- (void)xy_setNavBarTitleColor:(UIColor *)color;
- (UIColor *)xy_navBarTitleColor;

/** record current ViewController statusBarStyle */
- (void)xy_setStatusBarStyle:(UIStatusBarStyle)style;
- (UIStatusBarStyle)xy_statusBarStyle;

/** record current ViewController navigationBar shadowImage hidden */
- (void)xy_setNavBarShadowImageHidden:(BOOL)hidden;
- (BOOL)xy_navBarShadowImageHidden;


@end

NS_ASSUME_NONNULL_END
