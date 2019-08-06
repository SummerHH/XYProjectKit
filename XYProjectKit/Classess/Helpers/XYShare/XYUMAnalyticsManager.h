//
//  XYUMAnalyticsManager.h
//  LeRongRong
//
//  Created by xiaoye on 2019/6/25.
//  Copyright © 2019 Rong Zheng De. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ads_click;
extern NSString * const catergory_label;
extern NSString * const article_search_label;
extern NSString * const read_topic;
extern NSString * const read_article;
extern NSString * const topic_search_label;
extern NSString * const video_search_label;
extern NSString * const video_player;
extern NSString * const category_search_label;

@interface XYUMAnalyticsManager : NSObject

/**
 *  计数事件
 *
 *  @param eventId 网站上注册的事件Id
 */
+ (void)event:(NSString *)eventId;

/**
 *  计数事件
 *
 *  @param eventId 网站上注册的事件Id
 *  @param label 分类标签
 */
+ (void)event:(NSString *)eventId label:(NSString *)label;

/**
 *  计数事件
 *
 *  @param eventId 网站上注册的事件Id
 *  @param attributes 属性中的key－value必须为String类型
 */

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

/**
 *  计数事件
 *
 *  @param eventId 网站上注册的事件Id
 *  @param attributes 属性中的key－value必须为String类型
 *  @param number 自定义数值
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number;

/**
 *  计算事件
 *  @brief beginEvent需要和endEvent配对使用，需要传入相同的eventId。
 *  @param eventId 网站上注册的事件Id
 */

+ (void)beginEvent:(NSString *)eventId;
+ (void)endEvent:(NSString *)eventId;
/**
 *  计算事件
 *  @brief beginEvent需要和endEvent配对使用，需要传入相同的eventId。
 *  @param eventId 网站上注册的事件Id
 *  @param label 分类标签
 */
+ (void)beginEvent:(NSString *)eventId label:(NSString *)label;
+ (void)endEvent:(NSString *)eventId label:(NSString *)label;

/**
 *  计算事件
 *  @brief beginEvent需要和endEvent配对使用，需要传入相同的eventId。
 *  @param eventId 网站上注册的事件Id
 *  @param keyName 唯一标识不会被系统统计
 */

+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes;
+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName;

/**
 *  计算事件
 *  @param eventId 网站上注册的事件Id
 *  @param millisecond 传入自己统计的时长毫秒
 */

+ (void)event:(NSString *)eventId durations:(int)millisecond;
+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond;
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond;

/**
 *  页面统计
 *
 *  @brief beginEvent需要和endEvent配对使用，单独使用无效
 *  @param pageName 页面路径
 *  @param seconds 停留的时长
 */

+ (void)logPageView:(NSString *)pageName seconds:(int)seconds;
+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;

/**
 *  账号统计
 *
 *  @param puid 用户 id
 *  @param provider 账号来源
 */

+ (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider;
+ (void)profileSignInWithPUID:(NSString *)puid;
+ (void)profileSignOff;


/**
 *  @brief 自动采集页面设置
 *
 *  @param value 用于设置是否自动采集页面，默认是不自动采集，此接口只能设置一次，建议在初始化之前设置。
 */

+ (void)setAutoPageEnabled:(BOOL)value;


@end

NS_ASSUME_NONNULL_END
