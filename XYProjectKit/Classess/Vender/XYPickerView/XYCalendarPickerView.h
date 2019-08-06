//
//  XYCalendarPickerView.h
//  fula
//
//  Created by 叶炯 on 2018/1/8.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "XYBaseView.h"

typedef void(^XYCalendarResultBlock)(id selectValue);

@interface XYCalendarPickerView : XYBaseView

/**
 *  显示自定义字符串选择器
 *
 *  @param title            标题
 *  @param dataSource       数组数据源
 *  @param defaultSelValue  默认选中
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showCalendarPickerWithTitle:(NSString *)title
                       dataSource:(NSArray *)dataSource
                  defaultSelValue:(NSNumber *)defaultSelValue
                      resultBlock:(XYCalendarResultBlock)resultBlock;

@end
