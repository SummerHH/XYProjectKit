//
//  XYBaseTabBarViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/5/15.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYBaseTabBarViewController.h"
#import "XYHomeViewController.h"
#import "XYChannelViewController.h"
#import "XYPersonalViewController.h"
#import "XYDynamicViewController.h"
#import "XYShopViewController.h"

@interface XYBaseTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation XYBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildViewControllers];
    // 设置 tabBar 的代理
    self.delegate = self;
    
    [self initializeTabBarStatus];
    
}

- (void)addChildViewControllers {
    
    NSDictionary *firstTabBarItemsAttributes = @{
        @"tabBarItemTitle" : @"首页",
        @"tabBarViewController" : @"XYHomeViewController",
        @"tabBarItemImage" : @"bottom_tabbar_mainhome_normal.png",
        @"tabBarItemSelectedImage" : @"bottom_tabbar_mainhome_selected.png"
    };
    
    NSDictionary *twoTabBarItemsAttributes = @{
        @"tabBarItemTitle" : @"频道",
        @"tabBarViewController" : @"XYChannelViewController",
        @"tabBarItemImage" : @"bottom_tabbar_pegasuschannel_normal.png",
        @"tabBarItemSelectedImage" : @"bottom_tabbar_pegasuschannel_selected.png"
    };
    
    NSDictionary *threeTabBarItemsAttributes = @{
        @"tabBarItemTitle" : @"动态",
        @"tabBarViewController" : @"XYDynamicViewController",
        @"tabBarItemImage" : @"bottom_tabbar_followinghome_normal.png",
        @"tabBarItemSelectedImage" : @"bottom_tabbar_followinghome_selected.png"
    };
    
    NSDictionary *fourTabBarItemsAttributes = @{
        @"tabBarItemTitle" : @"会员购",
        @"tabBarViewController" : @"XYShopViewController",
        @"tabBarItemImage" : @"bottom_tabbar_mallhome_normal.png",
        @"tabBarItemSelectedImage" : @"bottom_tabbar_mallhome_selected.png"
    };
    
    NSDictionary *fiveTabBarItemsAttributes = @{
        @"tabBarItemTitle" : @"我的",
        @"tabBarViewController" : @"XYPersonalViewController",
        @"tabBarItemImage" : @"bottom_tabbar_user_center_normal.png",
        @"tabBarItemSelectedImage" : @"bottom_tabbar_user_center_selected.png"
    };
    
    NSArray <NSDictionary *> *tabBarItemsAttributes = @[
        firstTabBarItemsAttributes,
        twoTabBarItemsAttributes,
        threeTabBarItemsAttributes,
        fourTabBarItemsAttributes,
        fiveTabBarItemsAttributes
    ];
    
    NSMutableArray *tempNavArr = [NSMutableArray new];

    [tabBarItemsAttributes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         RTContainerNavigationController *nav = [self itemChildViewController:obj[@"tabBarViewController"] title:obj[@"tabBarItemTitle"] imageName:obj[@"tabBarItemImage"] selectedImage:obj[@"tabBarItemSelectedImage"]];
        [tempNavArr addObject:nav];
    }];
    
    self.viewControllers = tempNavArr;
    
    
}

- (void)initializeTabBarStatus {
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [UITabBarAppearance new];
        // 设置未被选中的颜色
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorFromHexString:kTabBarItemNormalTintColor],NSFontAttributeName:SYSTEMFONT(10.0f)};
        // 设置被选中时的颜色
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorFromHexString:kTabBarItemSelectedTintColor],NSFontAttributeName:SYSTEMFONT(10.0f)};
        
        /// 隐藏 tabBar 上面的线
//        appearance.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
//        appearance.shadowColor = [UIColor clearColor];

        /// 设置TabBar的背景颜色
        UIImage *backgroundImage = [UIImage imageWithColor:kNavigationColor size:self.tabBar.frame.size];
        appearance.backgroundImage =  backgroundImage;
        
        self.tabBar.standardAppearance = appearance;
        
    } else {
        //title设置
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:kTabBarItemNormalTintColor],NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:kTabBarItemSelectedTintColor],NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
        /// ios 13以下隐藏 tabbar 上面线的方法
        [self removeTabarTopLine];
    }
    
}

- (RTContainerNavigationController *)itemChildViewController:(NSString *)classsName
                                                title:(NSString *)title
                                            imageName:(NSString *)imageName
                                        selectedImage:(NSString *)selectedImage {
    
    
    Class classs = NSClassFromString(classsName);
    UIViewController *vc =  [classs new];
    
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    vc.tabBarItem.title = title;

    //导航
    RTContainerNavigationController *nav = [[RTContainerNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.topItem.title = title;
    
    return nav;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"点击了第几个 item %@",item);
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
}

- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}
#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

//ios 13以下 去掉tabBar顶部线条
- (void)removeTabarTopLine {
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    /**
     *CGColor适配
     *iOS13后，UIColor能够表示动态颜色，但是CGColor依然只能表示一种颜色。所以对于CALayer对象只能在traitCollectionDidChange方法中进行改变
    */

    if (@available(iOS 13.0, *)) {
         ///trait发生了改变
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            ///设置TabBar的背景颜色
            UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];

            UIImage *backgroundImage = [UIImage imageWithColor:kNavigationColor size:self.tabBar.frame.size];
            appearance.backgroundImage =  backgroundImage;
            self.tabBar.standardAppearance = appearance;
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
