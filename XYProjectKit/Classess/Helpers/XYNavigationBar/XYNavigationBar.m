//
//  XYNavigationBar.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/8/1.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYNavigationBar.h"
#import <objc/runtime.h>
#import "sys/utsname.h"
#import "NSObject+XYSwizzle.h"

@implementation XYNavigationBar

+ (BOOL)isIphoneX {
    return isIPhoneNotchScreen();
}
+ (CGFloat)navBarBottom {
    return kTopHeight;
}
+ (CGFloat)tabBarHeight {
    return kTabBarHeight;
}
+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end


//=============================================================================
#pragma mark - default navigationBar barTintColor、tintColor and statusBarStyle YOU CAN CHANGE!!!
//=============================================================================

@implementation XYNavigationBar (XYDefault)

static char kBlacklistKey;
static char kTabBarWhitelistKey;
static char kDefaultNavBarBarTintColorKey;
static char kDefaultNavBarBackgroundImageKey;
static char kDefaultNavBarTintColorKey;
static char kDefaultNavBarTitleColorKey;
static char kDefaultStatusBarStyleKey;
static char kDefaultNavBarShadowImageHiddenKey;

+ (NSArray <NSString *> *)blacklist {
    NSArray <NSString *> *list = (NSArray <NSString *> *)objc_getAssociatedObject(self, &kBlacklistKey);
    
    return (list != nil) ? list : nil;
}

+ (void)xy_setNavigationControllerBlacklist:(NSArray<NSString *> *)list {
    NSAssert(list, @"list 不能设置为nil");
    objc_setAssociatedObject(self, &kBlacklistKey, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray <NSString *> *)whitelist {

    NSArray <NSString *> *list = (NSArray <NSString *> *)objc_getAssociatedObject(self, &kTabBarWhitelistKey);
    
    return (list != nil) ? list : nil;
}

+ (void)xy_setTabBarControllerWhiteList:(NSArray<NSString *> *)list {
    NSAssert(list, @"tabBarlist 不能设置为nil");
    objc_setAssociatedObject(self, &kTabBarWhitelistKey, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)needUpdateNavigationBar:(UIViewController *)vc {
    NSString *vcStr = NSStringFromClass(vc.class);
    return ![[self blacklist] containsObject:vcStr];// 当黑名单里 没有 表示需要更新
}

/// 设置默认导航栏背景颜色
+ (UIColor *)defaultNavBarBarTintColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarBarTintColorKey);
    return (color != nil) ? color : [UIColor whiteColor];
}

+ (void)xy_setDefaultNavBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kDefaultNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIImage *)defaultNavBarBackgroundImage {
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kDefaultNavBarBackgroundImageKey);
    return image;
}

+ (void)xy_setDefaultNavBarBackgroundImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kDefaultNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 默认导航栏按钮颜色
+ (UIColor *)defaultNavBarTintColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarTintColorKey);
    return (color != nil) ? color : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0];
}

+ (void)xy_setDefaultNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kDefaultNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 默认导航栏标题颜色
+ (UIColor *)defaultNavBarTitleColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarTitleColorKey);
    return (color != nil) ? color : [UIColor blackColor];
}
+ (void)xy_setDefaultNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kDefaultNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIStatusBarStyle)defaultStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kDefaultStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}

+ (void)xy_setDefaultStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kDefaultStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)defaultNavBarShadowImageHidden {
    id hidden = objc_getAssociatedObject(self, &kDefaultNavBarShadowImageHiddenKey);
    return (hidden != nil) ? [hidden boolValue] : NO;
}

+ (void)xy_setDefaultNavBarShadowImageHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kDefaultNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)defaultNavBarBackgroundAlpha {
    return 1.0;
}

+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

+ (CGFloat)middleAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent {
    return fromAlpha + (toAlpha - fromAlpha) * percent;
}

@end


//=============================================================================
#pragma mark - UINavigationBar
//=============================================================================

@implementation UINavigationBar (XYAddition)

static char kBackgroundViewKey;
static char kBackgroundImageViewKey;
static char kBackgroundImageKey;

