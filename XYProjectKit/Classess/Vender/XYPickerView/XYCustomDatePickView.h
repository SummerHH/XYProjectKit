//
//  XYCustomDatePickView.h
//  fula
//
//  Created by xiaoye on 2018/5/11.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "XYBaseView.h"

typedef void(^XYSelectDateResultBlock)(NSDate *selectValue);

typedef NS_ENUM(NSUInteger, XYDatePickerStyle) {
    XYDateStyleShowYearMonthDayHourMinute  = 0,//年月日时分
    XYDateStyleShowMonthDayHourMinute,//月日时分
    XYDateStyleShowYearMonthDay,//年月日
    XYDateStyleShowYearMonth,//年月
    XYDateStyleShowMonthDay,//月日
    XYDateStyleShowHourMinute//时分
};

@interface XYCustomDatePickView : XYBaseView

/**
 *  显示时间选择器
 *
 *  @param title            标题
 *  @param datePickerStyle  时间样式
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minLimitDate     限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 *  @param maxLimitDate     限制最大时间
 *  @param resultBlock      选择结果的回调
 */
+ (void)showCustomDatePickerWithTitle:(NSString *)title
                      datePickerStyle:(XYDatePickerStyle)datePickerStyle
                      defaultSelValue:(NSDate *)defaultSelValue
                         minLimitDate:(NSDate *)minLimitDate
                         maxLimitDate:(NSDate *)maxLimitDate
                         isAutoSelect:(BOOL)isAutoSelect
                          resultBlock:(XYSelectDateResultBlock)resultBlock;





@end
