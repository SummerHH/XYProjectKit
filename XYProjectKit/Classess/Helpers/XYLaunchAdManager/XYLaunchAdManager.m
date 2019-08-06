//
//  XYLaunchAdManager.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/10.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYLaunchAdManager.h"
#import <XHLaunchAd.h>
#import "WKWebViewController.h"
#import "XYHomeViewController.h"

@interface XYLaunchAdManager ()<XHLaunchAdDelegate>

@end

@implementation XYLaunchAdManager

+ (instancetype)sharedInstance {

    static XYLaunchAdManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYLaunchAdManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {

    if (self = [super init]) {
        
//在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            //初始化开屏广告
            [self loadLaunchImageAd];
        }];
    }
    return self;
}

- (void)loadLaunchImageAd {
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
    imageAdconfiguration.frame = [UIScreen mainScreen].bounds;
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"lunchAdImage2.gif";
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    imageAdconfiguration.GIFImageCycleOnce = NO;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = @"https://github.com/";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeRoundProgressText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {
    
    NSLog(@"广告点击的回调");
    WKWebViewController *webView = [[WKWebViewController alloc] init];
    [webView loadWebURLSring:(NSString *)openModel];
    NSLog(@"广告点击的回调点击 %@ ",NSStringFromClass([[[AppDelegate shareAppDelegate] getCurrentUIVC] class]));
    
    XYHomeViewController *homeVC = [[XYHomeViewController alloc] init];
    
    UIViewController *rootVC = [[AppDelegate shareAppDelegate] getCurrentVC];
    if ([rootVC isKindOfClass:[RTRootNavigationController class]]) {
        RTRootNavigationController *vc = (RTRootNavigationController *)rootVC;
        [vc.rt_topViewController.rt_navigationController pushViewController:homeVC animated:YES complete:nil];
    }
}

-(void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData {
    
    NSLog(@"图片本地读取/或下载完成回调");
}

-(void)xhLaunchAd:(XHLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration {
    
    NSLog(@"倒计时回调");
}

-(void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd {
    
    NSLog(@"广告显示完成");
}


@end