- (UIView *)backgroundView {
    return (UIView *)objc_getAssociatedObject(self, &kBackgroundViewKey);
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (backgroundView) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xy_keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xy_keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    objc_setAssociatedObject(self, &kBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)backgroundImageView {
    return (UIImageView *)objc_getAssociatedObject(self, &kBackgroundImageViewKey);
}

- (void)setBackgroundImageView:(UIImageView *)bgImageView {
    objc_setAssociatedObject(self, &kBackgroundImageViewKey, bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)backgroundImage {
    return (UIImage *)objc_getAssociatedObject(self, &kBackgroundImageKey);
}

- (void)setBackgroundImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// set navigationBar backgroundImage
- (void)xy_setBackgroundImage:(UIImage *)image {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    if (self.backgroundImageView == nil) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        if (self.subviews.count > 0) {
            CGFloat statusBarHeight  = [[UIApplication sharedApplication] statusBarFrame].size.height;
            CGFloat navBarBottom = statusBarHeight + self.frame.size.height;
            self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), navBarBottom)];
            self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            // _UIBarBackground is first subView for navigationBar
            [self.subviews.firstObject insertSubview:self.backgroundImageView atIndex:0];
        }
    }
    self.backgroundImage = image;
    self.backgroundImageView.image = image;
}

// set navigationBar barTintColor
- (void)xy_setBackgroundColor:(UIColor *)color {
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    self.backgroundImage = nil;
    if (self.backgroundView == nil) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        CGFloat statusBarHeight  = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat navBarBottom = statusBarHeight + self.frame.size.height;
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), navBarBottom)];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // _UIBarBackground is first subView for navigationBar
        [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
    }
    self.backgroundView.backgroundColor = color;
}

- (void)xy_keyboardDidShow {
    [self xy_restoreUIBarBackgroundFrame];
}

- (void)xy_keyboardWillHide {
    [self xy_restoreUIBarBackgroundFrame];
}

- (void)xy_restoreUIBarBackgroundFrame {
    // IQKeyboardManager change _UIBarBackground frame sometimes, so I need restore it
    for (UIView *view in self.subviews) {
        Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
        if (_UIBarBackgroundClass != nil) {
            if ([view isKindOfClass:_UIBarBackgroundClass]) {
                CGFloat statusBarHeight  = [[UIApplication sharedApplication] statusBarFrame].size.height;
                CGFloat navBarBottom = statusBarHeight + self.frame.size.height;
                view.frame = CGRectMake(0, self.frame.size.height-navBarBottom, [XYNavigationBar screenWidth], navBarBottom);
            }
        }
    }
}

// set _UIBarBackground alpha (_UIBarBackground subviews alpha <= _UIBarBackground alpha)
- (void)xy_setBackgroundAlpha:(CGFloat)alpha {
    UIView *barBackgroundView = self.subviews.firstObject;
    if (@available(iOS 11.0, *)) {   // sometimes we can't change _UIBarBackground alpha
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = alpha;
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
}

- (void)xy_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator {
    for (UIView *view in self.subviews) {
        if (hasSystemBackIndicator == YES) {   // _UIBarBackground/_UINavigationBarBackground对应的view是系统导航栏，不需要改变其透明度
            Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
            if (_UIBarBackgroundClass != nil) {
                if ([view isKindOfClass:_UIBarBackgroundClass] == NO) {
                    view.alpha = alpha;
                }
            }
            
            Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
            if (_UINavigationBarBackground != nil) {
                if ([view isKindOfClass:_UINavigationBarBackground] == NO) {
                    view.alpha = alpha;
                }
            }
        } else {
            // 这里如果不做判断的话，会显示 backIndicatorImage
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")] == NO) {
                Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
                if (_UIBarBackgroundClass != nil) {
                    if ([view isKindOfClass:_UIBarBackgroundClass] == NO) {
                        view.alpha = alpha;
                    }
                }
                
                Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
                if (_UINavigationBarBackground != nil) {
                    if ([view isKindOfClass:_UINavigationBarBackground] == NO) {
                        view.alpha = alpha;
                    }
                }
            }
        }
    }
}

/// 设置导航栏在垂直方向上平移多少距离   CGAffineTransformMakeTranslation  平移
- (void)xy_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

/// 获取当前导航栏在垂直方向上偏移了多少
- (CGFloat)xy_getTranslationY {
    return self.transform.ty;
}

