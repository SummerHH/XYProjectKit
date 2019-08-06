//
//  XYTimeTools.m
//  fula
//
//  Created by xiyedev on 2017/7/20.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYTimeTools.h"

@implementation XYTimeTools

#pragma mark - 获取当前时间的 时间戳

+(long long)getNowTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间
    
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转13位时间戳的方法:(精确到毫秒)
    long long timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970] *1000] longLongValue];
    
//    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值
    
    return timeSp;
    
}

+ (NSString *)dateToString:(NSDate *)date andFormatter:(NSString *)format {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setDateFormat:format];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
    
}

+ (NSString *)getNowTimeTampFormat:(NSString *)tampFormat {

    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:tampFormat];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

//将某个时间戳转化成 时间

#pragma mark - 将某个时间戳转化成 时间

+(NSString *)timestampSwitchTime:(NSNumber *)timestamp andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    //十三位时间戳转时间需要/1000 十位时间戳你不需要
    long long interval = [timestamp longLongValue] / 1000;
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
//    NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    return confromTimespStr;
    
}

+ (NSDate *)timestampSwitchDate:(NSNumber *)date andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    //十三位时间戳转时间需要/1000 十位时间戳你不需要
    long long interval = [date longLongValue] / 1000;

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    
    return confromTimesp;
}

/*
 *时间戳转时间(时间的前一天)
 *format (@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 */
+(NSString *)timestampSwitchlastTime:(NSNumber *)timestamp andFormatter:(NSString *)format {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    //十三位时间戳转时间需要/1000 十位时间戳你不需要
    long long interval = [timestamp longLongValue] / 1000;

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDate *lastDay = [NSDate dateWithTimeInterval:(-24*60*60)*2 sinceDate:confromTimesp];//前两天
    
    NSString *confromTimespStr = [formatter stringFromDate:lastDay];

    return confromTimespStr;

}

//将某个时间转化成 时间戳

#pragma mark - 将某个时间转化成 时间戳

+ (long long)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];     
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970] *1000] longLongValue];
    
//    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    return timeSp;
}

+ (NSInteger)getDifferenceByDate:(NSString *)date {
    //获得当前时间
//    NSDate *now = [NSDate date];
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式
//    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//    NSDate *oldDate = [dateFormatter dateFromString:date];
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    unsigned int unitFlags = NSDayCalendarUnit;
//    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
//    return [comps day];
//
    //下面这种方法从00:00:00开始计算
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:date]];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
#pragma clang diagnostic pop

    return [dayComponents day];
}


+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02 {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02 > date01
        case NSOrderedAscending: ci=1; break;
            //date01 > date02
        case NSOrderedDescending: ci=-1; break;
            //date02 = date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}

/**
 * @brief 判断当前时间是否在fromDate和date2之间。
 */
+ (BOOL)isBetweenFromDate:(NSDate *)fromDate withDate:(NSDate *)date2 {
    
    NSDate *currentDate = [NSDate date];
    
    NSLog(@"该时间在--%@------%@----之间  -当前时间 %@ ",fromDate,date2,currentDate);

    if ([currentDate compare:fromDate]==NSOrderedDescending && [currentDate compare:date2]==NSOrderedAscending) {
      
        return YES;
    }
    return NO;
}

+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate =[date dateFromString:startTime];
    NSDate *endDdate = [date dateFromString:endTime];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:startDate toDate:endDdate options:0];
    
    // 天
    NSInteger day = [dateComponents day];
    // 小时
    NSInteger house = [dateComponents hour];
    // 分
    NSInteger minute = [dateComponents minute];
    // 秒
    NSInteger second = [dateComponents second];
    
    NSInteger timeSecond;
    
    if (day != 0) {
        /// 天 时 分 秒
        timeSecond = day * 24*60*60;
    }
    else if (day==0 && house !=0) {
        /// 小时 .分 ,秒
        timeSecond = house * 60 *60;
        
    }
    else if (day==0 && house==0 && minute!=0) {
        
        /// 分 秒
        timeSecond = minute *60;
    }
    else{
        timeSecond = second;
    }
    
    return timeSecond;
}


@end
