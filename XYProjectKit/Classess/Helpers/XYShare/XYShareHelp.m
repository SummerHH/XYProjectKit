//
//  XYShareHelp.m
//  fula
//
//  Created by YeJiong on 2017/3/31.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYShareHelp.h"
#import "XYShareMenuView.h"
#import <UMAnalytics/MobClick.h>

@implementation XYShareHelp

+ (void)configUSharePlatforms {
    
    //设置友盟appkey

    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    [UMConfigure initWithAppkey:kUmengKey channel:@"App Store"]; // required
    /* 统计组件配置,启用DPlus功能 */
    [MobClick setScenarioType:E_UM_NORMAL];

    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAPPID appSecret:kWechatAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
 
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWeiboAPPKey  appSecret:kWeiboAppSecret redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    //  ......
    
    //设置可分享的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
#ifdef DEBUG
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
#endif
}

+ (void)confitUShareSettings {
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

#pragma mark ******  分享  *******

+ (void)shareTitle:(NSString *)title
          descr:(NSString *)descr
        thumbImage:(id)thumbImage
          shareURL:(NSString *)shareURL
currentViewController:(id)currentViewController
        completion:(UMSocialRequestCompletionHandler)completion {
    
   //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        // 根据获取的platformType确定所选平台进行下一步操作
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
        
        //设置网页地址
        shareObject.webpageUrl = shareURL;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
            
            if(completion) {
                completion(data, error);
            }
        }];
    }];
}

+ (void)shareTitle:(NSString *)title
             descr:(NSString *)descr
        thumbImage:(id)thumbImage
          shareURL:(NSString *)shareURL
currentViewController:(id)currentViewController
   shareToPlatform:(UMSocialPlatformType)platformType
        completion:(UMSocialRequestCompletionHandler)completion {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
    
    //设置网页地址
    shareObject.webpageUrl = shareURL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        NSDictionary *dict = (NSDictionary *)data;
        NSLog(@"----%@---",[XYJsonConversion jsonWithDictionary:dict]);
        if(completion) {
            completion(data, error);
        }
    }];
}

+ (void)shareImage:(id)shareImage
        thumbImage:(id)thumbImage
currentViewController:(id)currentViewController
        completion:(UMSocialRequestCompletionHandler)completion {
    

    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = thumbImage;
        [shareObject setShareImage:shareImage];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
            if(completion) {
                completion(data, error);
            }
        }];
    }];
}

+ (void)shareImage:(id)shareImage
        thumbImage:(id)thumbImage
currentViewController:(id)currentViewController
      platformType:(UMSocialPlatformType)platformType
        completion:(UMSocialRequestCompletionHandler)completion {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    if (thumbImage) {
        shareObject.thumbImage = thumbImage;
    }
    [shareObject setShareImage:shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        if(completion) {
            completion(data, error);
        }
    }];
}

+ (void)shareText:(NSString *)text
currentViewController:(id)currentViewController
       completion:(UMSocialRequestCompletionHandler)completion {
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {

        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //分享消息对象设置分享内容对象
        messageObject.text = text;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
            
            if(completion) {
                completion(data, error);
            }
        }];
    }];
}

+ (void)shareMusicTitle:(NSString *)title
               descr:(NSString *)descr
             thumbImage:(id)thumbImage
               musicUrl:(NSString *)musicUrl
  currentViewController:(id)currentViewController
             completion:(UMSocialRequestCompletionHandler)completion {
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建音乐内容对象
        UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
        //设置音乐网页播放地址
        shareObject.musicUrl = musicUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
            
            if(completion) {
                completion(data, error);
            }
        }];
    }];
}

+ (void)shareVideoTitle:(NSString *)title
                  descr:(NSString *)descr
             thumbImage:(id)thumbImage
               videoUrl:(NSString *)videoUrl
  currentViewController:(id)currentViewController
             completion:(UMSocialRequestCompletionHandler)completion {
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建视频内容对象
        UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
        //设置视频网页播放地址
        shareObject.videoUrl = videoUrl;
    
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
            
            if(completion) {
                completion(data, error);
            }
        }];
        
    }];
}

+ (void)shareMenuViewInTitle:(NSString *)title
                       descr:(NSString *)descr
                  thumbImage:(id)thumbImage
                    shareURL:(NSString *)shareURL
       currentViewController:(id)currentViewController
                  completion:(UMSocialRequestCompletionHandler)completion {
    
    
    NSMutableArray *platformArr = [NSMutableArray new];
    NSMutableArray *typeArr = [NSMutableArray new];
    
    //已安装的平台且支持分享
    if([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] && [[UMSocialManager defaultManager] isSupport:UMSocialPlatformType_WechatSession]) {
    
        NSDictionary *param = @{
                                @"title" : @"微信",
                                @"image" : @"share_WeiChat.png"
                                };
        [platformArr addObject:param];
        [typeArr addObject:@(UMSocialPlatformType_WechatSession)];
    }

    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine] && [[UMSocialManager defaultManager] isSupport:UMSocialPlatformType_WechatTimeLine]) {
    
        NSDictionary *param = @{
                                @"title" : @"朋友圈",
                                @"image" : @"share_WeiChatline.png"
                                };
        [platformArr addObject:param];
        [typeArr addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }

    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ] && [[UMSocialManager defaultManager] isSupport:UMSocialPlatformType_QQ]) {

        NSDictionary *param = @{
                                @"title" : @"QQ",
                                @"image" : @"share_QQ.png"
                                };
        [platformArr addObject:param];
        [typeArr addObject:@(UMSocialPlatformType_QQ)];
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone] && [[UMSocialManager defaultManager] isSupport:UMSocialPlatformType_Qzone]) {

        NSDictionary *param = @{
                                @"title" : @"QQ空间",
                                @"image" : @"share_QQZone.png"
                                };
        [platformArr addObject:param];
        [typeArr addObject:@(UMSocialPlatformType_Qzone)];
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina] && [[UMSocialManager defaultManager] isSupport:UMSocialPlatformType_Sina]) {

        NSDictionary *param = @{
                                @"title" : @"微博",
                                @"image" : @"share_WeiBo.png"
                                };
        [platformArr addObject:param];
        [typeArr addObject:@(UMSocialPlatformType_Sina)];
    }
    
    XYShareMenuView *menuView = [XYShareMenuView alertShareMenuButtonTitleAndImages:platformArr columnNums:5 completion:^(NSInteger index) {
        //索引从0开始  -1 代表取消了视图
        if (index >= 0) {
            
            UMSocialPlatformType platformType = [typeArr[index] integerValue];
            [self shareTitle:title descr:descr thumbImage:thumbImage shareURL:shareURL currentViewController:currentViewController shareToPlatform:platformType completion:completion];
        }
    }];
    
    [menuView showShareMenuView];
}

#pragma mark ******  第三方登录  *******
+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
                    completion:(void(^)(UMSocialUserInfoResponse *result, NSError *error))completion {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
       
        UMSocialUserInfoResponse *resp = result;
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if (completion) {
            completion(resp, error);
        }

    }];
}

@end