#pragma mark - call swizzling methods active 主动调用交换方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[1] = {
            @selector(setTitleTextAttributes:)
        };
        
        for (int i = 0; i < 1;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"xy_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)xy_setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    NSMutableDictionary<NSString *,id> *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    if (newTitleTextAttributes == nil) {
        return;
    }
    
    NSDictionary<NSString *,id> *originTitleTextAttributes = self.titleTextAttributes;
    if (originTitleTextAttributes == nil) {
        [self xy_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
    
    __block UIColor *titleColor;
    [originTitleTextAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqual:NSForegroundColorAttributeName]) {
            titleColor = (UIColor *)obj;
            *stop = YES;
        }
    }];
    
    if (titleColor == nil) {
        [self xy_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
    if (newTitleTextAttributes[NSForegroundColorAttributeName] == nil) {
        newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    }
    [self xy_setTitleTextAttributes:newTitleTextAttributes];
}
@end

//==========================================================================
#pragma mark - UINavigationController
//==========================================================================
@implementation UINavigationController (XYAddition)

- (void)setNeedsNavigationBarUpdateForBarBackgroundImage:(UIImage *)backgroundImage {
    [self.navigationBar xy_setBackgroundImage:backgroundImage];
}

- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)barTintColor {
    [self.navigationBar xy_setBackgroundColor:barTintColor];
}

- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)barBackgroundAlpha {
    [self.navigationBar xy_setBackgroundAlpha:barBackgroundAlpha];
}

- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)tintColor {
    self.navigationBar.tintColor = tintColor;
}

- (void)setNeedsNavigationBarUpdateForShadowImageHidden:(BOOL)hidden {
    self.navigationBar.shadowImage = (hidden == YES) ? [UIImage new] : nil;
}

- (void)setNeedsNavigationBarUpdateForTitleColor:(UIColor *)titleColor {
    NSDictionary *titleTextAttributes = [self.navigationBar titleTextAttributes];
    if (titleTextAttributes == nil) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
        return;
    }
    NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    self.navigationBar.titleTextAttributes = newTitleTextAttributes;
}

@end

//==========================================================================
#pragma mark - UIViewController
//==========================================================================
@interface UIViewController (Addition)

- (void)setPushToCurrentVCFinished:(BOOL)isFinished;

@end

@implementation UIViewController (XYAddition)

static char kPushToCurrentVCFinishedKey;
static char kPushToNextVCFinishedKey;
static char kNavBarBackgroundImageKey;
static char kNavBarBarTintColorKey;
static char kNavBarBackgroundAlphaKey;
static char kNavBarTintColorKey;
static char kNavBarTitleColorKey;
static char kStatusBarStyleKey;
static char kNavBarShadowImageHiddenKey;
static char kSystemNavBarBarTintColorKey;
static char kSystemNavBarTintColorKey;
static char kSystemNavBarTitleColorKey;

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIStatusBarStyle barStyle = [self xy_statusBarStyle];
    return barStyle;
}

// navigationBar barTintColor can not change by currentVC before fromVC push to currentVC finished
- (BOOL)pushToCurrentVCFinished {
    id isFinished = objc_getAssociatedObject(self, &kPushToCurrentVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}

- (void)setPushToCurrentVCFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kPushToCurrentVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// navigationBar barTintColor can not change by currentVC when currentVC push to nextVC finished
- (BOOL)pushToNextVCFinished {
    id isFinished = objc_getAssociatedObject(self, &kPushToNextVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}

- (void)setPushToNextVCFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kPushToNextVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// navigationBar backgroundImage
- (UIImage *)xy_navBarBackgroundImage {
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kNavBarBackgroundImageKey);
    image = (image == nil) ? [XYNavigationBar defaultNavBarBackgroundImage] : image;
    return image;
}

- (void)xy_setNavBarBackgroundImage:(UIImage *)image {
  
    objc_setAssociatedObject(self, &kNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    BOOL isRootViewController = (self.navigationController.topViewController == self);
    if (([self pushToCurrentVCFinished] == YES || isRootViewController == YES) && [self pushToNextVCFinished] == NO) {
        [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:image];
    }
}

// navigationBar systemBarTintColor
- (UIColor *)xy_systemNavBarBarTintColor {
    return (UIColor *)objc_getAssociatedObject(self, &kSystemNavBarBarTintColorKey);
}

- (void)xy_setSystemNavBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSystemNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// navigationBar barTintColor
- (UIColor *)xy_navBarBarTintColor {
    UIColor *barTintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarBarTintColorKey);
    if (![XYNavigationBar needUpdateNavigationBar:self]) {
        if ([self xy_systemNavBarBarTintColor] == nil) {
            barTintColor = self.navigationController.navigationBar.barTintColor;
        } else {
            barTintColor = [self xy_systemNavBarBarTintColor];
        }
    }
    return (barTintColor != nil) ? barTintColor : [XYNavigationBar defaultNavBarBarTintColor];
}

- (void)xy_setNavBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    BOOL isRootViewController = (self.navigationController.topViewController == self);
    if (([self pushToCurrentVCFinished] == YES || isRootViewController == YES) && [self pushToNextVCFinished] == NO) {
        [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:color];
    }
}

