//
//  XYTimeTools.h
//  fula
//
//  Created by xiyedev on 2017/7/20.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYTimeTools : NSObject

/*
 *获取当前系统时间的十三位时间戳
 */
+(long long)getNowTimestamp;

/**
 *  NSDate转 字符串
 */

+ (NSString *)dateToString:(NSDate *)date andFormatter:(NSString *)format;

/**
 * 获取当前时间
 */
+ (NSString *)getNowTimeTampFormat:(NSString *)tampFormat;
/*
 *时间戳转时间
 *format (@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 */
+(NSString *)timestampSwitchTime:(NSNumber *)timestamp andFormatter:(NSString *)format;

+(NSDate *)timestampSwitchDate:(NSNumber *)date andFormatter:(NSString *)format;
    
/*
 *时间戳转时间(时间的前一天)
 *format (@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 */
+(NSString *)timestampSwitchlastTime:(NSNumber *)timestamp andFormatter:(NSString *)format;

/*
 *将某个时间转化成 时间戳
 *formatTime 时间字符串
 *format (@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 */
+ (long long)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
/*
 *某日和当前日期相隔多少天
 */
+ (NSInteger)getDifferenceByDate:(NSString *)date;

/**
 *日期格式请传入：2013-08-05 12:12:12；如果修改日期格式，比如：2013-08-05，则将[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];修改为[df setDateFormat:@"yyyy-MM-dd"];
 */
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

/**
 * @brief 判断当前时间是否在fromDate和date2之间。
 */
+ (BOOL)isBetweenFromDate:(NSDate *)fromDate withDate:(NSDate *)date2;

/**
 * @brief 判断两个时间差 返回的是秒
 */
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
