//
//  XYUMAnalyticsManager.m
//  LeRongRong
//
//  Created by xiaoye on 2019/6/25.
//  Copyright © 2019 Rong Zheng De. All rights reserved.
//

#import "XYUMAnalyticsManager.h"

NSString * const ads_click = @"ads_click";
NSString * const catergory_label = @"catergory_label";
NSString * const article_search_label = @"article_search_label";
NSString * const read_topic = @"read_topic";
NSString * const read_article = @"read_article";
NSString * const topic_search_label = @"topic_search_label";
NSString * const video_search_label = @"video_search_label";
NSString * const video_player = @"video_player";
NSString * const category_search_label = @"category_search_label";


@implementation XYUMAnalyticsManager

+ (void)event:(NSString *)eventId {
    
    [MobClick event:eventId];
}

+ (void)event:(NSString *)eventId label:(NSString *)label {
    
    [MobClick event:eventId label:label];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    
    [MobClick event:eventId attributes:attributes];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number {
    
    [MobClick event:eventId attributes:attributes counter:number];
}

+ (void)beginEvent:(NSString *)eventId {
    
    [MobClick beginEvent:eventId];
}

+ (void)endEvent:(NSString *)eventId {
    
    [MobClick endEvent:eventId];
}

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label {
    
    [MobClick beginEvent:eventId label:label];
}

+ (void)endEvent:(NSString *)eventId label:(NSString *)label {
    
    [MobClick endEvent:eventId label:label];
}

+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes {
    
    [MobClick beginEvent:eventId primarykey:keyName attributes:attributes];
}

+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName {
    
    [MobClick endEvent:eventId primarykey:keyName];
}

+ (void)event:(NSString *)eventId durations:(int)millisecond {
    
    [MobClick event:eventId durations:millisecond];
}

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond {
    
    [MobClick event:label label:label durations:millisecond];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond {
    
    [MobClick event:eventId attributes:attributes counter:millisecond];
}

+ (void)logPageView:(NSString *)pageName seconds:(int)seconds {
    
    [MobClick logPageView:pageName seconds:seconds];
}

+ (void)beginLogPageView:(NSString *)pageName {
    
    NSLog(@"--开始--%@----",pageName);

    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName {
    
    NSLog(@"--结束--%@----",pageName);
    [MobClick endLogPageView:pageName];
}

+ (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider {
    
    [MobClick profileSignInWithPUID:puid provider:provider];
}

+ (void)profileSignInWithPUID:(NSString *)puid {
 
    [MobClick profileSignInWithPUID:puid];
}

+ (void)profileSignOff {
    
    [MobClick profileSignOff];
}

+ (void)setAutoPageEnabled:(BOOL)value {
    
    [MobClick setAutoPageEnabled:value];
}

@end