// navigationBar _UIBarBackground alpha
- (CGFloat)xy_navBarBackgroundAlpha {
    id barBackgroundAlpha = objc_getAssociatedObject(self, &kNavBarBackgroundAlphaKey);
    return (barBackgroundAlpha != nil) ? [barBackgroundAlpha floatValue] : [XYNavigationBar defaultNavBarBackgroundAlpha];
}

- (void)xy_setNavBarBackgroundAlpha:(CGFloat)alpha {
    objc_setAssociatedObject(self, &kNavBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 
    BOOL isRootViewController = (self.navigationController.topViewController == self);
    
    if (([self pushToCurrentVCFinished] == YES || isRootViewController == YES) && [self pushToNextVCFinished] == NO) {
        [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha];
    }
}

// navigationBar systemTintColor
- (UIColor *)xy_systemNavBarTintColor {
    return (UIColor *)objc_getAssociatedObject(self, &kSystemNavBarTintColorKey);
}

- (void)xy_setSystemNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSystemNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// navigationBar tintColor
- (UIColor *)xy_navBarTintColor {
    UIColor *tintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarTintColorKey);
    if (![XYNavigationBar needUpdateNavigationBar:self]) {
        if ([self xy_systemNavBarTintColor] == nil) {
            tintColor = self.navigationController.navigationBar.tintColor;
        } else {
            tintColor = [self xy_systemNavBarTintColor];
        }
    }
    return (tintColor != nil) ? tintColor : [XYNavigationBar defaultNavBarTintColor];
}

- (void)xy_setNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self pushToNextVCFinished] == NO) {
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:color];
    }
}

// navigationBar systemTitleColor
- (UIColor *)xy_systemNavBarTitleColor {
    return (UIColor *)objc_getAssociatedObject(self, &kSystemNavBarTitleColorKey);
}

- (void)xy_setSystemNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kSystemNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// navigationBarTitleColor
- (UIColor *)xy_navBarTitleColor {
    UIColor *titleColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarTitleColorKey);
    if (![XYNavigationBar needUpdateNavigationBar:self]) {
        if ([self xy_systemNavBarTitleColor] == nil) {
            titleColor = self.navigationController.navigationBar.titleTextAttributes[@"NSColor"];
        } else {
            titleColor = [self xy_systemNavBarTitleColor];
        }
    }
    return (titleColor != nil) ? titleColor : [XYNavigationBar defaultNavBarTitleColor];
}

- (void)xy_setNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self pushToNextVCFinished] == NO) {
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:color];
    }
}

// statusBarStyle
- (UIStatusBarStyle)xy_statusBarStyle {
    NSNumber *style = (NSNumber *)objc_getAssociatedObject(self, &kStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : [XYNavigationBar defaultStatusBarStyle];
}

- (void)xy_setStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

// shadowImage
- (void)xy_setNavBarShadowImageHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:hidden];
}

- (BOOL)xy_navBarShadowImageHidden {
    id hidden = objc_getAssociatedObject(self, &kNavBarShadowImageHiddenKey);
    return (hidden != nil) ? [hidden boolValue] : [XYNavigationBar defaultNavBarShadowImageHidden];
}

/**
 方法交换
 可配置黑名单过滤控制器,此处配置全局导航栏状态,或者埋点等等....
 */
