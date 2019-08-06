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
    // Do any additional setup after loading the view.
    
    NSArray *className = @[@"XYHomeViewController",@"XYChannelViewController",@"XYDynamicViewController",@"XYShopViewController",@"XYPersonalViewController"];
    
    NSArray *barName = @[@"首页",@"频道",@"动态",@"会员购",@"我的"];
    
    NSArray *barImageNor = @[@"bottom_tabbar_mainhome_normal.png",@"bottom_tabbar_pegasuschannel_normal.png",@"bottom_tabbar_followinghome_normal.png",@"bottom_tabbar_mallhome_normal.png",@"bottom_tabbar_user_center_normal.png"];
    
    NSArray *barImageSel = @[@"bottom_tabbar_mainhome_selected.png",@"bottom_tabbar_pegasuschannel_selected.png",@"bottom_tabbar_followinghome_selected.png",@"bottom_tabbar_mallhome_selected.png",@"bottom_tabbar_user_center_selected.png"];
    
    NSMutableArray *tempNavArr = [NSMutableArray new];
    for (int i = 0; i < className.count; i++) {
        RTContainerNavigationController *nav = [self itemChildViewController:className[i] title:barName[i] imageName:barImageNor[i] selectedImage:barImageSel[i]];
        
        [tempNavArr addObject:nav];
    }
    
    self.viewControllers = tempNavArr;
    
    // 设置 tabBar 的代理
    self.delegate = self;
    
}

- (RTContainerNavigationController *)itemChildViewController:(NSString *)classsName
                                                title:(NSString *)title
                                            imageName:(NSString *)imageName
                                        selectedImage:(NSString *)selectedImage {
    
    
    Class classs = NSClassFromString(classsName);
    UIViewController *vc =  [classs new];
    
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //title设置
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#757575"],NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#FB7299"],NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    vc.tabBarItem.title = title;

    //导航
    RTContainerNavigationController *nav = [[RTContainerNavigationController alloc] initWithRootViewController:vc];

    return nav;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"点击了第几个 item %@",item);
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

//去掉tabBar顶部线条
//- (void)removeTabarTopLine {
//    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.tabBar setBackgroundImage:img];
//    [self.tabBar setShadowImage:img];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
