//
//  XYShareHelp.h
//  fula
//
//  Created by YeJiong on 2017/3/31.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

@interface XYShareHelp : NSObject

#pragma mark ******  一下方法在 APPDelegate 中注册  *******

/**
 *  初始化第三方分享
 */

+ (void)configUSharePlatforms;

/**
 *  分享设置
 */

+ (void)confitUShareSettings;

#pragma mark ******  分享  *******


/**
 *  自定义分享网页类型
 *
 *  @param title 分享的标题
 *  @param descr 描述
 *  @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *  @param shareURL 分享的url
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   分享回调
 */

+ (void)shareTitle:(NSString *)title
          descr:(NSString *)descr
        thumbImage:(id)thumbImage
          shareURL:(NSString *)shareURL
currentViewController:(id)currentViewController
        completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  自定义分享单个平台网页类型
 *
 *  @param title 分享的标题
 *  @param descr 描述
 *  @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *  @param shareURL 分享的url
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param platformType 分享预定义平台
 *  @param completion   分享回调
 */
+ (void)shareTitle:(NSString *)title
             descr:(NSString *)descr
        thumbImage:(id)thumbImage
          shareURL:(NSString *)shareURL
currentViewController:(id)currentViewController
   shareToPlatform:(UMSocialPlatformType)platformType
        completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  自定义多平台分享图片类型
 *
 *  @param shareImage 分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）
 *  @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   分享回调
 */

+ (void)shareImage:(id)shareImage
        thumbImage:(id)thumbImage
currentViewController:(id)currentViewController
        completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  自定义单个平台分享图片类型
 *
 *  @param shareImage 分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）
 *  @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param platformType 分享预定义平台
 *  @param completion   分享回调
 */

+ (void)shareImage:(id)shareImage
        thumbImage:(id)thumbImage
currentViewController:(id)currentViewController
      platformType:(UMSocialPlatformType)platformType
        completion:(UMSocialRequestCompletionHandler)completion;


/**
 *  自定义分享文本类型
 *
 *  @param text 文本内容
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   分享回调
 */

+ (void)shareText:(NSString *)text
currentViewController:(id)currentViewController
       completion:(UMSocialRequestCompletionHandler)completion;


/**
 *  自定义分享音乐类型
 *
 *  @param title 分享的标题
 *  @param descr 描述
 *  @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *  @param musicUrl 分享音乐的url
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   分享回调
 */

+ (void)shareMusicTitle:(NSString *)title
               descr:(NSString *)descr
             thumbImage:(id)thumbImage
               musicUrl:(NSString *)musicUrl
  currentViewController:(id)currentViewController
             completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  自定义分享视频类型
 *  @param title 标题
 *  @param descr 描述
 *  @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *  @param videoUrl 分享音乐的url
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion  分享回调
 */

+ (void)shareVideoTitle:(NSString *)title
                  descr:(NSString *)descr
             thumbImage:(id)thumbImage
               videoUrl:(NSString *)videoUrl
  currentViewController:(id)currentViewController
             completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  自定义分享面板
 *
 *  @param title 分享的标题
 *  @param descr 描述
 *  @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *  @param shareURL 分享的url
 *  @param currentViewController  用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   分享回调
 */

+ (void)shareMenuViewInTitle:(NSString *)title
                       descr:(NSString *)descr
                  thumbImage:(id)thumbImage
                    shareURL:(NSString *)shareURL
       currentViewController:(id)currentViewController
                  completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  UM第三方登录
 *  @param platformType 分享预定义平台
 *  @param completion 登录回调
 */

+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
                    completion:(void(^)(UMSocialUserInfoResponse *result, NSError *error))completion;

@end