+ (void)load {
    /// 保证其只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [UIViewController swizzleOriSelector:@selector(viewDidLoad) withNewSelector:@selector(xy_viewDidLoad)];
        [UIViewController swizzleOriSelector:@selector(viewWillAppear:) withNewSelector:@selector(xy_viewWillAppear:)];
        [UIViewController swizzleOriSelector:@selector(viewDidAppear:) withNewSelector:@selector(xy_viewDidAppear:)];
        [UIViewController swizzleOriSelector:@selector(viewWillDisappear:) withNewSelector:@selector(xy_viewWillDisappear:)];
        [UIViewController swizzleOriSelector:@selector(viewDidDisappear:) withNewSelector:@selector(xy_viewDidDisappear:)];
    });
}

- (void)xy_viewDidLoad {
    
    [self xy_viewDidLoad];
}

- (void)xy_viewWillAppear:(BOOL)animated {
    
    if ([self canUpdateNavigationBar]) {
        NSLog(@"黑名单中有执行: %@",NSStringFromClass([self class]));

        if (![XYNavigationBar needUpdateNavigationBar:self]) {
            if ([self xy_systemNavBarBarTintColor] == nil) {
                [self xy_setSystemNavBarBarTintColor:[self xy_navBarBarTintColor]];
            }
            if ([self xy_systemNavBarTintColor] == nil) {
                [self xy_setSystemNavBarTintColor:[self xy_navBarTintColor]];
            }
            if ([self xy_systemNavBarTitleColor] == nil) {
                [self xy_setSystemNavBarTitleColor:[self xy_navBarTitleColor]];
            }
            
            /// 设置了黑名单会忽略 导航栏背景图片的设置,使用颜色代替背景图片
            /// 黑名单中设置的导航颜色先查找 xy_setSystemNavBarBarTintColor --> defaultNavBarBarTintColor 如果都没有设置是 [UIColor whiteColor] 如果黑名单中不设置默认导航颜色,隐藏导航的下划线则失效,想改变当前 VC 的颜色可以在 xy_setSystemNavBarBarTintColor 设置
            [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:[self xy_navBarBarTintColor]];
            
        } else {
            /// 设置导航栏背景颜色
            UIImage *barBgImage = [self xy_navBarBackgroundImage];
            if (barBgImage != nil) {
                [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:barBgImage];
            } else {
                [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:[self xy_navBarBarTintColor]];
            }
        }

        [self setPushToNextVCFinished:NO];

        /// 设置导航透明度
        [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:[self xy_navBarBackgroundAlpha]];
        /// 设置导航栏按钮颜色
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self xy_navBarTintColor]];
        /// 设置导航栏标题颜色
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self xy_navBarTitleColor]];
        /// 隐藏导航栏下面的线
        [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:[self xy_navBarShadowImageHidden]];
        
    }

    [self xy_viewWillAppear:animated];
}

- (void)xy_viewDidAppear:(BOOL)animated {
    if ([self isRootViewController] == NO) {
        self.pushToCurrentVCFinished = YES;
    }
    [self xy_viewDidAppear:animated];
}

- (void)xy_viewWillDisappear:(BOOL)animated {
    if ([self canUpdateNavigationBar] == YES) {
        [self setPushToNextVCFinished:YES];
    }
    [self xy_viewWillDisappear:animated];
}

- (void)xy_viewDidDisappear:(BOOL)animated {
    if (![XYNavigationBar needUpdateNavigationBar:self] && !self.navigationController) {
        [self xy_setSystemNavBarBarTintColor:nil];
        [self xy_setSystemNavBarTintColor:nil];
        [self xy_setSystemNavBarTitleColor:nil];
    }
    [self xy_viewDidDisappear:animated];
}

/// 设置全局返回按钮,可单独在 VC 重写此方法设置
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon-nav-back_15x16_.png"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/// 当前控制器是否存在导航栈中(防止一些系统类控制器或奇奇怪怪的控制器)
- (BOOL)canUpdateNavigationBar {
    /// 注意,这里的导航使用的是 rt_navigationController.viewControllers 中不包含tanBar包装的根视图控制器
  
    return [self.rt_navigationController.rt_viewControllers containsObject:self] ? [self.rt_navigationController.rt_viewControllers containsObject:self] : [[XYNavigationBar whitelist] containsObject:NSStringFromClass([self class])];
}

- (BOOL)isRootViewController {
    UIViewController *rootViewController = self.rt_navigationController.rt_viewControllers.firstObject;
    if ([rootViewController isKindOfClass:[UITabBarController class]] == NO) {
        return rootViewController == self;
    } else {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [tabBarController.viewControllers containsObject:self];
    }
}

@end
